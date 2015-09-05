fs = require 'fs'
setup = require '../../Framework/setup'
util = require '../../Framework/util'

setup.modelPath = () -> __dirname + '/../output/resources/'

setup.namespace = () -> "com.test_package"

setup.modelName = () -> "library_default"
	
setup.outputSourceFolder = () -> __dirname + "/../output/src" + util.namespaceToPath(setup.namespace())
