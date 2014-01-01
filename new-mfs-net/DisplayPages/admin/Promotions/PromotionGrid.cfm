<cfparam name="request.Promotions" default="" />

<cfif request.Promotions.recordcount GT 0>
	<h2 class="sectionTitle">Promotions</h2>
	<table class="existingItemsTable" width="100%" cellspacing="0" cellpadding="0">
		<thead>
			<tr>
				<th class="left" sidx="promotionname">Promo Name</th>
				<th sidx="promotioncode">Promo Code</th>
				<th sidx="startdate">Start Date</th>
				<th sidx="enddate">End Date</th>
				<th sidx="ordercount">Orders</th>
				<th sidx="status">Status</th>
				<th>Functions</th>
			</tr>
		</thead>
		<tbody>
		<cfoutput query="request.Promotions">
			<tr rowid="#request.Promotions.PromotionID#">
				<td class="left">#request.Promotions.PromotionName#</td>
				<td>#request.Promotions.PromotionCode#</td>
				<td>#request.Promotions.StartDate#</td>
				<td>#request.Promotions.EndDate#</td>
				<td>#NumberFormat(request.Promotions.OrderCount)#</td>
				<td>#request.Promotions.Status#</td>
				<td class="functions"><a>Edit</a> | <a>Delete</a></td>      
			</tr>
		</cfoutput>
		</tbody>                    
	</table>
<cfelse>
	<p style="margin-left:10px;">There were no promotions found.</p>
</cfif>

<cfoutput>#Request.GridPagination#</cfoutput>