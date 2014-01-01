<cfscript>
	variables.LinkManager = Request.ListenerManager.GetListener( "LinkManager" );
</cfscript>

<cfparam name="request.Vendors" default="" />

<cfif request.Vendors.recordcount GT 0>
	<h2 class="sectionTitle">Vendors</h2>
	<table class="existingItemsTable" width="100%" cellspacing="0" cellpadding="0">
		<thead>
			<tr>
				<th class="left" sidx="vendorname">Vendor Name</th>
				<th sidx="productcount">Products</th>
				<th sidx="status">Status</th>
				<th>Functions</th>
			</tr>
		</thead>
		<tbody>
		<cfoutput query="request.Vendors">
			<tr rowid="#request.Vendors.VendorID#">
				<td class="left">#variables.LinkManager.GetDisplayName( request.Vendors.VendorName )#</td>
				<td>#NumberFormat(request.Vendors.ProductCount)#</td>
				<td>#request.Vendors.Status#</td>
				<td class="functions"><a>Edit</a> | <a>Delete</a></td>      
			</tr>
		</cfoutput>
		</tbody>                    
	</table>
<cfelse>
	<p style="margin-left:10px;">There were no vendors found.</p>
</cfif>

<cfoutput>#Request.GridPagination#</cfoutput>