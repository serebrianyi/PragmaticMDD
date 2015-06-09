
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

exports.transformClasses = (inputModel, outputModel) ->
	# copy everything except of the assocations
	outputModel.classes = inputModel.classes.map (clazz) -> 
		{ name: clazz.name, attributes: clazz.attributes, associations: [] }

exports.transformModel = (inputModel) ->
	outputModel = {}
	exports.transformClasses inputModel, outputModel
	exports.transformAssociations inputModel, outputModel
	return outputModel