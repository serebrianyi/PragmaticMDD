
exports.transformClasses = (inputModel, outputModel) -> 
	inputModel.classes.forEach (clazz) -> 
		# copy everything except of the assocations
		transformedClass = { name: clazz.name, superType: clazz.superType }	
		transformedClass.associations = []
		transformedClass.attributes = 
			clazz.attributes.map (attribute) ->
				transformedAttribute = attribute
				predefinedType = (inputModel.customTypes.filter (type) -> type.name == attribute.type)[0]
				# for attributes with custom type, that are not enums, resolve the type to the primitive type
				# e.g. string 10 -> string
				if predefinedType and predefinedType.primitiveType != "enum"
					transformedAttribute.type = predefinedType.primitiveType
				# include the full type information into attribute's definition 
				# so that we don't need to look for it in the model
				transformedAttribute.typeInformation = predefinedType
				return transformedAttribute		
		outputModel.classes.push transformedClass

exports.transformAssociations = (inputModel, outputModel) ->
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

# copy enmus
exports.transformEnums = (inputModel, outputModel) -> outputModel.enums = inputModel.customTypes.filter (type) -> type.primitiveType == "enum"

exports.transformModel = (inputModel) ->
	outputModel = {classes: []}
	exports.transformClasses inputModel, outputModel
	exports.transformAssociations inputModel, outputModel
	exports.transformEnums(inputModel, outputModel)
	return outputModel