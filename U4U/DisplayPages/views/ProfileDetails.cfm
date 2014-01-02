<!------------------------------------------------------------------------------------------

	ProfileDetails.cfm

------------------------------------------------------------------------------------------->

<cfscript>

	variables.AdminManager = Request.ListenerManager.GetListener( "AdminManager" );
	variables.ItemFullsizePath = variables.AdminManager.GetItemFullsize( ItemKey:"user", ItemID:Request.Profile.ID );
	variables.ContactLink = "/profile-#Request.Profile.ID#/contact.html";
	
	Request.Meta.Title = "Profile - " & Request.Profile.Username;
	Request.Meta.Description = "User profile";
	
</cfscript>

<cfoutput>

<div id="content">
	<div id="breadcrumb">
		<a href="/" title="">Home</a>
		<a href="/" title="">User Profiles</a>
		<span>#Request.Profile.Username#</span>
	</div>
	
	<header class="contentListHeader clearfix">
		<h1>#Request.Profile.Username#</h1>
	</header>
	
	<section class="listSection">
		<dl class="meta">
			<dd>School: #Request.Profile.SchoolName#</dd>
			<dd>Location: #Request.Profile.City#, #Request.Profile.State#</dd>
			<dd>Contact: <a href="#variables.ContactLink#" class="fancyPopup">Contact this user</a></dd>
		</dl>

		<!---p>#Request.Item.Description#</p--->
		
        <cfif isDefined('variables.ItemFullsizePath') and  variables.ItemFullsizePath is NOT "">
		<div class="mediaContainer">
			<img src="#variables.ItemFullsizePath#" alt="#Request.Profile.Username#" />
		</div>
        </cfif>
		
		<dl class="meta authorInfo">
			<dd class="postedBy">Member since #DateFormat( Request.Profile.DateCreated, "mmm, yyyy" )#</dd>
		</dl>
	</section>

</div>

<div id="sidebar">
	<cfinclude template="#Request.ViewManager.getViewPath('Links.AccountDetails')#" />
	<div class="module">
		<div class="moduleContent">
			#Request.AdPlacementRight#
		</div>
	</div>
</div>

</cfoutput>