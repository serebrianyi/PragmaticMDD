
transformModel = (inputModel) ->
    outputModel = { 
        classes : inputModel.classes.map (clazz) ->   
            mappedClass = { name : clazz.name }
            mappedClass.attributes = clazz.attributes.map (attribute) ->                
                return "#{attribute.name} : #{attribute.type} " + ["[0..1]" if attribute.multiplicity && attribute.multiplicity[0]=="0"]                
            return mappedClass            
    }

    outputModel.associations = inputModel.associations.map (association) ->
        label = 
            if association.targetName then " : #{association.targetName} <" else 
                (if association.sourceName then " : #{association.sourceName} >" else "")
        association.source + ' "' + association.sourceMultiplicity + '" -- "' + association.targetMultiplicity + '" '  + association.target + label

    # handle inheritance
    inputModel.classes
        .filter (clazz) -> clazz.superType
        .forEach (clazz) -> outputModel.associations.push clazz.superType + " <|-- " + clazz.name

    #handle enums
    outputModel.enums = inputModel.customTypes.filter (type) -> type.primitiveType == "enum"
    return outputModel


