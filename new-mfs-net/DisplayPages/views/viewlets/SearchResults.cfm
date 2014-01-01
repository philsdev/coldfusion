<cfscript>
	variables.LinkManager = Request.ListenerManager.GetListener( "LinkManager" );
	variables.ImageManager = Request.ListenerManager.GetListener( "ImageManager" );
</cfscript>

<div class="headerFunctions clearfix">
	<ul class="sortingOptions fl">
		<li><cfoutput><strong>#NumberFormat( request.SearchProducts.Row_Total )# Products Found</strong></cfoutput></li>
	</ul>
	<cfoutput>#Request.GridPagination#</cfoutput>
</div>
<ul class="productCatalog contentList grid">
	<cfoutput query="Request.SearchProducts">
		<cfset variables.ProductName = variables.LinkManager.GetDisplayName( Request.SearchProducts.ProductName ) />
		<cfset variables.ProductLink = variables.LinkManager.GetProductLink( ProductID:Request.SearchProducts.ProductID, ProductTitle:variables.ProductName ) />
		<cfset variables.ProductImageUrl = variables.ImageManager.GetImageUrl( FileName:Request.SearchProducts.ImageName, ImageCategory:"product", ImageType:"list" ) />
		<li>
			<div class="itemImage">
				<a href="#variables.ProductLink#"><img src="#variables.ProductImageUrl#" /></a>
			</div>
			<dl class="meta">
				<dt><a href="#variables.ProductLink#">#variables.ProductName#</a></dt>
				<dt>#DollarFormat(Request.SearchProducts.ProductPrice)#</dt>
			</dl>
		</li>
		<!--- need clearing element after every 4th item --->
		<cfif Request.SearchProducts.CurrentRow MOD 4 EQ 0>
			<li class="clearit"></li>
		</cfif>
	</cfoutput>
</ul>