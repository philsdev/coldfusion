

<cfscript>

	Request.WebDisplay = "U4U";
	
	Request.Root = StructNew();	
	Request.Root.Web = "http://#CGI.SERVER_NAME#/";		
	Request.Images = StructNew();

	switch( CGI.SERVER_NAME ) {
	
		/* LOCAL */
		case "U4U": 
		case "U4U.amp.com": {
			Request.Dsource = "U4U";
			Request.SiteName = "U4U";
			
			Request.Email_Server = "mail.advmediaproductions.com";
			Request.Admin_Email = "info@advmediaproductions.com";
			Request.Error_Email = "info@advmediaproductions.com";
					
			Request.Root.Server = "d:\inetpub\wwwroot\U4U\";
			
			Request.RecordsPerPage = 10;
			REQUEST.LoginFailureMax = 5;
			REQUEST.ShortDescriptionLength = 50;
			
			/* Number of hours that must elapse before another impression is tracked for the current user */
			Request.UniqueUserHourThrottle = (1/60); /* 1 minute for local */
			
			Request.EditorPath = "U4U";
			
			Request.IsFrontEnd = false;
			Request.ShowDebug = false;
			break;
		}
		
		/* BETA */
		case "U4U.advanced-media-productions.com": {
			REQUEST.Dsource = "beta_U4U";
			REQUEST.SiteName = "U4U";
			
			REQUEST.Email_Server = "mail.advmediaproductions.com";
			REQUEST.Sender_Email = "facebook@advmediaproductions.com";
			REQUEST.Admin_Email = "info@advmediaproductions.com";
			REQUEST.Error_Email = "info@advmediaproductions.com";
						
			REQUEST.Root.Server = "c:\inetpub\wwwroot\U4U\";			
			
			REQUEST.RecordsPerPage = 10;
			REQUEST.LoginFailureMax = 5;
			REQUEST.ShortDescriptionLength = 50;
			
			/* Number of hours that must elapse before another impression is tracked for the current user */
			REQUEST.UniqueUserHourThrottle = 1; /* 1 hour for beta */
			
			Request.EditorPath = "U4U";
			
			Request.IsFrontEnd = false;
			Request.ShowDebug = false;
			break;
		}
		
		/* LIVE */
		default: {
			REQUEST.Dsource = "live_U4U";
			REQUEST.SiteName = "U4U";
			
			REQUEST.Email_Server = "mail.advmediaproductions.com";
			REQUEST.Sender_Email = "facebook@advmediaproductions.com";
			REQUEST.Admin_Email = "info@advmediaproductions.com";
			REQUEST.Error_Email = "info@advmediaproductions.com";
						
			REQUEST.Root.Server = "d:\inetpub\wwwroot\U4U\";			
			
			REQUEST.RecordsPerPage = 10;
			REQUEST.LoginFailureMax = 5;
			REQUEST.ShortDescriptionLength = 50;
			
			/* Number of hours that must elapse before another impression is tracked for the current user */
			REQUEST.UniqueUserHourThrottle = 1; /* 1 hour for live */
			
			Request.EditorPath = "U4U";
			
			Request.IsFrontEnd = false;
			Request.ShowDebug = false;
			break;
		}
		
	}
	
	REQUEST.Root.Image = REQUEST.Root.Server & "images\";
	REQUEST.Root.Template = REQUEST.Root.Image & "templates\";
	
	Request.Root.Advertisement = StructNew();
	Request.Root.Advertisement.Creative = Request.Root.Image & "advertisement\";
	
	Request.Root.Deal = StructNew();
	Request.Root.Deal.Original = Request.Root.Image & "deal\original\";
	Request.Root.Deal.Thumbnail = Request.Root.Image & "deal\thumb\";
	Request.Root.Deal.Fullsize = Request.Root.Image & "deal\full\";
	
	Request.Root.Job = StructNew();
	Request.Root.Job.Original = Request.Root.Image & "job\original\";
	Request.Root.Job.Thumbnail = Request.Root.Image & "job\thumb\";
	Request.Root.Job.Fullsize = Request.Root.Image & "job\full\";
	
	Request.Root.Marketplace = StructNew();
	Request.Root.Marketplace.Original = Request.Root.Image & "marketplace\original\";
	Request.Root.Marketplace.Thumbnail = Request.Root.Image & "marketplace\thumb\";
	Request.Root.Marketplace.Fullsize = Request.Root.Image & "marketplace\full\";
	
	Request.Root.Event = StructNew();
	Request.Root.Event.Original = Request.Root.Image & "event\original\";
	Request.Root.Event.Thumbnail = Request.Root.Image & "event\thumb\";
	Request.Root.Event.Fullsize = Request.Root.Image & "event\full\";
	
	Request.Root.StudyGroup = StructNew();
	Request.Root.StudyGroup.Original = Request.Root.Image & "studygroup\original\";
	Request.Root.StudyGroup.Thumbnail = Request.Root.Image & "studygroup\thumb\";
	Request.Root.StudyGroup.Fullsize = Request.Root.Image & "studygroup\full\";
	
	Request.Root.User = StructNew();
	Request.Root.User.Original = Request.Root.Image & "user\original\";
	Request.Root.User.Thumbnail = Request.Root.Image & "user\thumb\";
	Request.Root.User.Fullsize = Request.Root.Image & "user\full\";
	
	Request.Images.Deal = StructNew();
	Request.Images.Deal.ThumbnailWidth = 75;
	Request.Images.Deal.FullsizeWidth = 400;
	
	Request.Images.Job = StructNew();
	Request.Images.Job.ThumbnailWidth = 75;
	Request.Images.Job.FullsizeWidth = 400;
	
	Request.Images.Marketplace = StructNew();
	Request.Images.Marketplace.ThumbnailWidth = 75;
	Request.Images.Marketplace.FullsizeWidth = 400;
	
	Request.Images.Event = StructNew();
	Request.Images.Event.ThumbnailWidth = 75;
	Request.Images.Event.FullsizeWidth = 400;
	
	Request.Images.StudyGroup = StructNew();
	Request.Images.StudyGroup.ThumbnailWidth = 75;
	Request.Images.StudyGroup.FullsizeWidth = 400;
	
	Request.Images.User = StructNew();
	Request.Images.User.ThumbnailWidth = 60;
	Request.Images.User.FullsizeWidth = 400;
	
	Request.Images.Deal = StructNew();
	Request.Images.Deal.ThumbnailWidth = 75;
	Request.Images.Deal.FullsizeWidth = 400;
	
	Request.Images.Marketplace = StructNew();
	Request.Images.Marketplace.ThumbnailWidth = 75;
	Request.Images.Marketplace.FullsizeWidth = 400;
	
	Request.Images.Party = StructNew();
	Request.Images.Party.ThumbnailWidth = 75;
	Request.Images.Party.FullsizeWidth = 400;
	
	Request.Images.User = StructNew();
	Request.Images.User.ThumbnailWidth = 60;
	Request.Images.User.FullsizeWidth = 400;

