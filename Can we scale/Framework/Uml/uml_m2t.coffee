classTemplate = (diagramModel) -> 
	(diagramModel.classes.map (clazz) -> "class #{clazz.name} { \n #{clazz.attributes.join('\n')} \n}").join("\n") + "\n"

associationsTemplate = (diagramModel) -> diagramModel.associations.join("\n") + "\n"

enumTemplate = (diagramModel) -> diagramModel.enums.map (enumItem) -> "enum #{enumItem.name} { \n #{enumItem.values.join('\n')} \n}"

diagram = (diagramModel) -> classTemplate(diagramModel)  + associationsTemplate(diagramModel) + enumTemplate(diagramModel)