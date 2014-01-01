<cfscript>
	variables.LinkManager = Request.ListenerManager.GetListener( "LinkManager" );
	variables.ImageManager = Request.ListenerManager.GetListener( "ImageManager" );
</cfscript>

<cfif request.CategoryFeaturedProducts.Recordcount>
	<section id="categoryFeatured">
		<h2>Featured Products</h2>
		<div class="headerFunctions clearfix">
			<ul class="sortingOptions fl">
				<li><cfoutput><strong>#NumberFormat( request.CategoryFeaturedProducts.Row_Total )# Products Found</strong></cfoutput></li>
				<!---
					<li>
						<label>Sort By</label>
						<select>
							<option>Name</option>
						</select>
					</li>
					<li>
						<label>Products Per Page</label>
						<select>
							<option>Name</option>
						</select>
					</li>
				--->
			</ul>
			<cfoutput>#Request.GridPagination#</cfoutput>
		</div>
		
		<ul class="productCatalog contentList grid ">
			<cfoutput query="request.CategoryFeaturedProducts">
				<cfset variables.ProductName = variables.LinkManager.GetDisplayName( request.CategoryFeaturedProducts.ProductName ) />
				<cfset variables.ProductLink = variables.LinkManager.GetProductLink( ProductID:request.CategoryFeaturedProducts.ProductID, ProductTitle:variables.ProductName ) />
				<cfset variables.ProductImageUrl = variables.ImageManager.GetImageUrl( FileName:request.CategoryFeaturedProducts.ImageName, ImageCategory:"product", ImageType:"list" ) />
				<li>
					<div class="itemImage">
						<a href="#variables.ProductLink#"><img src="#variables.ProductImageUrl#" style="width:156px;" /></a>
					</div>
					<dl class="meta">
						<dt><a href="#variables.ProductLink#">#variables.ProductName#</a></dt>						
						<cfif request.CategoryFeaturedProducts.ProductDiscountPrice GT 0>
							<dd class="price strike">#DollarFormat(request.CategoryFeaturedProducts.ProductOurPrice)#</dd>
							<dd class="salePrice">#DollarFormat(request.CategoryFeaturedProducts.ProductDiscountPrice)#</dd>
						<cfelse>
							<dd class="price">#DollarFormat(request.CategoryFeaturedProducts.ProductOurPrice)#</dd>
						</cfif>
					</dl>
				</li>
				<cfif request.CategoryFeaturedProducts.CurrentRow MOD 4 EQ 0>
					<li class="clearit"></li>
				</cfif>
			</cfoutput>			
		</ul>
	</section>
</cfif>