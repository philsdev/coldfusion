<cfif Request.Jobs.recordcount GT 0>
	<h2 class="sectionTitle">Jobs</h2>
	<table class="existingItemsTable" width="100%" cellspacing="0" cellpadding="0">
		<thead>
			<tr>
				<th sidx="title">Title</th>
				<th sidx="type">Type</th>
				<th sidx="companyname">Company Name</th>
				<th sidx="contactname">Contact Name</th>
				<th sidx="replyemail">Reply E-mail</th>
				<th sidx="datecreated">Date Created</th>
				<th sidx="status">Status</th>
				<th>Functions</th>
			</tr>
		</thead>
		<tbody>
		<cfoutput query="Request.Jobs">
			<tr rowid="#Request.Jobs.ID#">
				<td>#Request.Jobs.Title#</td>
				<td>#Request.Jobs.Category#</td>
				<td>#Request.Jobs.CompanyName#</td>
				<td>#Request.Jobs.ContactName#</td>
				<td>#Request.Jobs.ReplyEmail#</td>
				<td>#Request.Jobs.DateCreated#</td>
				<td>#Request.Jobs.Status#</td>
				<td class="functions"><a>Edit</a> | <a>Delete</a></td>      
			</tr>
		</cfoutput>
		</tbody>                    
	</table>
<cfelse>
	<p style="margin-left:10px;">There were no jobs found.</p>
</cfif>