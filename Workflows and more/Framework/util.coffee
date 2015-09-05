fs = require 'fs'

exports.deleteFolderRecursive = (path) ->
  if  fs.existsSync(path)
    fs.readdirSync(path).forEach (file,index) ->
      curPath = path + "\\" + file;
      if fs.statSync(curPath).isDirectory() 
        exports.deleteFolderRecursive(curPath);
      else
        console.log("Removed " + curPath)
        fs.unlinkSync(curPath);          
    fs.rmdirSync(path);

exports.namespaceToPath = (namespace) ->  
  currentFolder = ""
  namespace.split('.').forEach (folder) ->    
    currentFolder += "/" + folder   
  return currentFolder + "/"

exports.ensureNamespaceToPath = (currentFolder, namespace) ->  
  exports.ensureFolder(currentFolder)
  namespace.split('.').forEach (folder) ->    
    currentFolder += "/" + folder   
    exports.ensureFolder(currentFolder)
  exports.ensureFolder(currentFolder)  

exports.ensureFolder = (path) -> 
  try
    fs.mkdirSync(path);
  catch e
      if e.code isnt 'EEXIST' then throw e
