fs = require 'fs'
setup = require '../Framework/setup'

setup.modelPath = () -> __dirname + '/models/'

setup.namespace = () -> "com.test_package"

setup.modelName = () -> "library"
	
setup.outputSourceFolder = () -> __dirname + "/output/"
