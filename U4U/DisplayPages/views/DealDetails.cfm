<!------------------------------------------------------------------------------------------

	DealDetails.cfm

------------------------------------------------------------------------------------------->

<cfscript>

	variables.AdminManager = Request.ListenerManager.GetListener( "AdminManager" );
	variables.LinkManager = Request.ListenerManager.GetListener( "LinkManager" );
	
	variables.ItemFullsizePath = variables.AdminManager.GetItemFullsize( ItemKey:"Deal", ItemID:Request.Deal.ID );
	variables.CategoryLink = variables.LinkManager.GetDealCategoryLink( CategoryID:Request.Deal.CategoryID, CategoryTitle:Request.Deal.Category );
	variables.Description = variables.AdminManager.GetFormattedDescription( Description:Request.Deal.Description );
	variables.ContactLink = "/deal-#Request.Deal.ID#/contact.html";
	variables.ProfileLink = variables.LinkManager.GetProfileLink( UserID:Request.Deal.UserID, Username:Request.Deal.Username );	
	variables.EditLink = "/deal-edit-#Request.Deal.ID#.html";
	variables.MapLink = variables.LinkManager.GetMapLink( AddressID:Request.Deal.AddressID );
	variables.ItemLink = variables.LinkManager.GetDealLink( DealID:Request.Deal.ID, DealTitle:Request.Deal.Title );
	variables.SocialMediaLink = variables.LinkManager.GetAbsoluteUrl( RelativeUrl:variables.ItemLink );
	
	REQUEST.Meta.Title = "Deal - " & Request.Deal.Title;
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
		<a href="/deals.html" title="">Deals</a>
		<span>#Request.Deal.Title#</span>
	</div>
	
	<header class="contentListHeader clearfix">
		<h1>#Request.Deal.Title#</h1>
	</header>
	
	<section class="listSection">
		<dl class="meta">
			<dd>From: <a href="#variables.CategoryLink#">#Request.Deal.Category#</a></dd>
			<dd class="address">
				Location: #variables.MapLink#
			</dd>
			<dd>Contact: <a href="#variables.ContactLink#" class="fancyPopup"><strong>Contact this company</strong></a></dd>
			<dd><a href="#Request.Deal.DestinationUrl#" target="_blank">#Request.Deal.DestinationUrl#</a></dd>
				<dd class="socialMedia">
				<span class="st_twitter_hcount" st_title="#Request.Deal.Title#" displayText="Tweet"></span>
				<span class="st_sharethis_hcount" st_title="#Request.Deal.Title#" displayText="Share"></span>
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
				<a href="#variables.ProfileLink#">#Request.Deal.Username#</a> on #Request.Deal.DateCreated#
				<cfif Request.Deal.UserID EQ Request.UserID>
					[ <a href="#variables.EditLink#">EDIT</a> ]
				</cfif>
			</dd>
		</dl>
	</section>

</div>

</cfoutput>

<div id="sidebar">
	<cfinclude template="#Request.ViewManager.getViewPath('Links.AccountDetails')#" />
	<cfinclude template="#Request.ViewManager.getViewPath('Links.Deals')#" />
	<div class="module">
		<div class="moduleContent">
			<cfoutput>#Request.AdPlacementRight#</cfoutput>
		</div>
	</div>
</div>

