# define templates
exports.mappedType = (field) -> switch field
							when "string" then "String"
							when "date" then "java.util.Date"
							else field
exports.fieldType = (item) -> if item.multiplicity and item.multiplicity[1] != "1" then "java.util.List<" + exports.mappedType(item.type) + ">" else exports.mappedType(item.type)
exports.propertyName = (str) -> str.charAt(0).toUpperCase() + str.slice(1) # format property name: name -> Name

# attribute templates
exports.attributeText = (attribute) -> "	private #{exports.fieldType(attribute)} #{attribute.name};"
exports.attributeProperty = (attribute) -> 							
							"	public #{exports.fieldType(attribute)} get#{exports.propertyName(attribute.name)}() { return #{attribute.name}; }\n" + 
							"	public void set#{exports.propertyName(attribute.name)}(#{exports.fieldType(attribute)} value) { \n" +							
							"		#{attribute.name} = value;\n" +
							"	}\n" 

# association templates
exports.fieldInitializer = (association) -> [" = new java.util.ArrayList<>()" if association.multiplicity[1] != "1"]
exports.associationText = (association) -> "	private #{exports.fieldType(association)} #{association.name} #{exports.fieldInitializer(association)};"
exports.addItem = (association) -> 
							"	public void add#{exports.propertyName(association.name)}Item(#{association.type} item) {\n" +
        						"	if (item != null) {\n" +
        						"			get#{exports.propertyName(association.name)}().add(item);\n" +
        						"			#{exports.setSetterOtherEnd(association)}\n" +        
        						"		}\n" +
    						"	}\n"
exports.removeItem = (association) -> 
							"	public boolean remove#{exports.propertyName(association.name)}Item(#{association.type} item) {\n" +
        						"		if (item != null && get#{exports.propertyName(association.name)}().remove(item)) {\n" +        						
        						"			#{exports.resetSetterOtherEnd(association, 'item')}\n" +        
        						"			return true;\n" +
        						"		}\n" +
        						"		return false;\n" +
    							"	}\n"
exports.bidirectionalHelpers = (association) -> if association.multiplicity[1] != "1" then (exports.addItem(association) + exports.removeItem(association)) else exports.setItemTemplate(association)
exports.setItemTemplate = (association) ->"	public void set#{exports.propertyName(association.name)} (#{exports.fieldType(association)} item) {\n" +
								"		#{exports.fieldType(association)} prevItem = get#{exports.propertyName(association.name)}(); \n" + 
								"		if (prevItem == item) return; \n" + 
								"		set#{exports.propertyName(association.name)}Direct(item); \n" + 
        						"		if (prevItem != null) #{exports.resetSetterOtherEnd(association, 'prevItem')} \n" +  
        						"		if (item != null) #{exports.setSetterOtherEnd(association)}\n" +  
    							"	}\n"  
exports.resetSetterOtherEnd = (association, itemName) -> 
		if association.otherMultiplicity[1] != "1"
			"#{itemName}.get#{exports.propertyName(association.otherName)}().remove(this);"
		else
			"#{itemName}.set#{exports.propertyName(association.otherName)}Direct(null);"
exports.setSetterOtherEnd = (association) -> 
		if association.otherMultiplicity[1] != "1"
			"item.get#{exports.propertyName(association.otherName)}().add(this);"															
		else
			"item.set#{exports.propertyName(association.otherName)}Direct(this);"
exports.associationProperty = (association) -> 							
							"	public #{exports.fieldType(association)} get#{exports.propertyName(association.name)}() { return #{association.name}; }\n" +
							"	private void set#{exports.propertyName(association.name)}Direct(#{exports.fieldType(association)} value) { #{association.name} = value; }\n" + 
							exports.bidirectionalHelpers(association)

# class templates
exports.classText = (namespace, clazz) -> "package #{namespace};\n\n\n" + 
						"public class #{clazz.name}" + " {\n\n" + 
						(clazz.attributes.map (attribute) -> exports.attributeText(attribute)).join("\n\n") + "\n\n" + 
						(clazz.associations.map (association) -> exports.associationText(association)).join("\n\n") + "\n\n" + 
						(clazz.attributes.map (attribute) -> exports.attributeProperty(attribute)).join("\n") + "\n\n" + 
						(clazz.associations.map (association) -> exports.associationProperty(association)).join("\n") + 
						"}"