<!------------------------------------------------------------------------------------------

	EventDetails.cfm

------------------------------------------------------------------------------------------->

<cfscript>

	variables.AdminManager = Request.ListenerManager.GetListener( "AdminManager" );
	variables.LinkManager = Request.ListenerManager.GetListener( "LinkManager" );
	
	variables.ItemFullsizePath = variables.AdminManager.GetItemFullsize( ItemKey:"event", ItemID:Request.Events.ID );
	variables.CategoryLink = variables.LinkManager.GetEventCategoryLink( CategoryID:Request.Events.CategoryID, CategoryTitle:Request.Events.Category );
	variables.Description = variables.AdminManager.GetFormattedDescription( Description:Request.Events.Description );
	variables.ContactLink = "/event-#Request.Events.ID#/contact.html";
	variables.ProfileLink = variables.LinkManager.GetProfileLink( UserID:Request.Events.UserID, Username:Request.Events.Username );	
	variables.EditLink = "/event-edit-#Request.Events.ID#.html";
	variables.MapLink = variables.LinkManager.GetMapLink( AddressID:Request.Events.AddressID );
	variables.ItemLink = variables.LinkManager.GetEventLink( EventID:Request.Events.ID, EventTitle:Request.Events.Title );
	variables.SocialMediaLink = variables.LinkManager.GetAbsoluteUrl( RelativeUrl:variables.ItemLink );
	
	REQUEST.Meta.Title = "Event - " & Request.Events.Title;
	REQUEST.Meta.Description = variables.Description;
	REQUEST.Meta.Url = variables.SocialMediaLink;
	
	if (LEN( variables.ItemFullsizePath )) {
		variables.SocialMediaImageUrl = variables.LinkManager.GetAbsoluteUrl( RelativeUrl:variables.ItemFullsizePath );
		REQUEST.Meta.Image = variables.SocialMediaImageUrl;
	}
	
</cfscript>

<cfoutput>

<div id="content">
	<div id="breadcrumb">
		<a href="/" title="">Home</a>
		<a href="/events.html" title="">Events</a>
		<span>#Request.Events.Title#</span>
	</div>
	
	<header class="contentListHeader clearfix">
		<h1>#Request.Events.Title#</h1>
	</header>
	
	<section class="listSection">
		<dl class="meta">
			<dd>Category: <a href="#variables.CategoryLink#">#Request.Events.Category#</a></dd>
			<cfif IsDate(Request.Events.StartDate)>
				<cfif IsDate(Request.Events.EndDate) AND Request.Events.StartDate NEQ Request.Events.EndDate>
				<dd class="date">
					Date: #DateFormat( Request.Events.StartDate, 'medium' )# #TimeFormat( Request.Events.StartDate, 'short' )# 
					- #DateFormat( Request.Events.EndDate, 'medium' )# #TimeFormat(Request.Events.EndDate, 'short' )# 
				</dd>
			<cfelse>
				<dd class="date">Date: #DateFormat( Request.Events.StartDate, 'medium' )#</dd>
				<dd class="time">Time: #TimeFormat( Request.Events.StartTime, 'short' )# - #TimeFormat( Request.Events.EndTime, 'short' )#</dd>
			</cfif>
			</cfif>
			<dd class="address">
				Location: #variables.MapLink#
			</dd>
			<dd>Organized by: #Request.Events.Organizer#</dd>
			<dd>Contact: <a href="#variables.ContactLink#" class="fancyPopup"><strong>Contact this organizer</strong></a></dd>
			<dd class="socialMedia">
				<span class="st_twitter_hcount" st_title="#Request.Events.Title#" displayText="Tweet"></span>
				<span class="st_sharethis_hcount" st_title="#Request.Events.Title#" displayText="Share"></span>
				<fb:like font="verdana" href="#variables.SocialMediaLink#" layout="button_count" show_faces="true" class="fbLikeBtn"></fb:like>
			</dd>			
		</dl>

		<p>#variables.Description#</p>
		
		<cfif LEN( variables.ItemFullsizePath )>
			<div class="mediaContainer">
				<img src="#variables.ItemFullsizePath#" />
			</div>
		</cfif>
		
		<dl class="meta authorInfo">
			<dd class="postedBy">
				Posted by: 
				<a href="#variables.ProfileLink#">#Request.Events.Username#</a> on #Request.Events.DateCreated#
				<cfif Request.Events.UserID EQ Request.UserID>
					[ <a href="#variables.EditLink#">EDIT</a> ]
				</cfif>
			</dd>
		</dl>
	</section>

</div>

</cfoutput>

<div id="sidebar">
	<cfinclude template="#Request.ViewManager.getViewPath('Links.AccountDetails')#" />
	<cfinclude template="#Request.ViewManager.getViewPath('Links.Events')#" />	
	<div class="module">
		<div class="moduleContent">
			<cfoutput>#Request.AdPlacementRight#</cfoutput>
		</div>
	</div>
</div>

