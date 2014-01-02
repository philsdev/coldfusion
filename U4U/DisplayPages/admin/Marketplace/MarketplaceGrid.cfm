<cfif Request.Marketplace.recordcount GT 0>
	<h2 class="sectionTitle">Marketplace</h2>
	<table class="existingItemsTable" width="100%" cellspacing="0" cellpadding="0">
		<thead>
			<tr>
				<th sidx="title">Title</th>
				<th sidx="category">Category</th>
				<th sidx="user">User</th>
				<th sidx="price">Price</th>
				<th sidx="startdate">Start Date</th>
				<th sidx="enddate">End Date</th>				
				<th sidx="datecreated">Date Created</th>
				<th sidx="status">Status</th>
				<th>Functions</th>
			</tr>
		</thead>
		<tbody>
		<cfoutput query="Request.Marketplace">
			<tr rowid="#Request.Marketplace.ID#">
				<td>#Request.Marketplace.Title#</td>
				<td>#Request.Marketplace.Category#</td>
				<td>#Request.Marketplace.Username#</td>
				<td>#DollarFormat( Request.Marketplace.Price )#</td>				
				<td>#Request.Marketplace.StartDate#</td>
				<td>#Request.Marketplace.EndDate#</td>
				<td>#Request.Marketplace.DateCreated#</td>
				<td>#Request.Marketplace.Status#</td>
				<td class="functions"><a>Edit</a> | <a>Delete</a></td>      
			</tr>
		</cfoutput>
		</tbody>                    
	</table>
<cfelse>
	<p style="margin-left:10px;">There were no items found.</p>
</cfif>

<cfoutput>#Request.GridPagination#</cfoutput>