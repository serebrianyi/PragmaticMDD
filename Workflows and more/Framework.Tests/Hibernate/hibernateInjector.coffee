for k,v of require.cache
  delete require.cache[k]
assert = (require "chai").assert

m2t = require "../../Framework/PojoWithAutoupdate/m2t"
hibernate = require "../../Framework/Hibernate/hibernateInjector"

describe 'hibernateInjector', () ->

  describe 'preClassDeclaration()', () ->
    it 'should add PrimaryKeyJoinColumn annotation for subclass for default inheritance', () ->
      assert.include m2t.preClassDeclaration({superType: "superType", name: "name"}), "@javax.persistence.PrimaryKeyJoinColumn"
    it 'should add JOINED annotation for superclass for default inheritance', () ->
      assert.equal m2t.preClassDeclaration({isSuperType: true, name: "name"}), "@javax.persistence.Entity\n@javax.persistence.Table(name=\"NAME\")\n@javax.persistence.Inheritance(strategy=javax.persistence.InheritanceType.JOINED)\n"
    it 'should not add any inheritance annotation by default', () ->
      assert.equal m2t.preClassDeclaration({name: "name"}), "@javax.persistence.Entity\n@javax.persistence.Table(name=\"NAME\")\n"

  describe 'preAttributeFieldDeclaration()', () ->
    it 'should add generated id annotation to identity', () ->
      assert.include m2t.preAttributeFieldDeclaration({multiplicity: ["1", "1"], identity: true, name: "name"}), "@javax.persistence.Id"
      assert.include m2t.preAttributeFieldDeclaration({multiplicity: ["1", "1"], identity: true, name: "name"}), "@javax.persistence.GeneratedValue"
    it 'should add enum string annotation for enums', () ->
      assert.include m2t.preAttributeFieldDeclaration({multiplicity: ["1", "1"], typeInformation: { primitiveType: "enum"}, name: "name"}), "@javax.persistence.Enumerated(javax.persistence.EnumType.STRING)"
    it 'should not add nullable=false annotation to non-nullables', () ->
      assert.include m2t.preAttributeFieldDeclaration({multiplicity: ["1", "1"], name: "name"}), "nullable=false"

  describe 'cascade()', () ->
    it 'should add cascade for association', () ->
      assert.include hibernate.cascade({multiplicity: ["1", "1"], other: { multiplicity: ["1", "1"]}}), "cascade={javax.persistence.CascadeType.PERSIST, javax.persistence.CascadeType.REFRESH}"
    it 'should add cascade for aggregate association', () ->
      assert.include hibernate.cascade({multiplicity: ["1", "1"], other: {multiplicity: ["1", "1"]}, isAggregation: true}), "cascade={javax.persistence.CascadeType.PERSIST, javax.persistence.CascadeType.REMOVE, javax.persistence.CascadeType.REFRESH}"      

  describe 'preAssociationFieldDeclaration()', () ->
    it 'should generate many to many annotation for inverse end', () ->
      assert.include m2t.preAssociationFieldDeclaration({multiplicity: ["1", "*"], other: {multiplicity: ["1", "*"]}, isAssociationOwner: false}), "@javax.persistence.ManyToMany(mappedBy="
    it 'should generate many to many annotation for non inverse end', () ->
      assert.include m2t.preAssociationFieldDeclaration({multiplicity: ["1", "*"], other: { multiplicity: ["1", "*"] , type: "otherType", name: "otherName"}, isAssociationOwner: true, type: "type", name: "name"}), "@javax.persistence.ManyToMany"
      assert.include m2t.preAssociationFieldDeclaration({multiplicity: ["1", "*"], other :  { multiplicity: ["1", "*"] , type: "otherType", name: "otherName"}, isAssociationOwner: true, type: "type", name: "name"}), "@javax.persistence.JoinTable"
    it 'should generate one to many annotation', () ->
      assert.include m2t.preAssociationFieldDeclaration({multiplicity: ["1", "*"], other :  { multiplicity: ["1", "1"]}}), "@javax.persistence.OneToMany(mappedBy="  
    it 'should generate many to one annotation', () ->
      assert.include m2t.preAssociationFieldDeclaration({multiplicity: ["1", "1"], other :  { multiplicity: ["1", "*"]}}), "@javax.persistence.ManyToOne"
      assert.include m2t.preAssociationFieldDeclaration({multiplicity: ["1", "1"], other :  { multiplicity: ["1", "*"]}}), "@javax.persistence.JoinColumn("
    it 'should generate one to one annotation for inverse end', () ->
      assert.include m2t.preAssociationFieldDeclaration({multiplicity: ["1", "1"], other :  { multiplicity: ["1", "1"]}, isAssociationOwner: false}), "@javax.persistence.OneToOne("
    it 'should generate one to one annotation for non inverse end', () ->
      assert.include m2t.preAssociationFieldDeclaration({multiplicity: ["1", "1"], other :  { multiplicity: ["1", "1"]}, isAssociationOwner: true, name: "name"}), "@javax.persistence.OneToOne"
      assert.include m2t.preAssociationFieldDeclaration({multiplicity: ["1", "1"], other :  { multiplicity: ["1", "1"] }, isAssociationOwner: true, name: "name"}), "@javax.persistence.JoinColumn"