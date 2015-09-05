for k,v of require.cache
	delete require.cache[k]

assert = (require "chai").assert
fs = require("fs")
setup = require '../../Framework/setup'
require("./setup")
child_process = require('child_process')

describe 'runner for hibernate', () ->

  describe 'generatedClasses', () ->
    it 'should be as expected', () ->      
      child_process.execSync 'coffee ../Framework/PojoWithAutoupdate/runner.coffee "' + __dirname + '"/setup.coffee ../hibernate/hibernateInjector.coffee'      
      expectedFiles = fs.readdirSync(__dirname + '/expected/')
      for expectedFile in expectedFiles
        expectedContent = fs.readFileSync(__dirname + '/expected/' + expectedFile, {encoding: 'utf8'})
        generatedContent = fs.readFileSync(setup.outputSourceFolder() + expectedFile, {encoding: 'utf8'})
        assert.equal generatedContent, expectedContent


