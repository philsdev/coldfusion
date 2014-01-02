<cfif Request.Accounts.recordcount GT 0>
	<h2 class="sectionTitle">Accounts</h2>
	<table class="existingItemsTable" width="100%" cellspacing="0" cellpadding="0">
		<thead>
			<tr>
				<th sidx="firstname">First Name</th>
				<th sidx="lastname">Last Name</th>
				<th sidx="username">Username</th>
				<th sidx="email">E-mail Address</th>
				<th sidx="school">School</th>
				<th sidx="city">City</th>
				<th sidx="state">State</th>
				<th sidx="datecreated">Date Created</th>
				<th sidx="status">Status</th>
				<th>Functions</th>
			</tr>
		</thead>
		<tbody>
		<cfoutput query="Request.Accounts">
			<tr rowid="#Request.Accounts.ID#">
				<td>#Request.Accounts.FirstName#</td>
				<td>#Request.Accounts.LastName#</td>
				<td>#Request.Accounts.Username#</td>
				<td>#Request.Accounts.Email#</td>
				<td>#Request.Accounts.School#</td>
				<td>#Request.Accounts.City#</td>
				<td>#Request.Accounts.State#</td>
				<td>#Request.Accounts.DateCreated#</td>
				<td>#Request.Accounts.Status#</td>
				<td class="functions"><a>Edit</a> | <a>Delete</a></td>      
			</tr>
		</cfoutput>
		</tbody>                    
	</table>
<cfelse>
	<p style="margin-left:10px;">There were no accounts found.</p>
</cfif>

<cfoutput>#Request.GridPagination#</cfoutput>