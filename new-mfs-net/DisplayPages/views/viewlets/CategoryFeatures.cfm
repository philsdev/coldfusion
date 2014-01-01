<cfscript>
	variables.LinkManager = Request.ListenerManager.GetListener( "LinkManager" );
	variables.CategoryManager = Request.ListenerManager.GetListener( "CategoryManager" );
	variables.ImageManager = Request.ListenerManager.GetListener( "ImageManager" );
	
	variables.CategoryFeatures = variables.CategoryManager.GetHomePageCategoryFeatures();
</cfscript>

<ul class="productCatalog contentList grid">
	<cfoutput query="variables.CategoryFeatures">
		<cfset variables.CategoryName = variables.LinkManager.GetDisplayName( variables.CategoryFeatures.CategoryName ) />
		<cfset variables.CategoryLink = variables.LinkManager.GetCategoryLink( CategoryID:variables.CategoryFeatures.CategoryID, CategoryTitle:variables.CategoryFeatures.CategoryName ) />
		<cfset variables.CategoryImageUrl = variables.ImageManager.GetImageUrl( FileName:variables.CategoryFeatures.ImageName, ImageCategory:"Category", ImageType:"list" ) />
		<li>
			<div class="itemImage">
				<a href="#variables.CategoryLink#"><img src="#variables.CategoryImageUrl#" /></a>
			</div>
			<dl class="meta">
				<dt><a href="#variables.CategoryLink#">#variables.CategoryName#</a></dt>
			</dl>
		</li>
		<!--- need clearing element after every 5th item --->
		<cfif variables.CategoryFeatures.CurrentRow MOD 5 EQ 0>
			<li class="clearit"></li>
		</cfif>
	</cfoutput>
</ul>