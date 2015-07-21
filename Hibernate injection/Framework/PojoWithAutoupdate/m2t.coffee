# include dependencies
common = require '../common'

# define templates
exports.mappedType = (field) -> switch field
							when "string" then "String"
							when "date" then "java.util.Date"
							when "bool" then "boolean"
							else field
exports.fieldType = (item) -> if item.multiplicity and item.multiplicity[1] != "1" then "java.util.List<" + exports.mappedType(item.type) + ">" else exports.mappedType(item.type)
exports.propertyName = (str) -> common.firstUpper(str)

# attribute templates
exports.attributeText = (attribute) -> "#{exports.preAttributeFieldDeclaration(attribute)}	private #{exports.fieldType(attribute)} #{attribute.name};"
exports.attributeProperty = (attribute) -> 							
							"	public #{exports.fieldType(attribute)} get#{exports.propertyName(attribute.name)}() { return #{attribute.name}; }\n" + 
							"	public void set#{exports.propertyName(attribute.name)}(#{exports.fieldType(attribute)} value) { \n" +							
							"		#{attribute.name} = value;\n" +
							"	}\n" 

# association templates
exports.fieldInitializer = (association) ->
	if association.multiplicity[1] != "1" 
		if association.other.multiplicity[1] != "1"
			" = new java.util.LinkedHashSet<>()" 
		else
			" = new java.util.ArrayList<>()"
	else 
		""
exports.associationText = (association) -> "#{exports.preAssociationFieldDeclaration(association)}	private #{exports.fieldType(association)} #{association.name}#{exports.fieldInitializer(association)};"
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
exports.bidirectionalHelpers = (association) -> 
	if association.multiplicity[1] != "1"  then (exports.addItem(association) + exports.removeItem(association)) else exports.setItemTemplate(association)
exports.setItemTemplate = (association) ->"	public void set#{exports.propertyName(association.name)} (#{exports.fieldType(association)} item) {\n" +
								"		#{exports.fieldType(association)} prevItem = get#{exports.propertyName(association.name)}(); \n" + 
								"		if (prevItem == item) return; \n" + 
								"		set#{exports.propertyName(association.name)}Direct(item); \n" + 
        						"		if (prevItem != null) #{exports.resetSetterOtherEnd(association, 'prevItem')} \n" +  
        						"		if (item != null) #{exports.setSetterOtherEnd(association)}\n" +  
    							"	}\n"  
exports.resetSetterOtherEnd = (association, itemName) -> 
		if association.other.multiplicity[1] != "1"
			"#{itemName}.get#{exports.propertyName(association.other.name)}().remove(this);"
		else
			"#{itemName}.set#{exports.propertyName(association.other.name)}Direct(null);"
exports.setSetterOtherEnd = (association) -> 		
		if association.other.multiplicity[1] != "1"
			"item.get#{exports.propertyName(association.other.name)}().add(this);"															
		else
			"item.set#{exports.propertyName(association.other.name)}Direct(this);"
exports.associationProperty = (association) -> 							
							"	public #{exports.fieldType(association)} get#{exports.propertyName(association.name)}() { return #{association.name}; }\n" +
							"	void set#{exports.propertyName(association.name)}Direct(#{exports.fieldType(association)} value) { #{association.name} = value; }\n" + 
							exports.bidirectionalHelpers(association)


# injection points
exports.preAttributeFieldDeclaration = (attribute) -> ""
exports.preAssociationFieldDeclaration = (association) -> ""
exports.preClassDeclaration = (clazz) -> ""

# class templates
exports.classText = (namespace, clazz) -> "package #{namespace};\n\n" +
						"#{exports.preClassDeclaration(clazz)}" + 
						"public class #{clazz.name}" + ([" extends #{clazz.superType}" if clazz.superType]) + " {\n\n" + 
						(clazz.attributes.map (attribute) -> exports.attributeText(attribute)).join("\n\n") + "\n\n" + 
						(clazz.associations.map (association) -> exports.associationText(association)).join("\n\n") + "\n\n" + 
						(clazz.attributes.map (attribute) -> exports.attributeProperty(attribute)).join("\n") + "\n\n" + 
						(clazz.associations.map (association) -> exports.associationProperty(association)).join("\n") + 
						"}"

# enum templates
exports.enumText = (namespace, enumItem) -> 
						"package #{namespace};\n\n" + 
						"public enum #{enumItem.name} {\n" + 						
  						"	#{enumItem.values.join('\n	,')}\n" +
						"}"