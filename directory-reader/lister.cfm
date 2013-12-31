<cfset variables.directoryContents = request.utility.getDirectoryContents(
	relativePath:url.folder,
	sort:url.sort,
	dir:url.dir
) />

<cfset variables.directoryMarkup = request.utility.getDirectoryMarkup(
	relativePath:url.folder,
	directoryQuery:variables.directoryContents	
) />

<cfoutput>#variables.directoryMarkup#</cfoutput>