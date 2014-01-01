<cfparam name="request.Attributes" default="" />

<cfif request.Attributes.recordcount GT 0>
	<h2 class="sectionTitle">Attributes</h2>
	<table class="existingItemsTable" width="100%" cellspacing="0" cellpadding="0">
		<thead>
			<tr>
				<th class="left" sidx="vendorname">Attribute Name</th>
				<th sidx="productcount">Options</th>
				<th sidx="status">Status</th>
				<th>Functions</th>
			</tr>
		</thead>
		<tbody>
		<cfoutput query="request.Attributes">
			<tr rowid="#request.Attributes.ProductAttributeID#">
				<td class="left">#request.Attributes.ProductAttributeName#</td>
				<td>#NumberFormat(request.Attributes.ProductCount)#</td>
				<td>#request.Attributes.Status#</td>
				<td class="functions"><a>Edit</a> | <a>Delete</a></td>      
			</tr>
		</cfoutput>
		</tbody>                    
	</table>
<cfelse>
	<p style="margin-left:10px;">There were no Attribute found.</p>
</cfif>

<cfoutput>#Request.GridPagination#</cfoutput>
