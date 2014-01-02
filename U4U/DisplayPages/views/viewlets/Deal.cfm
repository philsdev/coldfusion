<!------------------------------------------------------------------------------------------

	Viewlet:Deal

------------------------------------------------------------------------------------------->

<cfscript>
	variables.AdminManager = Request.ListenerManager.GetListener( "AdminManager" );
	variables.LinkManager = Request.ListenerManager.GetListener( "LinkManager" );
	
	variables.ItemThumbnailPath = variables.AdminManager.GetItemThumbnail( ItemKey:"Deal", ItemID:Request.CurrentItem.ID );
	variables.ItemLink = variables.LinkManager.GetDealLink( DealID:Request.CurrentItem.ID, DealTitle:Request.CurrentItem.Title );
	variables.SocialMediaLink = variables.LinkManager.GetAbsoluteUrl( RelativeUrl:variables.ItemLink );
	variables.CategoryLink = variables.LinkManager.GetDealCategoryLink( CategoryID:Request.CurrentItem.CategoryID, CategoryTitle:Request.CurrentItem.Category );
	variables.ProfileLink = variables.LinkManager.GetProfileLink( UserID:Request.CurrentItem.UserID, Username:Request.CurrentItem.Username );
	variables.Description = variables.AdminManager.GetShortDescription( Description:Request.CurrentItem.Description );
	variables.EditLink = "/deal-edit-#Request.CurrentItem.ID#.html";
	variables.MapLink = variables.LinkManager.GetMapLink( AddressID:Request.CurrentItem.AddressID );
</cfscript>

<cfoutput>
<li <cfif NOT LEN( variables.ItemThumbnailPath )>class="noImage"</cfif>>
	<cfif LEN( variables.ItemThumbnailPath )>
		<a href="#variables.ItemLink#" class="dealPlacement" did="#Request.CurrentItem.ID#"><img src="#variables.ItemThumbnailPath#" class="itemImage" /></a>
	</cfif>
	<h3><a href="#variables.ItemLink#" class="dealPlacement" did="#Request.CurrentItem.ID#">#Request.CurrentItem.Title#</a></h3>
	<dl class="meta">
		<dd>From: <a href="#variables.CategoryLink#">#Request.CurrentItem.Category#</a></dd>
		<dd class="address">
			Location: #variables.MapLink#
		</dd>
		<!---dd class="socialMedia"></dd--->
	</dl>
	<p>
		#variables.Description#
		<a href="#variables.ItemLink#" class="moreLink dealPlacement" did="#Request.CurrentItem.ID#">Read more...</a>
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