// Generated by CoffeeScript 1.9.2
var associationsTemplate, classTemplate, diagram, enumTemplate;

classTemplate = function(diagramModel) {
  return (diagramModel.classes.map(function(clazz) {
    return "class " + clazz.name + " { \n " + (clazz.attributes.join('\n')) + " \n}";
  })).join("\n") + "\n";
};

associationsTemplate = function(diagramModel) {
  return diagramModel.associations.join("\n") + "\n";
};

enumTemplate = function(diagramModel) {
  return diagramModel.enums.map(function(enumItem) {
    return "enum " + enumItem.name + " { \n " + (enumItem.values.join('\n')) + " \n}";
  });
};

diagram = function(diagramModel) {
  return classTemplate(diagramModel) + associationsTemplate(diagramModel) + enumTemplate(diagramModel);
};