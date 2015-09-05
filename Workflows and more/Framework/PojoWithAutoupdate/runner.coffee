fs = require 'fs'
m2t = require './m2t'
m2m = require './m2m'
setup = require '../setup'
process.argv.slice(2).forEach (item) -> require item

# load model
inputModel = require setup.modelPath() + setup.modelName() + ".json"

# transform model
outputModel = m2m.transformModel(inputModel)

# save all classes into separate files
outputModel.classes.forEach (clazz) ->
	filename = setup.outputSourceFolder() + clazz.name + ".java"	
	fs.writeFileSync filename, m2t.classText(setup.namespace(), clazz)
	console.log "Generated " + filename

# save all enums into separate files
outputModel.enums.forEach (enumItem) ->
	filename = setup.outputSourceFolder() + enumItem.name + ".java"
	fs.writeFileSync filename, m2t.enumText(setup.namespace(), enumItem)
	console.log "Generated " + filename