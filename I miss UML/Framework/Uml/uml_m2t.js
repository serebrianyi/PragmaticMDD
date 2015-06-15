// Generated by CoffeeScript 1.7.1
var associationsTemplate, classTemplate, diagram;

classTemplate = function(diagramModel) {
  return (diagramModel.classes.map(function(clazz) {
    return "class " + clazz.name + " { \n " + (clazz.attributes.join('\n')) + " \n}";
  })).join("\n") + "\n";
};

associationsTemplate = function(diagramModel) {
  return diagramModel.associations.join("\n") + "\n";
};

diagram = function(diagramModel) {
  return classTemplate(diagramModel) + associationsTemplate(diagramModel);
};