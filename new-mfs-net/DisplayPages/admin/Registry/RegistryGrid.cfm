<cfparam name="request.Registry" default="" />

<cfif request.Registry.recordcount GT 0>
	<h2 class="sectionTitle">Registry</h2>
	<table class="existingItemsTable" width="100%" cellspacing="0" cellpadding="0">
		<thead>
			<tr>
				<th class="left" sidx="BillFirstName">First Name</th>
				<th class="left" sidx="BillLastName">Last Name</th>
				<th sidx="registry_code">Registry Code</th>
				<th sidx="Create_Date">Date Created</th>
				<th sidx="Event_Date">Event Date</th>
				<th>Functions</th>
			</tr>
		</thead>
		<tbody>
		<cfoutput query="request.Registry">
			<tr rowid="#request.Registry.RegistryID#">
				<td class="left">#request.Registry.BillFirstName#</td>
				<td class="left">#request.Registry.BillLastName#</td>
				<td class="left">#request.Registry.registry_code#</td>
				<td>#DateFormat(request.Registry.Create_Date, 'mm/dd/yyyy')#</td>
				<td>#DateFormat(request.Registry.Event_Date, 'mm/dd/yyyy')#</td>
				<td class="functions"><a>Edit</a> | <a>Delete</a></td>      
			</tr>
		</cfoutput>
		</tbody>                    
	</table>
<cfelse>
	<p style="margin-left:10px;">There were no Registries found.</p>
</cfif>

<cfoutput>#Request.GridPagination#</cfoutput>