for k,v of require.cache
  delete require.cache[k]
assert = (require "chai").assert
m2m = require "../../Framework/PojoWithAutoupdate/m2m"


describe 'm2m for PojoWithAutoupdate', () ->

  describe 'transformClasses()', () ->
    it 'should copy header information about a class', () ->
      inputModel = { classes: [ { name: "name", attributes: [], associations: []} ]}
      outputModel = {classes: []}
      m2m.transformClasses(inputModel, outputModel)
      assert.equal outputModel.classes[0].name, "name"
    it 'should copy attributes of primitive type', () ->
      inputModel = { classes: [ { attributes: [ { name: "name", type: "int" } ], associations: []} ], customTypes:[]}
      outputModel = {classes: []}
      m2m.transformClasses(inputModel, outputModel)
      assert.equal outputModel.classes[0].attributes[0].name, "name"
      assert.equal outputModel.classes[0].attributes[0].type, "int"

  describe 'transformAssociations()', () ->
    it 'should copy association ends to the classes', () ->
      inputModel = { classes: [ { name: "class1" }, { name: "class2"} ], associations: [{ 
        source: "class1", sourceMultiplicity: ["0", "12"], sourceName: "sourceName", target: "class2", targetMultiplicity: ["0", "1"], targetName: "targetName" 
          }]}
      outputModel = {classes: [{ name: "class1", associations: [] }, { name: "class2", associations: []}]}
      m2m.transformAssociations(inputModel, outputModel)
      assert.equal outputModel.classes[0].associations[0].name, "sourceName"
      assert.equal outputModel.classes[0].associations[0].type, "class2"
      assert.deepEqual outputModel.classes[0].associations[0].multiplicity, ["0", "1"]
      assert.equal outputModel.classes[0].associations[0].other.name, "targetName"
      assert.equal outputModel.classes[0].associations[0].other.type, "class1"
      assert.deepEqual outputModel.classes[0].associations[0].other.multiplicity, ["0", "12"]      
      assert.equal outputModel.classes[1].associations[0].name, "targetName"
      assert.equal outputModel.classes[1].associations[0].type, "class1"
      assert.deepEqual outputModel.classes[1].associations[0].multiplicity, ["0", "12"]
      assert.equal outputModel.classes[1].associations[0].other.name, "sourceName"
      assert.equal outputModel.classes[1].associations[0].other.type, "class2"
      assert.deepEqual outputModel.classes[1].associations[0].other.multiplicity, ["0", "1"]     