<cfparam name="request.Admins" default="" />

<cfif request.Admins.recordcount GT 0>
	<h2 class="sectionTitle">Admins</h2>
	<table class="existingItemsTable" width="100%" cellspacing="0" cellpadding="0">
		<thead>
			<tr>
				<th align="left" sidx="firstname">First Name</th>
				<th align="left" sidx="lastname">Last Name</th>
				<th align="center" sidx="datecreated">Date Created</th>
				<th align="center" sidx="status">Status</th>
				<th align="center" sidx="sectioncount">Permissions</th>
				<th align="center">Functions</th>
			</tr>
		</thead>
		<tbody>
		<cfoutput query="request.Admins">
			<tr rowid="#request.Admins.ID#">
				<td>#request.Admins.FirstName#</td>
				<td>#request.Admins.LastName#</td>
				<td align="center">#request.Admins.DateCreated#</td>
				<td align="center">#request.Admins.Status#</td>
				<td align="center">#request.Admins.SectionCount# / #request.Admins.SectionTotal#</td>
				<td align="center" class="functions"><a>Edit</a> | <a>Delete</a></td>      
			</tr>
		</cfoutput>
		</tbody>                    
	</table>
<cfelse>
	<p style="margin-left:10px;">There were no administrators found.</p>
</cfif>

<cfoutput>#Request.GridPagination#</cfoutput>