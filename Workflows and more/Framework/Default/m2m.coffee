common = require '../common'

# transform model
exports.transformClasses = (model) ->
	model.classes.forEach (clazz) -> 	
		if not clazz.superType
			# add id to all super classes
			clazz.attributes.push {name: "id", type: "int", identity: true}
		# add default multiplicity to all attributes
		clazz.attributes.forEach (attribute) -> 
			attribute.multiplicity = attribute.multiplicity || ["1", "1"]

exports.transformAssociations = (model) ->
	model.associations.forEach (association) -> 
		# add default multiplicity to all associations
		association.sourceMultiplicity = association.sourceMultiplicity || ["0", "1"]
		association.targetMultiplicity = association.targetMultiplicity || ["0", "1"]
		# add default aggregation
		association.sourceIsAggregation = association.sourceIsAggregation || false
		association.targetIsAggregation = association.targetIsAggregation || false
		# add default names to all associations
		association.sourceName = association.sourceName || 
			(if association.targetMultiplicity[1] == "*" then common.firstLower(association.target) + "s" else common.firstLower(association.target))
		association.targetName = association.targetName || 
			(if association.sourceMultiplicity[1] == "*" then common.firstLower(association.source) + "s" else common.firstLower(association.source))
		
exports.transformModel = (model) ->
	exports.transformClasses(model)
	exports.transformAssociations(model)
	return model


