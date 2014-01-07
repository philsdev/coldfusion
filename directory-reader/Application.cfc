<cfcomponent>
	<cfscript>
		this.name = "directory-reader";
		this.clientManagement = "no";
		this.sessionManagement = "no";
		this.setClientCookies = "no";
	</cfscript>
	
	<cffunction name="onRequestStart" returnType="boolean"> 
		<cfargument name="targetPage" type="string" required="true" /> 
		
		<cfparam name="url.file" default="">
		<cfparam name="url.folder" default="">
		<cfparam name="url.sort" type="string" default="name">
		<cfparam name="url.dir" type="string" default="asc">

		<cfset request.utility = CreateObject("component", "cfc.utility") />
		
		<cfreturn true /> 
	</cffunction>
</cfcomponent>