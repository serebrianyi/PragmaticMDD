common = require '../common'
m2t = require '../PojoWithAutoupdate/m2t'

# set inheritance type
preClassDeclaration = m2t.preClassDeclaration
m2t.preClassDeclaration = (clazz) ->
	value = ""
	if clazz.superType
		# child class
		value =  "@javax.persistence.PrimaryKeyJoinColumn(name=#{common.databaseNameQuoted('Id')})\n"
	else if clazz.isSuperType
		# parent class
		value =  "@javax.persistence.Inheritance(strategy=javax.persistence.InheritanceType.JOINED)\n"
	return preClassDeclaration(clazz) + hibernateEntity(clazz) + value

hibernateEntity = (clazz) -> return	"@javax.persistence.Entity\n" + 
									"@javax.persistence.Table(name=#{common.databaseNameQuoted(clazz.name)})\n"		

preAssociationFieldDeclaration = m2t.preAssociationFieldDeclaration
m2t.preAssociationFieldDeclaration = (association) -> 	
	preAssociationFieldDeclaration(association) + 
	if association.multiplicity[1] != "1"
				if association.other.multiplicity[1] != "1" 
					if !association.isAssociationOwner     
						"	@javax.persistence.ManyToMany(mappedBy=\"#{association.other.name}\", #{exports.cascade(association)})\n"
					else	
						"	@javax.persistence.ManyToMany(#{exports.cascade(association)})\n" +
						"	@javax.persistence.JoinTable(\n" +
						"		name=#{common.databaseNameQuoted(common.getAssociationClassName(association.type, association.other.type))},\n" +
						"		joinColumns={@javax.persistence.JoinColumn(name=#{common.databaseNameQuoted(association.other.name+'Id')})},\n" +
						"		inverseJoinColumns={@javax.persistence.JoinColumn(name=#{common.databaseNameQuoted(association.name+'Id')})})\n"
				else    
			    	"	@javax.persistence.OneToMany(mappedBy=\"#{association.other.name}\", #{exports.cascade(association)})\n"
			else
				if association.other.multiplicity[1] != "1"
		    		"	@javax.persistence.ManyToOne(#{exports.cascade(association)})\n" + 
		    		"	@javax.persistence.JoinColumn(name=#{common.databaseNameQuoted(association.name+'Id')}, nullable=#{association.multiplicity[0]=='0'} )\n"
				else
					if !association.isAssociationOwner   
						"	@javax.persistence.OneToOne(optional=#{association.multiplicity[0]=='0'}, mappedBy=\"#{association.other.name}\", #{exports.cascade(association)})\n" 
					else 						
						"	@javax.persistence.OneToOne(optional=#{association.multiplicity[0]=='0'}, #{exports.cascade(association)})\n" +
						"	@javax.persistence.JoinColumn(name=#{common.databaseNameQuoted(association.name+'Id')})\n"						

preAttributeFieldDeclaration = m2t.preAttributeFieldDeclaration	
m2t.preAttributeFieldDeclaration = (attribute) -> 	
	preAttributeFieldDeclaration(attribute) +
	["	@javax.persistence.GeneratedValue\n	@javax.persistence.Id\n" if attribute.identity] + 
	["	@javax.persistence.Enumerated(javax.persistence.EnumType.STRING)\n" if attribute.typeInformation and attribute.typeInformation.primitiveType == 'enum'] +
	"	@javax.persistence.Column(name=#{common.databaseNameQuoted(attribute.name)}" + 
	(if attribute.multiplicity[0] != "0" then ", nullable=false)\n" else ")\n") 											
											

exports.cascade = (association) ->	
	if association.isAggregation
		"cascade={javax.persistence.CascadeType.PERSIST, javax.persistence.CascadeType.REMOVE, javax.persistence.CascadeType.REFRESH}"
	else
		"cascade={javax.persistence.CascadeType.PERSIST, javax.persistence.CascadeType.REFRESH}"


