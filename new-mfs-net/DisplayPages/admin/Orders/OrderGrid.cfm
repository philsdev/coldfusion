<cfparam name="request.Orders" default="" />

<cfif request.Orders.recordcount GT 0>
	<h2 class="sectionTitle">Orders</h2>
	<table class="existingItemsTable" width="100%" cellspacing="0" cellpadding="0">
		<thead>
			<tr>
				<th class="left" sidx="orderid">Order ID</th>
				<th class="left" sidx="billingfirstname">Billing First Name</th>
				<th class="left" sidx="billinglastname">Billing Last Name</th>
				<th sidx="orderitems">Items</th>
				<th sidx="ordertotal">Total Cost</th>
				<th sidx="dateordered">Date Ordered</th>
				<th sidx="orderstatus">Status</th>
				<th>Functions</th>
			</tr>
		</thead>
		<tbody>
		<cfoutput query="request.Orders" group="OrderID">
			<tr rowid="#request.Orders.OrderID#">
				<td class="left">#request.Orders.OrderID#</td>
				<td class="left">#request.Orders.BillFirstName#</td>
				<td class="left">#request.Orders.BillLastName#</td>
				<td>#request.Orders.TotalItems#</td>
				<td>#DollarFormat(request.Orders.OrderTotal)#</td>
				<td>#request.Orders.DateOrdered#</td>
				<td>#request.Orders.OrderStatus#</td>
				<td class="functions"><a>Edit</a> | <a>Delete</a></td>      
			</tr>
		</cfoutput>
		</tbody>                    
	</table>
<cfelse>
	<p style="margin-left:10px;">There were no orders found.</p>
</cfif>

<cfoutput>#Request.GridPagination#</cfoutput>