<!------------------------------------------------------------------------------------------

	MarketplaceDetails.cfm

------------------------------------------------------------------------------------------->

<cfscript>

	variables.AdminManager = Request.ListenerManager.GetListener( "AdminManager" );
	variables.LinkManager = Request.ListenerManager.GetListener( "LinkManager" );
	variables.ItemFullsizePath = variables.AdminManager.GetItemFullsize( ItemKey:"marketplace", ItemID:Request.Item.ID );
	variables.CategoryLink = variables.LinkManager.GetMarketplaceCategoryLink( CategoryID:Request.Item.CategoryID, CategoryTitle:Request.Item.Category );
	variables.Description = variables.AdminManager.GetFormattedDescription( Description:Request.Item.Description );
	variables.ContactLink = "/marketplace-#Request.Item.ID#/contact.html";
	variables.ProfileLink = variables.LinkManager.GetProfileLink( UserID:Request.Item.UserID, Username:Request.Item.Username );	
	variables.ItemLink = variables.LinkManager.GetMarketplaceLink( MarketplaceID:Request.Item.ID, MarketplaceTitle:Request.Item.Title );
	variables.SocialMediaLink = variables.LinkManager.GetAbsoluteUrl( RelativeUrl:variables.ItemLink );
	
	REQUEST.Meta.Title = "Marketplace Item - " & Request.Item.Title;
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
		<a href="/marketplace.html" title="">Marketplace</a>
		<span>#Request.Item.Title#</span>
	</div>
	
	<header class="contentListHeader clearfix">
		<h1>#Request.Item.Title#</h1>
	</header>
	
	<section class="listSection">
		<dl class="meta">
			<dd class="price">#DollarFormat( Request.Item.Price )#</dd>
			<dd class="date">Category: <a href="#variables.CategoryLink#">#Request.Item.Category#</a></dd>
			<dd>Contact: <a href="#variables.ContactLink#" class="fancyPopup"><strong>Contact this seller</strong></a></dd>            
			<dd class="socialMedia">
				<span class="st_twitter_hcount" st_title="#Request.Item.Title#" displayText="Tweet"></span>
				<span class="st_sharethis_hcount" st_title="#Request.Item.Title#" displayText="Share"></span>
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
			<dd class="postedBy">Posted by: <a href="#variables.ProfileLink#">#Request.Item.Username#</a> on #Request.Item.DateCreated#</dd>
		</dl>
	</section>
</div>

</cfoutput>

<div id="sidebar">
	<cfinclude template="#Request.ViewManager.getViewPath('Links.AccountDetails')#" />
	<cfinclude template="#Request.ViewManager.getViewPath('Links.Marketplace')#" />	
	<div class="module">
		<div class="moduleContent">
			<cfoutput>#Request.AdPlacementRight#</cfoutput>
		</div>
	</div>
</div>