<cfparam name="request.Customer" default="" />

<cfif request.Customer.recordcount GT 0>
	<h2 class="sectionTitle">Customer Accounts</h2>
	<table class="existingItemsTable" width="100%" cellspacing="0" cellpadding="0">
		<thead>
			<tr>
				<th class="left" sidx="BillFirstName">Bill First Name</th>
				<th class="left" sidx="BillLastName">Bill Last Name</th>
				<th sidx="EmailAddress">EmailAddress</th>
				<th sidx="Status">Status</th>
				<th>Functions</th>
			</tr>
		</thead>
		<tbody>
		<cfoutput query="request.Customer">
			<tr rowid="#request.Customer.AccountID#">
				<td class="left">#request.Customer.FirstName#</td>
				<td class="left">#request.Customer.LastName#</td>
				<td>#request.Customer.EmailAddress#</td>
				<td><cfif request.Customer.Status eq 1>Active<cfelse>Inactive</cfif></td>
				<td class="functions"><a>Edit</a> | <a>Delete</a></td>      
			</tr>
		</cfoutput>
		</tbody>                    
	</table>
<cfelse>
	<p style="margin-left:10px;">There were no Customer Accounts found.</p>
</cfif>

<cfoutput>#Request.GridPagination#</cfoutput>