<cfparam name="request.PurchasedProducts" default="" />		

<cfif request.PurchasedProducts.recordcount GT 0>
	<h2 class="sectionTitle">Purchased Products</h2>
	<table class="existingItemsTable" width="100%" cellspacing="0" cellpadding="0">
		<thead>
			<tr>
				<th class="left" sidx="ProductName">Product Name</th>
				<th sidx="ProductID">Product ID</th>
				<th sidx="ProductTotal">Total Purchased</th>
				<!--- <th sidx="DateLastPurchased">Date Last Purchased</th> --->
			</tr>
		</thead>
		<tbody>
		<cfoutput query="request.PurchasedProducts">
			<tr rowid="#request.PurchasedProducts.RowNum#">
				<td class="left">#request.PurchasedProducts.ProductName#</td>
				<td>#request.PurchasedProducts.ProductID#</td>
				<td>#NumberFormat(request.PurchasedProducts.ProductTotal)#</td>
				<!--- <td>#request.PurchasedProducts.DateLastPurchased#</td>     ---> 
			</tr>
		</cfoutput>
		</tbody>                    
	</table>
<cfelse>
	<p style="margin-left:10px;">There were no Purchased Products found.</p>
</cfif>

<cfoutput>#Request.GridPagination#</cfoutput>