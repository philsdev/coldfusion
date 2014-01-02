<cfif Request.Emails.recordcount GT 0>
	<h2 class="sectionTitle">E-mails</h2>
	<table class="existingItemsTable" width="100%" cellspacing="0" cellpadding="0">
		<thead>
			<tr>
				<th sidx="email">E-mail</th>
				<th sidx="datecreated">Date Created</th>
				<th sidx="status">Status</th>
				<th>Functions</th>
			</tr>
		</thead>
		<tbody>
		<cfoutput query="Request.Emails">
			<tr rowid="#Request.Emails.ID#">
				<td>#Request.Emails.Email#</td>
				<td>#Request.Emails.DateCreated#</td>
				<td>#Request.Emails.Status#</td>
				<td class="functions"><a>Edit</a> | <a>Delete</a></td>      
			</tr>
		</cfoutput>
		</tbody>                    
	</table>
<cfelse>
	<p style="margin-left:10px;">There were no e-mails found.</p>
</cfif>