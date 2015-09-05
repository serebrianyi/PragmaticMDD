for k,v of require.cache
  delete require.cache[k]
  
fs = require("fs")
assert = require('assert')
setup = require '../../Framework/setup'
require("./setup")
child_process = require('child_process')

describe 'runner for oo', () ->

  describe 'generatedClasses', () ->
    it 'should be as expected', () ->
      res = child_process.execSync 'coffee ../Framework/PojoWithAutoupdate/runner.coffee "' + __dirname + '/setup.coffee"'      
      expectedFiles = fs.readdirSync(__dirname + '/expected/')
      for expectedFile in expectedFiles
        expectedContent = fs.readFileSync(__dirname + '/expected/' + expectedFile, {encoding: 'utf8'})
        generatedContent = fs.readFileSync(setup.outputSourceFolder() + expectedFile, {encoding: 'utf8'})
        assert.equal generatedContent, expectedContent


