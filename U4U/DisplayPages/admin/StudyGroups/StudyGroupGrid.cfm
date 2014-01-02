<cfif Request.StudyGroup.recordcount GT 0>
	<h2 class="sectionTitle">Study Group</h2>
	<table class="existingItemsTable" width="100%" cellspacing="0" cellpadding="0">
		<thead>
			<tr>
				<th sidx="title">Title</th>
				<th sidx="course">Course</th>
				<th sidx="school">School</th>
				<th sidx="username">Username</th>	
				<th sidx="posts">Posts</th>
				<th sidx="datecreated">Date Created</th>
				<th sidx="status">Status</th>
				<th>Functions</th>
			</tr>
		</thead>
		<tbody>
		<cfoutput query="Request.StudyGroup">
			<tr rowid="#Request.StudyGroup.ID#">
				<td>#Request.StudyGroup.Title#</td>
				<td>#Request.StudyGroup.Course#</td>
				<td>#Request.StudyGroup.School#</td>
				<td>#Request.StudyGroup.Username#</td>
				<td>#NumberFormat(Request.StudyGroup.Posts)#</td>
				<td>#Request.StudyGroup.DateCreated#</td>
				<td>#Request.StudyGroup.Status#</td>
				<td class="functions"><a>Edit</a> | <a>Delete</a></td>      
			</tr>
		</cfoutput>
		</tbody>                    
	</table>
<cfelse>
	<p style="margin-left:10px;">There were no study groups found.</p>
</cfif>

<cfoutput>#Request.GridPagination#</cfoutput>