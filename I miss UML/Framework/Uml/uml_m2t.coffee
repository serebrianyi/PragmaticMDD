classTemplate = (diagramModel) -> 
	(diagramModel.classes.map (clazz) -> "class #{clazz.name} { \n #{clazz.attributes.join('\n')} \n}").join("\n") + "\n"

associationsTemplate = (diagramModel) -> diagramModel.associations.join("\n") + "\n"

diagram = (diagramModel) -> classTemplate(diagramModel)  + associationsTemplate(diagramModel)