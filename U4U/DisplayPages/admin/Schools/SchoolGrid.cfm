<cfif Request.Schools.recordcount GT 0>
	<h2 class="sectionTitle">Schools</h2>
	<table class="existingItemsTable" width="100%" cellspacing="0" cellpadding="0">
		<thead>
			<tr>
				<th sidx="title">Title</th>
				<th sidx="city">City</th>
				<th sidx="state">State</th>
				<th sidx="datecreated">Date Created</th>
				<th sidx="status">Status</th>
				<th>Functions</th>
			</tr>
		</thead>
		<tbody>
		<cfoutput query="Request.Schools">
			<tr rowid="#Request.Schools.ID#">
				<td>#Request.Schools.Title#</td>
				<td>#Request.Schools.City#</td>
				<td>#Request.Schools.State#</td>
				<td>#Request.Schools.DateCreated#</td>
				<td>#Request.Schools.Status#</td>
				<td class="functions"><a>Edit</a> | <a>Delete</a></td>      
			</tr>
		</cfoutput>
		</tbody>                    
	</table>
<cfelse>
	<p style="margin-left:10px;">There were no schools found.</p>
</cfif>

<cfoutput>#Request.GridPagination#</cfoutput>