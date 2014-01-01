<cfscript>
	variables.LinkManager = Request.ListenerManager.GetListener( "LinkManager" );
	variables.ProductFeatureManager = Request.ListenerManager.GetListener( "ProductFeatureManager" );
	variables.ImageManager = Request.ListenerManager.GetListener( "ImageManager" );
	
	variables.ProductFeatures = variables.ProductFeatureManager.GetProductFeatures();
</cfscript>

<ul class="productCatalog contentList grid">
	<cfoutput query="variables.ProductFeatures">
		<cfset variables.ProductName = variables.LinkManager.GetDisplayName( variables.ProductFeatures.ProductName ) />
		<cfset variables.ProductLink = variables.LinkManager.GetProductLink( ProductID:variables.ProductFeatures.ProductID, ProductTitle:variables.ProductName ) />
		<cfset variables.ProductImageUrl = variables.ImageManager.GetImageUrl( FileName:variables.ProductFeatures.ImageName, ImageCategory:"product", ImageType:"list" ) />
		<li>
			<div class="itemImage">
				<a href="#variables.ProductLink#"><img src="#variables.ProductImageUrl#" /></a>
			</div>
			<dl class="meta">
				<dt><a href="#variables.ProductLink#">#variables.ProductName#</a></dt>
				<dt>#DollarFormat(variables.ProductFeatures.ProductPrice)#</dt>
			</dl>
		</li>
		<!--- need clearing element after every 5th item --->
		<cfif variables.ProductFeatures.CurrentRow MOD 5 EQ 0>
			<li class="clearit"></li>
		</cfif>
	</cfoutput>
</ul>