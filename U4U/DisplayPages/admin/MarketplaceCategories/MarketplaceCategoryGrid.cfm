<cfif Request.MarketplaceCategories.recordcount GT 0>
	<h2 class="sectionTitle">Marketplace Categories</h2>
	<table class="existingItemsTable" width="100%" cellspacing="0" cellpadding="0">
		<thead>
			<tr>
				<th sidx="title">Title</th>
				<th sidx="datecreated">Date Created</th>
				<th sidx="status">Status</th>
				<th>Functions</th>
			</tr>
		</thead>
		<tbody>
		<cfoutput query="Request.MarketplaceCategories">
			<tr rowid="#Request.MarketplaceCategories.ID#">
				<td>#Request.MarketplaceCategories.Title#</td>
				<td>#Request.MarketplaceCategories.DateCreated#</td>
				<td>#Request.MarketplaceCategories.Status#</td>
				<td class="functions"><a>Edit</a> | <a>Delete</a></td>      
			</tr>
		</cfoutput>
		</tbody>                    
	</table>
<cfelse>
	<p style="margin-left:10px;">There were no marketplace categories found.</p>
</cfif>

<cfoutput>#Request.GridPagination#</cfoutput>