<cfif Request.Communities.recordcount GT 0>
	<h2 class="sectionTitle">Communities</h2>
	<table class="existingItemsTable" width="100%" cellspacing="0" cellpadding="0">
		<thead>
			<tr>
				<th sidx="title">Title</th>
				<th sidx="category">Category</th>
				<th sidx="username">Username</th>
				<th sidx="posts">Posts</th>
				<th sidx="datecreated">Date Created</th>
				<th sidx="status">Status</th>
				<th>Functions</th>
			</tr>
		</thead>
		<tbody>
		<cfoutput query="Request.Communities">
			<tr rowid="#Request.Communities.ID#">
				<td>#Request.Communities.Title#</td>
				<td>#Request.Communities.Category#</td>
				<td>#Request.Communities.Username#</td>
				<td>#NumberFormat(Request.Communities.Posts)#</td>
				<td>#Request.Communities.DateCreated#</td>
				<td>#Request.Communities.Status#</td>
				<td class="functions"><a>Edit</a> | <a>Delete</a></td>      
			</tr>
		</cfoutput>
		</tbody>                    
	</table>
<cfelse>
	<p style="margin-left:10px;">There were no communities found.</p>
</cfif>

<cfoutput>#Request.GridPagination#</cfoutput>