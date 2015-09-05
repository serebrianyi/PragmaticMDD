for k,v of require.cache
  delete require.cache[k]
assert = (require "chai").assert

m2t = require "../../Framework/PojoWithAutoupdate/m2t"


describe 'm2t for PojoWithAutoupdate', () ->

  describe 'mappedType()', () ->
    it 'should return a mapped primitive type', () ->
      assert.equal m2t.mappedType("string"), "String"
    it 'should return an unmapped reference type', () ->
      assert.equal m2t.mappedType("Book"), "Book"

  describe 'fieldType()', () ->
    it 'should return a list for multiplicity not 1', () ->
      assert.equal m2t.fieldType({ multiplicity: ["0", "*"], type: "string"}), "java.util.List<String>"
    it 'should return a list for multiplicity bigger 1', () ->
      assert.equal m2t.fieldType({ multiplicity: ["0", "2"], type: "string"}), "java.util.List<String>"
    it 'should return an item for multiplicity 1', () ->
      assert.equal m2t.fieldType({ multiplicity: ["0", "1"], type: "string"}), "String"

  describe 'fieldInitializer()', () ->
    it 'should return a list for * multiplicity', () ->
      assert.equal m2t.fieldInitializer({ multiplicity: ["0", "*"], other : { multiplicity: ["1", "1"] }}), " = new java.util.ArrayList<>()"
    it 'should return an empty string for multiplicity 1', () ->
      assert.equal m2t.fieldInitializer({ multiplicity: ["0", "1"]}), ""

  describe 'resetSetterOtherEnd()', () ->
    it 'should remove item if multiplicity is not 1', () ->
      assert.equal m2t.resetSetterOtherEnd({ other: { multiplicity: ["0", "*"], name: "otherName"}}, "name"), "name.getOtherName().remove(this);"
    it 'should set item to null if multiplcity is 1', () ->
      assert.equal m2t.resetSetterOtherEnd({ other : { multiplicity: ["0", "1"], name: "otherName"}}, "name"), "name.setOtherNameDirect(null);"

  describe 'setSetterOtherEnd()', () ->
    it 'should add item if multiplicity is not 1', () ->
      assert.equal m2t.setSetterOtherEnd({ other : { multiplicity: ["0", "*"], name: "otherName"}}), "item.getOtherName().add(this);"
    it 'should set item to this if multiplcity is 1', () ->
      assert.equal m2t.setSetterOtherEnd({ other : { multiplicity: ["0", "1"], name: "otherName"}}), "item.setOtherNameDirect(this);"

  describe 'bidirectionalHelpers()', () ->
    it 'should add bidirectional add/remove helper methods if multiplicity is not 1', () ->
      assert.include m2t.bidirectionalHelpers({ multiplicity: ["0", "*"], name: "name", other : { multiplicity: ["0", "1"], name: "otherName" }}), "public void addNameItem"
      assert.include m2t.bidirectionalHelpers({ multiplicity: ["0", "*"], name: "name", other : { multiplicity: ["0", "1"], name: "otherName" }, type:"Class1" }), "public boolean removeNameItem"
    it 'should add bidirectional set helper methods if multiplicity is 1', () ->
      assert.include m2t.bidirectionalHelpers({ multiplicity: ["0", "1"], name: "name", other : { multiplicity: ["0", "1"], name: "otherName" }, type:"Class1" }), "public void setName"

  describe 'classText()', () ->
    it 'should not add extends superclass if superclass is not set', () ->    
      assert.notInclude m2t.classText("namespace", { attributes: [], associations: [] }), "extends"