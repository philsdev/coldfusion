<cfif Request.Advertisements.recordcount GT 0>
	<h2 class="sectionTitle">Advertisement</h2>
	<table class="existingItemsTable" width="100%" cellspacing="0" cellpadding="0">
		<thead>
			<tr>
				<th sidx="title">Title</th>
				<th sidx="type">Type</th>
				<th sidx="size">Size</th>
				<th sidx="costperclick">PPC</th>
				<th sidx="costperthousandimpressions">CPM</th>
				<th sidx="budget">Budget</th>
				<th sidx="budgetused">Budget Used</th>
				<th sidx="billableimpressions">Bill Imp</th>
				<th sidx="nonbillableimpressions">Non-Bill Imp</th>
				<th sidx="billableclicks">Bill Clicks</th>
				<th sidx="nonbillableclicks">Non-Bill Clicks</th>
				<th sidx="ishouseadvertisement">House Ad?</th>
				<th sidx="username">Username</th>
				<th sidx="datecreated">Date Created</th>
				<th sidx="status">Status</th>
				<th>Functions</th>
			</tr>
		</thead>
		<tbody>
		<cfoutput query="Request.Advertisements">
			<tr rowid="#Request.Advertisements.ID#">
				<td>#Request.Advertisements.Title#</td>
				<td>#Request.Advertisements.Type#</td>
				<td>#Request.Advertisements.Size#</td>
				<td>#DollarFormat(Request.Advertisements.CostPerClick)#</td>
				<td>#DollarFormat(Request.Advertisements.CostPerThousandImpressions)#</td>
				<td>#DollarFormat(Request.Advertisements.Budget)#</td>
				<td>#DollarFormat(Request.Advertisements.BudgetUsed)#</td>
				<td>#NumberFormat(Request.Advertisements.BillableImpressions)#</td>
				<td>#NumberFormat(Request.Advertisements.NonBillableImpressions)#</td>
				<td>#NumberFormat(Request.Advertisements.BillableClicks)#</td>
				<td>#NumberFormat(Request.Advertisements.NonBillableClicks)#</td>
				<td>#YesNoFormat(Request.Advertisements.IsHouseAdvertisement)#</td>
				<td>#Request.Advertisements.Username#</td>
				<td>#Request.Advertisements.DateCreated#</td>
				<td>#Request.Advertisements.Status#</td>
				<td class="functions"><a>Edit</a> | <a>Delete</a></td>      
			</tr>
		</cfoutput>
		</tbody>                    
	</table>
<cfelse>
	<p style="margin-left:10px;">There were no advertisements found.</p>
</cfif>

<cfoutput>#Request.GridPagination#</cfoutput>