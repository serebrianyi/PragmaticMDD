# setup dependencies
fs = require 'fs'

# load inputModel
inputModel = require __dirname + '\\models\\library.json'

# transform inputModel
# copy everything except of the assocations
outputModel = { classes: inputModel.classes.map (clazz) ->  { name: clazz.name, attributes: clazz.attributes, associations: [], namespace: inputModel.namespace }}

# split every association into association ends and add them to the corresponding classes
inputModel.associations.forEach (association) -> 
	# generate default names for assocations
	association.sourceName = association.sourceName || 	(if association.targetMultiplicity[1] == "*" then association.target.toLowerCase() + "s" else association.target.toLowerCase())
	association.targetName = association.targetName || 	(if association.sourceMultiplicity[1] == "*" then association.source.toLowerCase() + "s" else association.source.toLowerCase())

	# add source end of the association to the source class
	sourceClass = (outputModel.classes.filter (clazz) -> clazz.name == association.source)[0]
	sourceClass.associations.push { 
		name: association.sourceName, type: association.target, multiplicity: association.targetMultiplicity,
		otherName: association.targetName, otherType: association.source, otherMultiplicity: association.sourceMultiplicity
	}
	# add target end of the association to the target class
	targetClass = (outputModel.classes.filter (clazz) -> clazz.name == association.target)[0]
	targetClass.associations.push { 
		name: association.targetName, type: association.source, multiplicity: association.sourceMultiplicity,
		otherName: association.sourceName, otherType: association.target, otherMultiplicity: association.targetMultiplicity
	}

# define templates
mappedType = (field) -> switch field
							when "string" then "String"
							when "date" then "java.util.Date"
							else field
fieldType = (item) -> if item.multiplicity and item.multiplicity[1] != "1" then "java.util.List<" + mappedType(item.type) + ">" else mappedType(item.type)
propertyName = (str) -> str.charAt(0).toUpperCase() + str.slice(1) # format property name: name -> Name

# attribute templates
attributeText = (attribute) -> "	private #{fieldType(attribute)} #{attribute.name};"
attributeProperty = (attribute) -> 							
							"	public #{fieldType(attribute)} get#{propertyName(attribute.name)}() { return #{attribute.name}; }\n" + 
							"	public void set#{propertyName(attribute.name)}(#{fieldType(attribute)} value) { \n" +							
							"		#{attribute.name} = value;\n" +
							"	}\n" 

# association templates
fieldInitializer = (association) -> [" = new java.util.ArrayList<>()" if association.multiplicity[1] != "1"]
associationText = (association) -> "	private #{fieldType(association)} #{association.name} #{fieldInitializer(association)};"
addItem = (association) -> 
							"	public void add#{propertyName(association.name)}Item(#{association.type} item) {\n" +
        						"	if (item != null) {\n" +
        						"			get#{propertyName(association.name)}().add(item);\n" +
        						"			#{setSetterOtherEnd(association)}\n" +        
        						"		}\n" +
    						"	}\n"
removeItem = (association) -> 
							"	public boolean remove#{propertyName(association.name)}Item(#{association.type} item) {\n" +
        						"		if (item != null && get#{propertyName(association.name)}().remove(item)) {\n" +        						
        						"			#{resetSetterOtherEnd(association, 'item')}\n" +        
        						"			return true;\n" +
        						"		}\n" +
        						"		return false;\n" +
    							"	}\n"
bidirectionalHelpers = (association) -> if association.multiplicity[1] != "1" then (addItem(association) + removeItem(association)) else setItemTemplate(association)
setItemTemplate = (association) ->"	public void set#{propertyName(association.name)} (#{fieldType(association)} item) {\n" +
								"		#{fieldType(association)} prevItem = get#{propertyName(association.name)}(); \n" + 
								"		if (prevItem == item) return; \n" + 
								"		set#{propertyName(association.name)}Direct(item); \n" + 
        						"		if (prevItem != null) #{resetSetterOtherEnd(association, 'prevItem')} \n" +  
        						"		if (item != null) #{setSetterOtherEnd(association)}\n" +  
    							"	}\n"  
resetSetterOtherEnd = (association, itemName) -> 
		if association.otherMultiplicity[1] != "1"
			"#{itemName}.get#{propertyName(association.otherName)}().remove(this);"
		else
			"#{itemName}.set#{propertyName(association.otherName)}Direct(null);"
setSetterOtherEnd = (association) -> 
		if association.otherMultiplicity[1] != "1"
			"item.get#{propertyName(association.otherName)}().add(this);"															
		else
			"item.set#{propertyName(association.otherName)}Direct(this);"
associationProperty = (association) -> 							
							"	public #{fieldType(association)} get#{propertyName(association.name)}() { return #{association.name}; }\n" +
							"	private void set#{propertyName(association.name)}Direct(#{fieldType(association)} value) { #{association.name} = value; }\n" + 
							bidirectionalHelpers(association)

# class templates
classText = (clazz) -> "package #{clazz.namespace};\n\n\n" + 
						"public class #{clazz.name}" + " {\n\n" + 
						(clazz.attributes.map (attribute) -> attributeText(attribute)).join("\n\n") + "\n\n" + 
						(clazz.associations.map (association) -> associationText(association)).join("\n\n") + "\n\n" + 
						(clazz.attributes.map (attribute) -> attributeProperty(attribute)).join("\n") + "\n\n" + 
						(clazz.associations.map (association) -> associationProperty(association)).join("\n") + 
						"}"

# save all classes into separate files
outputModel.classes.forEach (clazz) ->
	filename = __dirname + "\\output\\" + clazz.name + ".java"	
	fs.writeFileSync filename, classText(clazz)
	console.log "Saved generated file " + filename