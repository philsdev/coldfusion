<!------------------------------------------------------------------------------------------

	Viewlet:Job

------------------------------------------------------------------------------------------->

<cfscript>
	variables.AdminManager = Request.ListenerManager.GetListener( "AdminManager" );
	variables.LinkManager = Request.ListenerManager.GetListener( "LinkManager" );
	
	variables.ItemThumbnailPath = variables.AdminManager.GetItemThumbnail( ItemKey:"Job", ItemID:Request.CurrentItem.ID );
	variables.ItemLink = variables.LinkManager.GetJobLink( JobID:Request.CurrentItem.ID, JobTitle:Request.CurrentItem.Title );
	variables.SocialMediaLink = variables.LinkManager.GetAbsoluteUrl( RelativeUrl:variables.ItemLink );
	variables.CategoryLink = variables.LinkManager.GetJobCategoryLink( CategoryID:Request.CurrentItem.CategoryID, CategoryTitle:Request.CurrentItem.Category );
	variables.ProfileLink = variables.LinkManager.GetProfileLink( UserID:Request.CurrentItem.UserID, Username:Request.CurrentItem.Username );
	variables.Description = variables.AdminManager.GetShortDescription( Description:Request.CurrentItem.Description );
	variables.EditLink = "/job-edit-#Request.CurrentItem.ID#.html";
	variables.MapLink = variables.LinkManager.GetMapLink( AddressID:Request.CurrentItem.AddressID );
</cfscript>

<cfoutput>
<li <cfif NOT LEN( variables.ItemThumbnailPath )>class="noImage"</cfif>>
	<cfif LEN( variables.ItemThumbnailPath )>
		<a href="#variables.ItemLink#"><img src="#variables.ItemThumbnailPath#" class="itemImage" /></a>
	</cfif>
	<h3><a href="#variables.ItemLink#">#Request.CurrentItem.Title#</a></h3>
	<dl class="meta">
		<dd>Type: <a href="#variables.CategoryLink#">#Request.CurrentItem.Category#</a></dd>
		<dd class="address">
			Location: #variables.MapLink#
		</dd>
		<!---dd class="socialMedia">
			<span class="st_twitter_hcount" st_url="#variables.SocialMediaLink#" st_title="#Request.CurrentItem.Title#" displayText="Tweet"></span>
			<span class="st_sharethis_hcount" st_url="#variables.SocialMediaLink#" st_title="#Request.CurrentItem.Title#" displayText="Share"></span>
			<fb:like href="#variables.SocialMediaLink#" font="verdana" layout="button_count" show_faces="true" class="fbLikeBtn"></fb:like>
		</dd--->
	</dl>
	<p>
		#variables.Description#
		<a href="#variables.ItemLink#" class="moreLink">Read more...</a>
	</p>
	<dl class="meta authorInfo">
		<dd class="postedBy">
			Posted by: <a href="#variables.ProfileLink#">#Request.CurrentItem.Username#</a> on #Request.CurrentItem.DateCreated#
			<cfif Request.CurrentItem.UserID EQ Request.UserID>
				[ <a href="#variables.EditLink#">EDIT</a> ]
			</cfif>
		</dd>
	</dl>
</li>
</cfoutput>