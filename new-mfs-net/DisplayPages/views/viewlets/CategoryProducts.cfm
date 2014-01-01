<cfscript>
	variables.LinkManager = Request.ListenerManager.GetListener( "LinkManager" );
	variables.ImageManager = Request.ListenerManager.GetListener( "ImageManager" );
</cfscript>

<h2>Shop By Category</h2>
	
<cfif request.CategoryProducts.Recordcount>	
	<div class="headerFunctions clearfix">
		<ul class="sortingOptions fl">
			<li><cfoutput><strong>#NumberFormat( request.CategoryProducts.Row_Total )# Products Found</strong></cfoutput></li>
		</ul>
		<cfoutput>#Request.GridPagination#</cfoutput>
	</div>
	<ul class="productCatalog contentList grid ">
		<cfoutput query="request.CategoryProducts">
			<cfset variables.ProductName = variables.LinkManager.GetDisplayName( request.CategoryProducts.ProductName ) />
			<cfset variables.ProductLink = variables.LinkManager.GetProductLink( ProductID:request.CategoryProducts.ProductID, ProductTitle:variables.ProductName ) />
			<cfset variables.ProductImageUrl = variables.ImageManager.GetImageUrl( FileName:request.CategoryProducts.ImageName, ImageCategory:"product", ImageType:"list" ) />
				
			<li>
				<div class="itemImage">
					<a href="#variables.ProductLink#"><img src="#variables.ProductImageUrl#" style="width:156px;" /></a>
				</div>
				<dl class="meta">
					<dt><a href="#variables.ProductLink#">#variables.ProductName#</a></dt>
					<dt>#DollarFormat(Request.CategoryProducts.ProductPrice)#</dt>
				</dl>
			</li>
			<cfif request.CategoryProducts.CurrentRow MOD 4 EQ 0>
				<li class="clearit"></li>
			</cfif>
		</cfoutput>
	</ul>
<cfelse>
	<p>No products found.</p>
</cfif>