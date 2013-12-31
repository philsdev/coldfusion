<cfcomponent name="utility">

	<cfscript>
		this.basePath = ExpandPath("..\");
		
		this.brushStruct = StructNew();
		
		this.brushStruct['css'] = StructNew();
		this.brushStruct['css'].extensionList = "css";
		this.brushStruct['css'].brushScript = "shBrushCss.js";
		
		this.brushStruct['coldfusion'] = StructNew();
		this.brushStruct['coldfusion'].extensionList = "cfc,cfm,cfml";
		this.brushStruct['coldfusion'].brushScript = "shBrushColdFusion.js";
		
		this.brushStruct['javascript'] = StructNew();
		this.brushStruct['javascript'].extensionList = "js,json";
		this.brushStruct['javascript'].brushScript = "shBrushJScript.js";
		
		this.brushStruct['php'] = StructNew();
		this.brushStruct['php'].extensionList = "info,module,php";
		this.brushStruct['php'].brushScript = "shBrushPhp.js";
		
		this.brushStruct['plain'] = StructNew();
		this.brushStruct['plain'].extensionList = "readme,txt";
		this.brushStruct['plain'].brushScript = "shBrushPlain.js";
		
		this.brushStruct['sql'] = StructNew();
		this.brushStruct['sql'].extensionList = "sql";
		this.brushStruct['sql'].brushScript = "shBrushSql.js";
		
		this.brushStruct['xml'] = StructNew();
		this.brushStruct['xml'].extensionList = "xml,xhtml,xslt,html,htm,xhtml";
		this.brushStruct['xml'].brushScript = "shBrushXml.js";
	</cfscript>
	
	<cffunction name="getBrushName" output="no" access="public" returntype="string">
		<cfargument name="relativePath" type="string" required="yes" />
		
		<cfset var loc_brushName = "" />
		<cfset var loc_brushIndex = "" />
		<cfset var loc_pathExtension = getFileExtension(arguments.relativePath) />
		
		<cfloop collection="#this.brushStruct#" item="loc_brushIndex">
			<cfif ListFindNoCase(this.brushStruct[loc_brushIndex].extensionList, loc_pathExtension)>
				<cfset loc_brushName = loc_brushIndex />
			</cfif>
		</cfloop>
		
		<cfreturn loc_brushName />
	</cffunction>
	
	<cffunction name="getDirectoryContents" output="no" access="public" returntype="any">
		<cfargument name="relativePath" type="string" required="yes" />
		<cfargument name="sort" type="string" required="yes" />
		<cfargument name="dir" type="string" required="yes" />
	
		<cfset var loc_directoryContents = "" />
		<cfset var loc_fullPath = getFullPath(arguments.relativePath) />
		
		<cftry>
			<cfdirectory action="list" directory="#loc_fullPath#" name="loc_directoryContents" sort="#arguments.sort# #arguments.dir#" >
		<cfcatch type="any">
			<cfset loc_directoryContents = QueryNew("Name,Size,Type") />
		</cfcatch>
		</cftry>
		
		<cfreturn loc_directoryContents />
	</cffunction>
	
	<cffunction name="getDirectoryMarkup" output="no" access="public" returntype="string">
		<cfargument name="relativePath" type="string" required="yes" />
		<cfargument name="directoryQuery" type="query" required="yes" />
		
		<cfset var loc_directoryMarkup = "Directory is empty!" />
		
		<cfif arguments.directoryQuery.recordCount GT 0>
			<cfsavecontent variable="loc_directoryMarkup">			
				<table class="lister" folder="<cfoutput>#arguments.relativePath#</cfoutput>">
					<tr>
						<th>Name</th>
						<th>Size</th>
						<th>Date</th>
					</tr>
				<cfoutput query="arguments.directoryQuery">
					<tr class="#lcase(type)#">
						<td class="name">#name#</td>
						<td class="size">#getFileSize(fileSize:size, type:type)#</td>
						<td class="size">#dateFormat(datelastmodified, "short")#</td>
					</tr>
				</cfoutput>
				</table>
			</cfsavecontent>
		</cfif>
		
		<cfreturn loc_directoryMarkup />
	</cffunction>

	<cffunction name="getFileContents" output="no" access="public" returntype="string">
		<cfargument name="relativePath" type="string" required="yes" />
	
		<cfset var loc_fileContents = "" />
		<cfset var loc_fullPath = getFullPath(arguments.relativePath) />
		
		<cftry>
			<cffile action="read" file="#loc_fullPath#" variable="loc_fileContents"> 
		<cfcatch type="any">
			<cfset loc_fileContents = "ERROR: contents not available" />
		</cfcatch>
		</cftry>
		
		<cfreturn loc_fileContents />
	</cffunction>
	
	<cffunction name="getFileExtension" output="no" access="public" returntype="string">
		<cfargument name="relativePath" type="string" required="yes" />
		
		<cfset var loc_fileExtension = "" />
		
		<cfif ListLen(arguments.relativePath, ".") GTE 2>
			<cfset loc_fileExtension = ListLast(arguments.relativePath, ".") />
		</cfif>
		
		<cfreturn loc_fileExtension />
	</cffunction>
	
	<cffunction name="getFileMarkup" output="no" access="public" returntype="string">
		<cfargument name="fileContents" type="string" required="yes" />
		<cfargument name="relativePath" type="string" required="yes" />
		
		<cfset var loc_fileMarkup = "" />
		<cfset var loc_brushName = getBrushName(arguments.relativePath) />
		
		<cfsavecontent variable="loc_fileMarkup">
			<cfif LEN(loc_brushName)>
				<cfoutput>
					<script type="text/javascript" src="scripts/#this.brushStruct[loc_brushName].brushScript#"></script>
					<pre class="brush: #loc_brushName#">#HtmlEditFormat(arguments.fileContents)#</pre>
				</cfoutput>
			<cfelse>
				<pre><cfoutput>#HtmlEditFormat(arguments.fileContents)#</cfoutput></pre>
			</cfif>
		</cfsavecontent>
		
		<cfreturn loc_fileMarkup />
	</cffunction>
	
	<cffunction name="getFileSize" output="no" access="public" returntype="string">
		<cfargument name="fileSize" type="string" required="yes" />
		<cfargument name="type" type="string" required="yes" />
				
		<cfset var loc_fileSize = "" />
		
		<cfif arguments.fileSize GT 0 and arguments.type EQ "file">
			<cfif arguments.fileSize LT 1000>
				<cfset loc_fileSize = arguments.fileSize & " b" />
			<cfelseif arguments.fileSize LT 1000000>
				<cfset loc_fileSize = INT(arguments.fileSize/1000) & " Kb" />
			<cfelseif arguments.fileSize LT 1000000000>
				<cfset loc_fileSize = INT(arguments.fileSize/1000000) & " Mb" />
			<cfelseif arguments.fileSize LT 1000000000000>
				<cfset loc_fileSize = INT(arguments.fileSize/1000000000) & " Gb" />
			</cfif>
		</cfif>
		
		<cfreturn loc_fileSize />
	</cffunction>
	
	<cffunction name="getFullPath" output="no" access="public" returntype="string">
		<cfargument name="relativePath" type="string" required="yes" />
	
		<cfset var loc_filePath = trim(arguments.relativePath) />
		<cfset var loc_fullPath = this.basePath & loc_filePath />
	
		<cfset loc_fullPath = replaceNoCase(loc_fullPath, "/", "\", "all") />
		<cfset loc_fullPath = replaceNoCase(loc_fullPath, "\\", "\", "all") />
	
		<cfreturn loc_fullPath />		
	</cffunction>
	
</cfcomponent>