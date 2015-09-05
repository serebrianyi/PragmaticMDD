setup = require '../../Framework/setup'
util = require '../../Framework/util'

setup.modelPath = () -> __dirname + '/../models/'

setup.namespace = () -> "com.test_package"

setup.modelName = () -> "library"

setup.outputSourceFolder = () -> 		
	__dirname + "/../output/src" + util.namespaceToPath(setup.namespace())

setup.outputResourceFolder = () -> 
	__dirname + "/../output/resources/"	

setup.ensureFolderStructure = () ->	
	util.ensureFolder(__dirname + "/../output/src/")
	util.ensureNamespaceToPath(__dirname + "/../output/src/", setup.namespace())	
	util.ensureFolder(__dirname + "/../output/resources/")