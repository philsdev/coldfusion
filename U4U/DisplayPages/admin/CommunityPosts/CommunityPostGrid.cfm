<cfif Request.CommunityPost.recordcount GT 0>
	<h2 class="sectionTitle">Community Posts</h2>
	<table class="existingItemsTable" width="100%" cellspacing="0" cellpadding="0">
		<thead>
			<tr>
				<th sidx="title">Description</th>
				<th sidx="community">Community</th>
				<th sidx="user">User</th>	
				<th sidx="datecreated">Date Created</th>
				<th sidx="status">Status</th>
				<th>Functions</th>
			</tr>
		</thead>
		<tbody>
		<cfoutput query="Request.CommunityPost">
			<tr rowid="#Request.CommunityPost.ID#">
				<td>#Request.CommunityPost.Title#</td>
				<td>#Request.CommunityPost.Community#</td>
				<td>#Request.CommunityPost.Username#</td>
				<td>#Request.CommunityPost.DateCreated#</td>
				<td>#Request.CommunityPost.Status#</td>
				<td class="functions"><a>Edit</a> | <a>Delete</a></td>      
			</tr>
		</cfoutput>
		</tbody>                    
	</table>
<cfelse>
	<p style="margin-left:10px;">There were no community posts found.</p>
</cfif>

<cfoutput>#Request.GridPagination#</cfoutput>