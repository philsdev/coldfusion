<cfscript>
	variables.LinkManager = Request.ListenerManager.GetListener( "LinkManager" );
	variables.ImageManager = Request.ListenerManager.GetListener( "ImageManager" );
</cfscript>

<cfif request.ProductUpsells.RecordCount>
	<div id="upsell">
		<h2>You May Also Be Interested In:</h2>
		<ul class="productCatalog contentList grid">
			<cfoutput query="request.ProductUpsells">
				<cfset variables.ProductName = variables.LinkManager.GetDisplayName( request.ProductUpsells.ProductName ) />
				<cfset variables.ProductLink = variables.LinkManager.GetProductLink( ProductID:request.ProductUpsells.ProductID, ProductTitle:variables.ProductName ) />
				<cfset variables.ProductImageUrl = variables.ImageManager.GetImageUrl( FileName:request.ProductUpsells.ImageName, ImageCategory:"product", ImageType:"list" ) />
				<li>
					<div class="itemImage">
						<a href="#variables.ProductLink#"><img src="#variables.ProductImageUrl#" style="width:156px;" /></a>
					</div>
					<dl class="meta">
						<dt><a href="#variables.ProductLink#">#variables.ProductName#</a></dt>
						<cfif request.ProductUpsells.ProductDiscountPrice GT 0>
							<dd class="price strike">#DollarFormat(request.ProductUpsells.ProductOurPrice)#</dd>
							<dd class="salePrice">#DollarFormat(request.ProductUpsells.ProductDiscountPrice)#</dd>
						<cfelse>
							<dd class="price">#DollarFormat(request.ProductUpsells.ProductOurPrice)#</dd>
						</cfif>
					</dl>
				</li>
				<cfif request.ProductUpsells.CurrentRow MOD 5 EQ 0>
					<li class="clearit"></li>
				</cfif>
			</cfoutput>
		</ul>
	</div>
</cfif>