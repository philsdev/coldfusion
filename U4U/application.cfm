<cfparam name="Form.Page" default="1" />
<cfparam name="URL.Message" default="" />
<cfparam name="URL.Source" default="" />
<cfparam name="URL.Event" default="" />

<cfscript>
	
	if ( FindNoCase( "amp.com", CGI.SERVER_NAME ) ) {
		REQUEST.Environment = "local";
	} else if ( FindNoCase( "advanced-media-productions.com", CGI.SERVER_NAME ) ) {
		REQUEST.Environment = "beta";
	} else {
		REQUEST.Environment = "live";
	}

	switch( REQUEST.Environment ) {
		
		/* LOCAL */
		case "local": {
			REQUEST.Dsource = "U4U";
			REQUEST.SiteName = "U4U";
			
			REQUEST.Sender_Email = "facebook@advmediaproductions.com";
			REQUEST.Admin_Email = "info@advmediaproductions.com";
			REQUEST.Error_Email = "info@advmediaproductions.com";
			
			REQUEST.Root.Server = "d:\inetpub\wwwroot\U4U\";			
			
			REQUEST.RecordsPerPage = 5;
			REQUEST.ShortDescriptionLength = 50;
			
			/* Facebook */
			Request.Meta.AppID = "164043450316905";
			Request.Meta.Admins = "546510197";
			
			/* Number of hours that must elapse before another impression is tracked for the current user */
			REQUEST.UniqueUserHourThrottle = (1/60); /* 1 minute for local */
			
			REQUEST.LoginFailureMax = 3;
			
			REQUEST.EncryptionKey = "U4U2010";
			
			REQUEST.IsFrontEnd = true;
			REQUEST.ShowDebug = false;
			break;
		}
		
		/* BETA */
		case "beta": {
			REQUEST.Dsource = "beta_U4U";
			REQUEST.SiteName = "U4U";
			
			REQUEST.Sender_Email = "facebook@advmediaproductions.com";
			REQUEST.Admin_Email = "info@advmediaproductions.com";
			REQUEST.Error_Email = "info@advmediaproductions.com";
			
			REQUEST.Root.Server = "c:\inetpub\wwwroot\U4U\";			
			
			REQUEST.RecordsPerPage = 5;
			REQUEST.ShortDescriptionLength = 50;
			
			/* Facebook */
			Request.Meta.AppID = "164043450316905";
			Request.Meta.Admins = "546510197";
			
			/* Number of hours that must elapse before another impression is tracked for the current user */
			REQUEST.UniqueUserHourThrottle = 1; /* 1 hour for beta */
			
			REQUEST.LoginFailureMax = 5;
			
			REQUEST.EncryptionKey = "U4U2010";
			
			REQUEST.IsFrontEnd = true;
			REQUEST.ShowDebug = false;
			break;
		}
		
		/* LIVE */
		default: {
			
			REQUEST.Dsource = "live_U4U";
			REQUEST.SiteName = "U4U";
			
			REQUEST.Sender_Email = "info@u4uboston.com";
			REQUEST.Admin_Email = "info@u4uboston.com";
			REQUEST.Error_Email = "info@advmediaproductions.com";
			
			REQUEST.Root.Server = "d:\inetpub\wwwroot\U4U\";			
			
			REQUEST.RecordsPerPage = 5;
			REQUEST.ShortDescriptionLength = 50;
			
			/* Facebook */
			Request.Meta.AppID = "164043450316905";
			Request.Meta.Admins = "546510197";
			
			/* Number of hours that must elapse before another impression is tracked for the current user */
			REQUEST.UniqueUserHourThrottle = 1; /* 1 hour for live */
			
			REQUEST.LoginFailureMax = 5;
			
			REQUEST.EncryptionKey = "U4U2010";
			
			REQUEST.IsFrontEnd = true;
			REQUEST.ShowDebug = false;
			break;
			
		}
	
	}
	
</cfscript>

<cfapplication name="#REQUEST.SiteName#" sessionmanagement="yes" sessiontimeout="#CreateTimeSpan(0,2,0,0)#" />
<cfsetting showdebugoutput="#REQUEST.ShowDebug#" />
<cfscript>
	
	REQUEST.WebDisplay = "U4U";	
	
	REQUEST.Meta.Title = "Welcome to U4U, an interactive online social community for Boston area college students.";
	REQUEST.Meta.Description = "Welcome to U4U, an interactive online social community for Boston area college students. U4U will keep you up to date on all the latest local happenings, events and campus news. You can even discuss coursework in one of our study groups. Join today and get in the loop!";
	REQUEST.Meta.SiteName = "U4UBoston.com";
	REQUEST.Meta.Type = "website";
	REQUEST.Meta.Url = "";
	REQUEST.Meta.Image = "";
	
	/* Facebook */
	REQUEST.Facebook.SiteName = "U4U.com";
	REQUEST.Facebook.Title = "";
	REQUEST.Facebook.Description = "";
	REQUEST.Facebook.Type = "website";
	REQUEST.Facebook.Url = "";
	REQUEST.Facebook.Image = "";
		
	
