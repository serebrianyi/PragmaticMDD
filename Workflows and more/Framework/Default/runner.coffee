# this module just adds default values not set in the model by user
# it is used to prevent null checking everywhere else

# include dependencies
fs = require 'fs'
setup = require '../setup'
m2m = require './m2m'
process.argv.slice(2).forEach (item) -> require item

# load model
model = require setup.modelPath() + setup.modelName() + ".json";

# transform model
model = m2m.transformModel model
	
# store model
filename = setup.outputResourceFolder() + setup.outputModelName() + ".json"
fs.writeFileSync filename, JSON.stringify(model, null, "\t")
console.log "Generated model with defaults " + filename


