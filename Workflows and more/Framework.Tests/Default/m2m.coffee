assert = (require "chai").assert
m2m = require "../../Framework/default/m2m"

describe 'default', () ->
  describe 'transformClasses()', () ->
    it 'should add id and concurrency for all superclasses', () ->
      model = { classes: [ { attributes: [] }, { superType:"superType", attributes: [] },  { name:"superType", attributes: [] } ] }
      m2m.transformClasses(model, context)
      assert.equal model.classes[1].attributes.length, 0
      assert.equal model.classes[0].attributes.length, 1
      assert.equal model.classes[0].attributes[0].name, "id"
      assert.equal model.classes[0].attributes[0].type, "int"
      assert.equal model.classes[0].attributes[0].identity, true
    it 'should add default multiplicity to attributes if no provided', () ->
      model = { classes: [ { attributes: [ { multiplicity: ["0", "1"]  }, { multiplicity: ["1", "1"]  }]  } ] }
      m2m.transformClasses(model, {})
      assert.deepEqual model.classes[0].attributes[0].multiplicity, ["0", "1"]
      assert.deepEqual model.classes[0].attributes[1].multiplicity, ["1", "1"]

  describe 'transformAssociations()', () -> 
    it 'should add default multiplicity to associations if no provided', () ->
      model = { associations: [ {  sourceMultiplicity: ["1", "1"]  , targetMultiplicity: ["1", "*"], sourceName: "sourceName", targetName: "targetName"  }, {sourceName: "sourceName", targetName: "targetName"} ] }
      m2m.transformAssociations(model)
      assert.deepEqual model.associations[0].sourceMultiplicity, ["1", "1"]
      assert.deepEqual model.associations[0].targetMultiplicity, ["1", "*"]
      assert.deepEqual model.associations[1].sourceMultiplicity, ["0", "1"]
      assert.deepEqual model.associations[1].targetMultiplicity, ["0", "1"]
    it 'should add default names to associations if no provided', () ->
      model = { associations: [  
        { sourceMultiplicity: ["1", "1"]  , targetMultiplicity: ["1", "*"], sourceName: "sourceName", targetName: "targetName"  }, 
        { sourceMultiplicity: ["1", "1"]  , targetMultiplicity: ["1", "*"], source: "source", target: "target" } 
        ]}
      m2m.transformAssociations(model)
      assert.equal model.associations[0].sourceName, "sourceName"
      assert.equal model.associations[0].targetName, "targetName"
      assert.deepEqual model.associations[1].sourceName, "targets"
      assert.equal model.associations[1].targetName, "source"
      