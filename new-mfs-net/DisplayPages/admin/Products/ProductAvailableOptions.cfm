<cfscript>
	variables.ProductUpsellManager = Request.ListenerManager.GetListener( "ProductUpsellManager" );
</cfscript>

<cfloop query="request.AvailableProducts">
	<cfset variables.ProductUpsellTitle = variables.ProductUpsellManager.GetProductUpsellTitle(
		ProductID:request.AvailableProducts.ProductID,
		ProductTitle:request.AvailableProducts.ProductName,
		VendorName:request.AvailableProducts.VendorName,
		ProductItemNumber:request.AvailableProducts.ProductItemNumber
	) />
	<cfoutput><option value="#request.AvailableProducts.ProductID#">#variables.ProductUpsellTitle#</option></cfoutput>
</cfloop>