<!------------------------------------------------------------------------------------------

	JobDetails.cfm

------------------------------------------------------------------------------------------->

<cfscript>

	variables.AdminManager = Request.ListenerManager.GetListener( "AdminManager" );
	variables.LinkManager = Request.ListenerManager.GetListener( "LinkManager" );
	
	variables.ItemFullsizePath = variables.AdminManager.GetItemFullsize( ItemKey:"Job", ItemID:Request.Job.ID );
	variables.CategoryLink = variables.LinkManager.GetJobCategoryLink( CategoryID:Request.Job.CategoryID, CategoryTitle:Request.Job.Category );
	variables.Description = variables.AdminManager.GetFormattedDescription( Description:Request.Job.Description );
	variables.ContactLink = "/job-#Request.Job.ID#/contact.html";
	variables.ProfileLink = variables.LinkManager.GetProfileLink( UserID:Request.Job.UserID, Username:Request.Job.Username );	
	variables.EditLink = "/job-edit-#Request.Job.ID#.html";
	variables.MapLink = variables.LinkManager.GetMapLink( AddressID:Request.Job.AddressID );
	variables.ItemLink = variables.LinkManager.GetJobLink( JobID:Request.Job.ID, JobTitle:Request.Job.Title );
	variables.SocialMediaLink = variables.LinkManager.GetAbsoluteUrl( RelativeUrl:variables.ItemLink );
	
	REQUEST.Meta.Title = "Job - " & Request.Job.Title;
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
		<a href="/jobs.html" title="">Jobs</a>
		<span>#Request.Job.Title#</span>
	</div>
	
	<header class="contentListHeader clearfix">
		<h1>#Request.Job.Title#</h1>
	</header>
	
	<section class="listSection">
		<dl class="meta">
			<dd>Employer: #Request.Job.CompanyName#</dd>
			<dd>Type: <a href="#variables.CategoryLink#">#Request.Job.Category#</a></dd>
			<dd class="address">
				Location: #variables.MapLink#
			</dd>
			<dd>Contact: <a href="#variables.ContactLink#" class="fancyPopup"><strong>Contact this company</strong></a></dd>
            <dd class="socialMedia">
				<span class="st_twitter_hcount" st_title="#Request.Job.Title#" displayText="Tweet"></span>
				<span class="st_sharethis_hcount" st_title="#Request.Job.Title#" displayText="Share"></span>
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
				<a href="#variables.ProfileLink#">#Request.Job.Username#</a> on #Request.Job.DateCreated#
				<cfif Request.Job.UserID EQ Request.UserID>
					[ <a href="#variables.EditLink#">EDIT</a> ]
				</cfif>
			</dd>
		</dl>
	</section>

</div>

</cfoutput>

<div id="sidebar">
	<cfinclude template="#Request.ViewManager.getViewPath('Links.AccountDetails')#" />
	<cfinclude template="#Request.ViewManager.getViewPath('Links.Jobs')#" />
	<div class="module">
		<div class="moduleContent">
			<cfoutput>#Request.AdPlacementRight#</cfoutput>
		</div>
	</div>
</div>

