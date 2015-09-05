fs = require 'fs'
setup = require '../../Framework/setup'

setup.modelPath = () -> __dirname + '/../models/'

setup.modelName = () -> "library"

setup.outputModelName = () -> "library_default"

setup.outputResourceFolder = () -> __dirname + "/../output/resources/"