</cfscript>

<!--- settings common to front end and admin --->
<cfinclude template="Settings.cfm" />

<!--- cause session vars to expire after the browser closes --->               
<cfif StructKeyExists(COOKIE, "CFID") AND StructKeyExists(COOKIE, "CFTOKEN")>
    <cfset variables.CFID_LOCAL = COOKIE.CFID>
    <cfset variables.CFTOKEN_LOCAL = COOKIE.CFTOKEN>
    <cfcookie name="CFID" value="#variables.CFID_LOCAL#">
    <cfcookie name="CFTOKEN" value="#variables.CFTOKEN_LOCAL#">
</cfif>

<cflock type="readonly" scope="session" timeout="10">
	<cfif StructkeyExists( SESSION, "UserID" ) AND SESSION.UserID GT 0>
		<cfset REQUEST.UserID = SESSION.UserID />
		<cfset REQUEST.FirstName = SESSION.FirstName />
		<cfset REQUEST.LastName = SESSION.LastName />
		<cfset REQUEST.Username = SESSION.Username />
		<cfset REQUEST.UserIsAdvertiser = SESSION.UserIsAdvertiser />
		<cfset REQUEST.UserIsDealer = SESSION.UserIsDealer />
		<cfset REQUEST.SchoolID = SESSION.SchoolID />
		<cfif LEN( SESSION.SchoolName )>
			<cfset REQUEST.SchoolName = SESSION.SchoolName />
		<cfelse>
			<cfset REQUEST.SchoolName = "N/A" />
		</cfif>
		<cfset REQUEST.UserIsLoggedIn = true />
	<cfelse>
		<cfset REQUEST.UserID = 0 />
		<cfset REQUEST.UserFirstName = "" />
		<cfset REQUEST.UserLastName = "" />
		<cfset REQUEST.Username = "" />
		<cfset REQUEST.UserIsAdvertiser = false />
		<cfset REQUEST.UserIsDealer = false />
		<cfset REQUEST.SchoolID = 0 />
		<cfset REQUEST.SchoolName = "" />
		<cfset REQUEST.UserIsLoggedIn = false />
	</cfif>
	
	<cfif StructkeyExists( SESSION, "LocationID" )>
		<cfset REQUEST.LocationID = Session.LocationID />
		<cfset REQUEST.LocationLabel = Session.LocationLabel />
	<cfelse>
		<cfset REQUEST.LocationID = 1 />
		<cfset REQUEST.LocationLabel = "Boston" />
	</cfif>	
	
	<cfif StructKeyExists( SESSION, "SuccessDestination" )>
		<cfset REQUEST.SuccessDestination = Session.SuccessDestination />
	<cfelse>
		<cfset REQUEST.SuccessDestination = "" />
	</cfif>
</cflock>

<!--- Used to identify the site, in places like mailings (eg: 'U4U Boston') --->
<cfset REQUEST.SiteLabel = REQUEST.SiteName & " " & REQUEST.LocationLabel />

<cfset REQUEST.SearchFieldList = "Page,Sort,SearchTerm,Category,Type,User,Section,School,Course" />
<cfset REQUEST.SearchParams = StructNew() />
	
<cfloop list="#REQUEST.SearchFieldList#" index="variables.ThisSearchField">
	<cfif StructKeyExists( FORM, variables.ThisSearchField )>
		<cfset REQUEST.SearchParams[variables.ThisSearchField] = FORM[variables.ThisSearchField] />
	<cfelseif StructKeyExists( URL, variables.ThisSearchField )>
		<cfset REQUEST.SearchParams[variables.ThisSearchField] = URL[variables.ThisSearchField] />
	<cfelse>
		<cfset REQUEST.SearchParams[variables.ThisSearchField] = "" />
	</cfif>
</cfloop>

<!--- HACK: make user's school selected on study group list page --->
<cfif NOT IsNumeric(REQUEST.SearchParams.School) AND REQUEST.SchoolID GT 0 AND ListFirst( URL.Event ) EQ "StudyGroups">
	<cfset REQUEST.SearchParams.School = REQUEST.SchoolID />
</cfif>
