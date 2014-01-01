<cfcomponent extends="MachII.framework.Listener">

	<cffunction name="GetCleanUrl" access="public" output="false" returntype="string">
		<cfargument name="DirtyUrl" type="string" required="yes" />
		
		<cfset var loc_CleanUrl = TRIM( Arguments.DirtyUrl ) />
		
		<cfset loc_CleanUrl = REReplace( loc_CleanUrl, '[^a-zA-Z0-9_-]', '-', 'all' ) />
		<cfset loc_CleanUrl = Replace( loc_CleanUrl, '----', '-', 'all' ) />
		<cfset loc_CleanUrl = Replace( loc_CleanUrl, '---', '-', 'all' ) />
		<cfset loc_CleanUrl = Replace( loc_CleanUrl, '--', '-', 'all' ) />
		
		<cfif LEFT( loc_CleanUrl, 1 ) EQ '-'>
			<cfset loc_CleanUrl = RIGHT( loc_CleanUrl, LEN(loc_CleanUrl)-1 ) />
		</cfif>
		
		<cfif RIGHT( loc_CleanUrl, 1 ) EQ '-'>
			<cfset loc_CleanUrl = LEFT( loc_CleanUrl, LEN(loc_CleanUrl)-1 ) />
		</cfif>
		
		<cfset loc_CleanUrl = LCASE( loc_CleanUrl ) />
		
		<cfreturn loc_CleanUrl />
	</cffunction>
	
	<cffunction name="GetFriendlyUrl" access="public" output="false" returntype="string">
		<cfargument name="UrlBase" type="string" default="" />
		<cfargument name="ItemTitle" type="string" required="yes" />
		
		<cfset var loc_FriendlyUrl = GetCleanUrl( Arguments.ItemTitle ) & ".html" />
		
		<cfif LEN( Arguments.UrlBase )>
			<cfset loc_FriendlyUrl = Arguments.UrlBase & loc_FriendlyUrl />
		</cfif>
		
		<cfreturn loc_FriendlyUrl />
	</cffunction>
	
	<cffunction name="GetAbsoluteUrl" access="public" output="false" returntype="string">
		<cfargument name="RelativeUrl" type="string" default="" />
		
		<cfset var loc_RelativeUrl = TRIM( Arguments.RelativeUrl ) />
		<cfset var loc_AbsoluteUrl = "" />
		
		<!--- remove extra slash, if present in relative url --->
		<cfif LEFT( loc_RelativeUrl, 1 ) EQ "/">
			<cfset loc_RelativeUrl = RemoveChars( loc_RelativeUrl, 1, 1 ) />
		</cfif>
		
		<cfset loc_AbsoluteUrl = Request.Root.Web & loc_RelativeUrl />
		
		<cfreturn loc_AbsoluteUrl />
	</cffunction>
	
	<cffunction name="GetUrl" access="public" output="false" returntype="void">
		<cfargument name="DestinationUrl" type="string" default="" />
				
		<cfset var loc_DestinationUrl = "/" />
		
		<cfif LEN( Arguments.DestinationUrl )>
			<cfset loc_DestinationUrl = Arguments.DestinationUrl />
		</cfif>
		
		<cflocation url="#loc_DestinationUrl#" addToken="no" />
	</cffunction>
	
	<cffunction name="GetDisplayName" access="public" output="false" returntype="string">
		<cfargument name="InputString" type="string" required="yes" />
		
		<cfset var loc_DisplayName = TRIM( Arguments.InputString ) />
		
		<!--- dbl quote --->
		<cfset loc_DisplayName = ReplaceNoCase( loc_DisplayName, '^', chr(34), 'ALL' ) />
		
		<!--- pound --->
		<cfset loc_DisplayName = ReplaceNoCase( loc_DisplayName, '~', chr(35), 'ALL' ) />
		
		<!--- single quote --->
		<cfset loc_DisplayName = ReplaceNoCase( loc_DisplayName, '*', chr(39), 'ALL' ) />
		
		<cfreturn loc_DisplayName />
	</cffunction>
	
	<cffunction name="GetDisplayDescription" access="public" output="false" returntype="string">
		<cfargument name="InputString" type="string" required="yes" />
		
		<cfset var loc_DisplayDescription = TRIM( Arguments.InputString ) />
		
		<cfset loc_DisplayDescription = GetDisplayName( loc_DisplayDescription ) />
		<cfset loc_DisplayDescription = REReplaceNoCase( loc_DisplayDescription, '<[^>]+>', '', 'all' ) />
		<cfset loc_DisplayDescription = Replace( loc_DisplayDescription, chr(10), "<br />", "all" ) />		
		
		<cfreturn loc_DisplayDescription />
	</cffunction>
	
	<!-----------------------------------------------------------------------------------------------
		CATEGORIES
	------------------------------------------------------------------------------------------------>
	
	<cffunction name="GetCategoryLink" access="public" output="false" returntype="string">
		<cfargument name="CategoryID" type="numeric" required="yes" />
		<cfargument name="CategoryTitle" type="string" required="yes" />
		
		<cfreturn GetFriendlyUrl( UrlBase:"/c-#Arguments.CategoryID#/", ItemTitle:Arguments.CategoryTitle ) />
	</cffunction>
	
	<!-----------------------------------------------------------------------------------------------
		PRODUCTS
	------------------------------------------------------------------------------------------------>
	
	<cffunction name="GetProductLink" access="public" output="false" returntype="string">
		<cfargument name="ProductID" type="numeric" required="yes" />
		<cfargument name="ProductTitle" type="string" required="yes" />
		
		<cfreturn GetFriendlyUrl( UrlBase:"/p-#Arguments.ProductID#/", ItemTitle:Arguments.ProductTitle ) />
	</cffunction>
	
</cfcomponent>