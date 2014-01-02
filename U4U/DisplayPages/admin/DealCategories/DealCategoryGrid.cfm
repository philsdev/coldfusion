<cfif Request.DealCategories.recordcount GT 0>
	<h2 class="sectionTitle">Deal Categories</h2>
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
		<cfoutput query="Request.DealCategories">
			<tr rowid="#Request.DealCategories.ID#">
				<td>#Request.DealCategories.Title#</td>
				<td>#Request.DealCategories.DateCreated#</td>
				<td>#Request.DealCategories.Status#</td>
				<td class="functions"><a>Edit</a> | <a>Delete</a></td>      
			</tr>
		</cfoutput>
		</tbody>                    
	</table>
<cfelse>
	<p style="margin-left:10px;">There were no deal categories found.</p>
</cfif>

<cfoutput>#Request.GridPagination#</cfoutput>