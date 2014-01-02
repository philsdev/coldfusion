<cfif Request.CommunityCategories.recordcount GT 0>
	<h2 class="sectionTitle">Community Categories</h2>
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
		<cfoutput query="Request.CommunityCategories">
			<tr rowid="#Request.CommunityCategories.ID#">
				<td>#Request.CommunityCategories.Title#</td>
				<td>#Request.CommunityCategories.DateCreated#</td>
				<td>#Request.CommunityCategories.Status#</td>
				<td class="functions"><a>Edit</a> | <a>Delete</a></td>      
			</tr>
		</cfoutput>
		</tbody>                    
	</table>
<cfelse>
	<p style="margin-left:10px;">There were no community categories found.</p>
</cfif>

<cfoutput>#Request.GridPagination#</cfoutput>