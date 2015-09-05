fs = require 'fs'
setup = require './setup'
util = require './util'
process.argv.slice(2).forEach (item) -> require item

util.deleteFolderRecursive(setup.outputSourceFolder())
util.deleteFolderRecursive(setup.outputResourceFolder())
setup.ensureFolderStructure()
