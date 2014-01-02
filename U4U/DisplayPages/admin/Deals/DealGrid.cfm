<cfif Request.Deals.recordcount GT 0>
	<h2 class="sectionTitle">Deals</h2>
	<table class="existingItemsTable" width="100%" cellspacing="0" cellpadding="0">
		<thead>
			<tr>
				<th sidx="title">Title</th>
				<th sidx="category">Category</th>
				<th sidx="costperclick">PPC</th>
				<th sidx="costperthousandimpressions">CPM</th>
				<th sidx="budget">Budget</th>
				<th sidx="budgetused">Budget Used</th>
				<th sidx="startdate">Start Date</th>
				<th sidx="enddate">End Date</th>
				<th sidx="datecreated">Date Created</th>
				<th sidx="status">Status</th>
				<th>Functions</th>
			</tr>
		</thead>
		<tbody>
		<cfoutput query="Request.Deals">
			<tr rowid="#Request.Deals.ID#">
				<td>#Request.Deals.Title#</td>
				<td>#Request.Deals.Category#</td>
				<td>#DollarFormat(Request.Deals.CostPerClick)#</td>
				<td>#DollarFormat(Request.Deals.CostPerThousandImpressions)#</td>
				<td>#DollarFormat(Request.Deals.Budget)#</td>
				<td>#DollarFormat(Request.Deals.BudgetUsed)#</td>
				<td>#Request.Deals.StartDate#</td>
				<td>#Request.Deals.EndDate#</td>
				<td>#Request.Deals.DateCreated#</td>
				<td>#Request.Deals.Status#</td>
				<td class="functions"><a>Edit</a> | <a>Delete</a></td>      
			</tr>
		</cfoutput>
		</tbody>                    
	</table>
<cfelse>
	<p style="margin-left:10px;">There were no deals found.</p>
</cfif>