<cfif Request.StudyGroupPost.recordcount GT 0>
	<h2 class="sectionTitle">Study Group Posts</h2>
	<table class="existingItemsTable" width="100%" cellspacing="0" cellpadding="0">
		<thead>
			<tr>
				<th sidx="title">Description</th>
				<th sidx="studygroup">Study Group</th>
				<th sidx="course">Course</th>
				<th sidx="school">School</th>
				<th sidx="user">User</th>	
				<th sidx="datecreated">Date Created</th>
				<th sidx="status">Status</th>
				<th>Functions</th>
			</tr>
		</thead>
		<tbody>
		<cfoutput query="Request.StudyGroupPost">
			<tr rowid="#Request.StudyGroupPost.ID#">
				<td>#Request.StudyGroupPost.Title#</td>
				<td>#Request.StudyGroupPost.StudyGroup#</td>
				<td>#Request.StudyGroupPost.Course#</td>
				<td>#Request.StudyGroupPost.School#</td>
				<td>#Request.StudyGroupPost.Username#</td>
				<td>#Request.StudyGroupPost.DateCreated#</td>
				<td>#Request.StudyGroupPost.Status#</td>
				<td class="functions"><a>Edit</a> | <a>Delete</a></td>      
			</tr>
		</cfoutput>
		</tbody>                    
	</table>
<cfelse>
	<p style="margin-left:10px;">There were no study group posts found.</p>
</cfif>

<cfoutput>#Request.GridPagination#</cfoutput>