</cfscript>

<cfapplication name="#Request.SiteName#__ADMIN" sessionmanagement="yes" sessiontimeout="#CreateTimeSpan(0,2,0,0)#" />

<cfsetting showdebugoutput="#Request.ShowDebug#" />

<!--- Need to keep track of where the Administrator currently is --->
<cflock timeout="10" scope="SESSION" type="EXCLUSIVE">
	<cfif StructKeyExists( URL, "Event" ) AND StructKeyExists( SESSION, "SectionQuery" )>
		<cfset variables.Admin = CreateObject( "component", "#request.sitename#.functionpages.Admin" ) />
		<cfset variables.CurrentSection = variables.Admin.GetAdminSection( AdminSectionQuery:Session.SectionQuery, EventName:URL.Event ) />
		<cfif len( variables.CurrentSection )>
			<cfset Session.NavSection = variables.CurrentSection />
		</cfif>		
	</cfif>
		
	<cfif not StructKeyExists(Session, "Admin")>
		<cfif Not StructKeyExists(Form, "Username") AND CGI.QUERY_STRING DOES NOT CONTAIN "Login">
			<cflocation url="index.cfm?event=Admin.Login" addtoken="no" />	
		</cfif>	
	</cfif>
</cflock>	

<!--- cause session vars to expire after the browser closes --->               
<cflock timeout="180" scope="SESSION" type="READONLY">
     <cfcookie name="CFID" value="#SESSION.CFID#">
     <cfcookie name="CFTOKEN" value="#SESSION.CFTOKEN#">
</cflock>

<cfparam name="URL.Source" default="" />
