<cfif Request.Events.recordcount GT 0>
	<h2 class="sectionTitle">Events</h2>
	<table class="existingItemsTable" width="100%" cellspacing="0" cellpadding="0">
		<thead>
			<tr>
				<th sidx="title">Title</th>
				<th sidx="school">School</th>
				<th sidx="category">Category</th>
				<th sidx="organizer">Organizer</th>
				<th sidx="city">City</th>
				<th sidx="state">State</th>
				<th sidx="startdate">Start Date</th>
				<th sidx="enddate">End Date</th>				
				<th sidx="datecreated">Date Created</th>
				<th sidx="status">Status</th>
				<th>Functions</th>
			</tr>
		</thead>
		<tbody>
		<cfoutput query="Request.Events">
			<tr rowid="#Request.Events.ID#">
				<td>#Request.Events.Title#</td>
				<td>#Request.Events.School#</td>
				<td>#Request.Events.Category#</td>
				<td>#Request.Events.Organizer#</td>
				<td>#Request.Events.City#</td>
				<td>#Request.Events.State#</td>				
				<td>#Request.Events.StartDate#</td>
				<td>#Request.Events.EndDate#</td>
				<td>#Request.Events.DateCreated#</td>
				<td>#Request.Events.Status#</td>
				<td class="functions"><a>Edit</a> | <a>Delete</a></td>      
			</tr>
		</cfoutput>
		</tbody>                    
	</table>
<cfelse>
	<p style="margin-left:10px;">There were no events found.</p>
</cfif>

<cfoutput>#Request.GridPagination#</cfoutput>