<cfif Request.Courses.recordcount GT 0>
	<h2 class="sectionTitle">Courses</h2>
	<table class="existingItemsTable" width="100%" cellspacing="0" cellpadding="0">
		<thead>
			<tr>
				<th sidx="title">Title</th>
				<th sidx="type">School</th>
				<th sidx="datecreated">Date Created</th>
				<th sidx="status">Status</th>
				<th>Functions</th>
			</tr>
		</thead>
		<tbody>
		<cfoutput query="Request.Courses">
			<tr rowid="#Request.Courses.ID#">
				<td>#Request.Courses.Title#</td>
				<td>#Request.Courses.School#</td>
				<td>#Request.Courses.DateCreated#</td>
				<td>#Request.Courses.Status#</td>
				<td class="functions"><a>Edit</a> | <a>Delete</a></td>      
			</tr>
		</cfoutput>
		</tbody>                    
	</table>
<cfelse>
	<p style="margin-left:10px;">There were no courses found.</p>
</cfif>


<cfoutput>#Request.GridPagination#</cfoutput>