<cfscript>
	variables.LinkManager = Request.ListenerManager.GetListener( "LinkManager" );
</cfscript>

<cfif request.Products.recordcount GT 0>
	<h2 class="sectionTitle">Products</h2>
	<table class="existingItemsTable" width="100%" cellspacing="0" cellpadding="0">
		<thead>
			<tr>
				<th class="left" sidx="productname">Product Name</th>
				<th sidx="productitemnumber">Item Number</th>
				<th sidx="vendorname">Vendor</th>
				<th sidx="datecreated">Date Created</th>
				<th sidx="status">Status</th>
				<th>Functions</th>
			</tr>
		</thead>
		<tbody>
		<cfoutput query="request.Products">
			<tr rowid="#request.Products.ProductID#">
				<td class="left">#variables.LinkManager.GetDisplayName( request.Products.ProductName )#</td>
				<td>#request.Products.ProductItemNumber#</td>
				<td>#request.Products.VendorName#</td>
				<td>#request.Products.DateCreated#</td>
				<td>#request.Products.Status#</td>
				<td class="functions"><a>Edit</a> | <a>Delete</a></td>      
			</tr>
		</cfoutput>
		</tbody>                    
	</table>
<cfelse>
	<p style="margin-left:10px;">There were no products found.</p>
</cfif>

<cfoutput>#Request.GridPagination#</cfoutput>