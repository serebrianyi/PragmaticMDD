exports.firstUpper = (str) -> str.charAt(0).toUpperCase() + str.slice(1)

exports.firstLower = (str) -> str.charAt(0).toLowerCase() + str.slice(1)

exports.databaseNameQuoted = (str) -> "\"" + str.split(/(?=[A-Z])/).join("_").toUpperCase() + "\""

exports.databaseNameSingleQuoted = (str) -> "'" + str.split(/(?=[A-Z])/).join("_").toUpperCase() + "'"

exports.getAssociationClassName = (className1, className2) -> 
	if className1 < className2
		className1 + exports.firstUpper(className2)
	else
		className2 + exports.firstUpper(className1)