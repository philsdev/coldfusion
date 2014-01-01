<cfscript>
	variables.LinkManager = Request.ListenerManager.GetListener( "LinkManager" );
</cfscript>
<!------------------------------------------------------------------------------------------

	TrackOrders.cfm
	track-orders.html
------------------------------------------------------------------------------------------->


<div id="breadcrumb">
	<a href="/" title="">Home</a>
	<span><a href="/my-account.html" title="">
	<cfif SESSION.User.UserType eq 1>
		Customer Account
	<cfelseif SESSION.User.UserType eq 2>
		Corporate Account
	</cfif></a>
	</span>
</div>
	
<!-- contentContainer nessesary for liquid layouts with static and percentage columns -->
<aside id="sidebar">
	<div class="sideModule navModule module">
		<h3>Module Title</h3>
		<div class="moduleContent">
			<p>Put sidebar content here.</p>
		</div>
	</div>	
</aside>

<cfif IsDefined("SESSION.User.LoggedIN") and SESSION.User.LoggedIN eq 1>

<div id="contentContainer">
	<div id="content" class="contentSection">
	<cfif request.Orders.recordcount neq 0>
		<h1>Order <cfif CurrentOrder eq 1>Tracking<cfelse>History</cfif></h1>
		<table class="existingItemsTable" width="100%" cellspacing="0" cellpadding="0">
		<thead>
			<tr>
				<th>Order #</th>
				<th>Date Ordered</th>
				<th>Order Total</th>
				<th>Items Ordered</th>
				<th>Functions</th>
			</tr>
		</thead>
		<tbody>
		<p><cfoutput query="request.Orders" group="OrderID">
		<tr rowid="#request.Orders.OrderID#">
			<td>#request.Orders.OrderID#</td>
			<td>#dateFormat(request.Orders.DateOrdered, "mm/dd/yyyy")#</td>
			<td>#dollarformat(request.Orders.OrderTotal)#</td>
			<td><cfoutput>
				<p>#request.Orders.ProductName#
				<br />Date Shipped: #dateFormat(request.Orders.ShippingDate, "mm/dd/yyyy")#</p>
				</cfoutput>
			</td>
			<td>
				<form method="post" action="/track-orders-details.html">
					<input type="hidden" name="OrderID" value="#request.Orders.OrderID#" />
					<a class="ViewOrder">View Order</a>
				</form>
			</td>
		</tr>
		</cfoutput>
		</table>
	<cfelse>
		<p>There are no current orders at this time.</p>
	</cfif>
</div>
<cfelse>
	<p>This page is not available to you.  Please login to see you account information.
</cfif>	
</div>

