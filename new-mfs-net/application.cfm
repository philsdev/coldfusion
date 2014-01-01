<cfparam name="FORM.Page" default="1" />
<cfparam name="FORM.VendorID" default="" />
<cfparam name="FORM.PriceID" default="" />
<cfparam name="FORM.SearchString" default="" />
<cfparam name="URL.Message" default="" />
<cfparam name="URL.Source" default="" />
<cfparam name="URL.Event" default="" />
<cfparam name="URL.Mobile" default="0" />

<cfinclude template="Settings.cfm" />

<cfscript>

	REQUEST.WebDisplay = "Sheehan";	
	
	REQUEST.Meta.Title = "Sheehan's of Boston, Massachusetts - Christian Books, Religious Gifts";
	REQUEST.Meta.Description = "Sheehan's is a Boston, Massachusetts-based provider of Christian books, Christian gifts and all kinds of religious gifts.";
	REQUEST.Meta.SiteName = "Sheehan's of Boston";
	REQUEST.Meta.Type = "website";
	REQUEST.Meta.Url = "";
	REQUEST.Meta.Image = "";	
	
	/* MOBILE */
	
	REQUEST.IsMobile = false;
	if (URL.Mobile) {
		REQUEST.IsMobile = true;
	}	

	switch( CGI.SERVER_NAME ) {
		
		/* LOCAL */
		case "new.matthewfsheehan.net": {
			REQUEST.Dsource = "Sheehan";
			REQUEST.SiteName = "Sheehan_Local";
			
			REQUEST.Email.Server = "localhost";
			REQUEST.Email.Sender = "test@test.com";
			REQUEST.Email.Admin = "test@test.com";
			REQUEST.Email.Error = "test@test.com";
			
			REQUEST.Root.Server.Base = "c:\inetpub\wwwroot\new-matthewfsheehan-net\";			
			
			REQUEST.Settings.RecordsPerPage = 8;
			REQUEST.Settings.ShortDescriptionLength = 50;
			REQUEST.Settings.NavigationColumnLength = 15;
			REQUEST.Settings.LoginFailureMax = 3;
			REQUEST.Settings.EncryptionKey = "MFS2011";
			
			REQUEST.PayFlowPro.HostAddress = "pilot-payflowpro.paypal.com";
			
			/* Facebook */
			Request.Meta.AppID = "164043450316905";
			Request.Meta.Admins = "546510197";			
			
			REQUEST.IsFrontEnd = true;
			REQUEST.ShowDebug = false;
			break;
		}
	
	}		
	
	REQUEST.Root.Server.Image.Product = REQUEST.Root.Server.Base & REQUEST.Root.Paths.Image.Product;
	REQUEST.Root.Server.Image.Category = REQUEST.Root.Server.Base & REQUEST.Root.Paths.Image.Category;
	REQUEST.Root.Server.Email.CSV = REQUEST.Root.Server.Base & REQUEST.Root.Paths.Email.CSV;
	
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