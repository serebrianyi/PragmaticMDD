# setup dependencies
fs = require 'fs'

# load inputModel
inputModel = require __dirname + '\\models\\library.json'

# transform inputModel
# copy everything except of the assocations
outputModel = { classes: inputModel.classes.map (clazz) ->  { name: clazz.name, attributes: clazz.attributes, associations: [], namespace: inputModel.namespace }}

# split every association into association ends and add them to the corresponding classes
inputModel.associations.forEach (association) -> 
	# generate default names for assocation ends
	association.sourceName = association.sourceName || 	(if association.targetMultiplicity[1] == "*" then association.target.toLowerCase() + "s" else association.target.toLowerCase())
	association.targetName = association.targetName || 	(if association.sourceMultiplicity[1] == "*" then association.source.toLowerCase() + "s" else association.source.toLowerCase())

	# add source end of the association to the source class
	sourceClass = (outputModel.classes.filter (clazz) -> clazz.name == association.source)[0]
	sourceClass.associations.push {	name: association.sourceName, type: association.target, multiplicity: association.targetMultiplicity }
	# add target end of the association to the target class
	targetClass = (outputModel.classes.filter (clazz) -> clazz.name == association.target)[0]
	targetClass.associations.push { name: association.targetName, type: association.source, multiplicity: association.sourceMultiplicity }


# define templates
mappedType = (field) -> switch field
							when "string" then "String"
							when "date" then "java.util.Date"
							else field
fieldType = (item) -> if item.multiplicity and item.multiplicity[1] != "1" then "java.util.List<" + mappedType(item.type) + ">" else mappedType(item.type)
propertyName = (str) -> str.charAt(0).toUpperCase() + str.slice(1) # format property name: name -> Name

field = (attribute) -> "	private #{fieldType(attribute)} #{attribute.name};"
property = (association) -> "	public #{fieldType(association)} get#{propertyName(association.name)}() { return #{association.name}; }\n" +
									   "	public void set#{propertyName(association.name)}(#{fieldType(association)} value) { #{association.name} = value; }\n"							

# class templates
classText = (clazz) ->  "package #{clazz.namespace};\n\n\n" + 
						"public class #{clazz.name} {\n\n" + 
						(clazz.attributes.map (attribute) -> field(attribute)).join("\n\n") + "\n\n" + 
						(clazz.associations.map (association) -> field(association)).join("\n\n") + "\n\n" + 
						(clazz.attributes.map (attribute) -> property(attribute)).join("\n") + "\n\n" + 
						(clazz.associations.map (association) -> property(association)).join("\n") + 
						"}"

# save all classes into separate files
outputModel.classes.forEach (clazz) ->
	filename = __dirname + "\\output\\" + clazz.name + ".java"	
	fs.writeFileSync filename, classText(clazz)
	console.log "Saved generated file " + filename