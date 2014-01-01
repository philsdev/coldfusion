<cfinclude template="../Settings.cfm" />

<cfscript>	

	switch( CGI.SERVER_NAME ) {
		
		/* LOCAL */
		case "new.matthewfsheehan.net": {
			REQUEST.Dsource = "Sheehan";
			REQUEST.SiteName = "Sheehan_Local_Administration";
			
			REQUEST.Email.Server = "localhost";
			REQUEST.Email.Sender = "pdsbmx@yahoo.com";
			REQUEST.Email.Admin = "pdsbmx@yahoo.com";
			REQUEST.Email.Error = "pdsbmx@yahoo.com";
			
			REQUEST.Root.Server.Base = "c:\inetpub\wwwroot\new-matthewfsheehan-net\";
			
			REQUEST.Settings.RecordsPerPage = 10;
			REQUEST.Settings.ShortDescriptionLength = 50;			
			REQUEST.Settings.LoginFailureMax = 3;			
			REQUEST.Settings.EncryptionKey = "MFS2011";
			
			REQUEST.PayFlowPro.HostAddress = "pilot-payflowpro.paypal.com";
			
			REQUEST.IsFrontEnd = false;
			REQUEST.ShowDebug = false;
			break;
		}
	
	}
	
	REQUEST.Root.Server.Image.Product = REQUEST.Root.Server.Base & REQUEST.Root.Paths.Image.Product;
	REQUEST.Root.Server.Image.Category = REQUEST.Root.Server.Base & REQUEST.Root.Paths.Image.Category;
		
</cfscript>

<cfapplication		name="#REQUEST.SiteName#" 
					sessionmanagement="yes" 
					sessiontimeout="#CreateTimeSpan(0,2,0,0)#" />

<cfsetting showdebugoutput="#REQUEST.ShowDebug#" />

<!--- cause session vars to expire after the browser closes --->               
<cfif StructKeyExists(COOKIE, "CFID") AND StructKeyExists(COOKIE, "CFTOKEN")>
    <cfset variables.CFID_LOCAL = COOKIE.CFID>
    <cfset variables.CFTOKEN_LOCAL = COOKIE.CFTOKEN>
    <cfcookie name="CFID" value="#variables.CFID_LOCAL#">
    <cfcookie name="CFTOKEN" value="#variables.CFTOKEN_LOCAL#">
</cfif>

<!--- create read-only copy of session for use throughout site --->
<cflock scope="session" type="readonly" timeout="10">
	<cfset REQUEST.SessionStruct = StructCopy( SESSION ) />
</cflock>

<cfif not StructKeyExists(REQUEST.SessionStruct, "Admin")>
	<cfif Not StructKeyExists(Form, "Username") AND CGI.QUERY_STRING DOES NOT CONTAIN "Login">
		<cflocation url="index.cfm?event=Admin.Login" addtoken="no" />	
	</cfif>	
</cfif>