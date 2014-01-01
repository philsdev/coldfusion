<cfscript>
	variables.LinkManager = Request.ListenerManager.GetListener( "LinkManager" );
</cfscript>
	
<cfparam name="request.Corporate" default="" />

<cfif request.Corporate.recordcount GT 0>
	<h2 class="sectionTitle">Corporate Accounts</h2>
	<table class="existingItemsTable" width="100%" cellspacing="0" cellpadding="0">
		<thead>
			<tr>
				<th class="left" sidx="Company">Company Name</th>
				<th class="left" sidx="FirstName">First Name</th>
				<th class="left" sidx="LastName">Last Name</th>
				<th sidx="Status">Status</th>
				<th>Functions</th>
			</tr>
		</thead>
		<tbody>
		<cfoutput query="request.Corporate">
			<tr rowid="#request.Corporate.DealerID#">
				<td class="left">#variables.LinkManager.GetDisplayName( request.Corporate.Company )#</td>
				<td class="left">#request.Corporate.FirstName#</td>
				<td class="left">#request.Corporate.LastName#</td>
				<td>#request.Corporate.Status#</td>
				<td class="functions"><a>Edit</a> | <a>Delete</a></td>      
			</tr>
		</cfoutput>
		</tbody>                    
	</table>
<cfelse>
	<p style="margin-left:10px;">There were no Corporate Accounts found.</p>
</cfif>

<cfoutput>#Request.GridPagination#</cfoutput>