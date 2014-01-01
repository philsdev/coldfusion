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
	<cfif request.OrderDetails.recordcount neq 0>
		<h1>Order Details</h1>
		
		<div class="formContainer checkoutForm">
		
		<cfoutput query="request.OrderDetails">
		<h3>Order Information</h3>
		<ul class="form vhh tar">
			<li>
				<label>Order ##:</label>
				#request.OrderDetails.OrderID#
			</li>
			<li>
				<label>Date Ordered:</label>
				#dateFormat(request.OrderDetails.DateOrdered, "full")# @ #timeFormat(request.OrderDetails.DateOrdered, "medium")#
			</li>
			<li>
				<label>Order Total:</label>
				#dollarformat(request.OrderDetails.OrderTotal)#
			</li>
			<li>
				<label>Notes:</label>
				#request.OrderDetails.OrderNotes#
			</li>
			<li>
				<label>Customer Comments:</label>
				#request.OrderDetails.CustomerComments#
			</li>
			<li>
				<label>PayFlowPro Comments:</label>
				#request.OrderDetails.PayFlowProComments#
			</li>
			<li>
				<label>Shipping Carrier:</label>
				#request.OrderDetails.ShippingCarrier#
			</li>
			<li>
				<label>Shipping Method:</label>
				#request.OrderDetails.ShippingMethod#
			</li>
		</ul>
		</cfoutput>

		<table width="100%">
		<tr><td>
		<cfoutput query="request.OrderShipping">
		<h3>Shipping Information</h3>
		<p>	 	#request.OrderShipping.ShipCompany#<br />
				#request.OrderShipping.ShipFirstName# #request.OrderShipping.ShipLastName#<br />
				#request.OrderShipping.ShipAddress#<br />
				<cfif request.OrderShipping.ShipAddress2 NEQ "">#request.OrderShipping.ShipAddress2#<br /></cfif>
				#request.OrderShipping.ShipCity#, #request.OrderShipping.ShipState# #request.OrderShipping.ShipProvince# #request.OrderShipping.ShipZipCode#<br />
				#request.OrderShipping.ShipCountry#<br />
				#request.OrderShipping.ShipPhoneNumber# <cfif request.OrderShipping.ShipPhoneExt NEQ "">Ext: #request.OrderShipping.ShipPhoneExt# </cfif><br /> 
				<cfif request.OrderShipping.ShipAltNumber NEQ "">#request.OrderShipping.ShipAltNumber# <cfif request.OrderShipping.ShipAltExt NEQ "">Ext: #request.OrderShipping.ShipAltExt#</cfif> <br /> </cfif>
				#request.OrderShipping.ShipEmailAddress# 
			</p>
		</cfoutput>
		</td>		
		<td>
		<cfoutput query="request.OrderBilling">
		<h3>Billing Information</h3>
		<p>	 	#request.OrderBilling.BillCompany#<br />
				#request.OrderBilling.BillFirstName# #request.OrderBilling.BillLastName#<br />
				#request.OrderBilling.BillAddress#<br />
				<cfif request.OrderBilling.BillAddress2 NEQ "">#request.OrderBilling.BillAddress2#<br /></cfif>
				#request.OrderBilling.BillCity#, #request.OrderBilling.BillState# #request.OrderBilling.BillProvince# #request.OrderBilling.BillZipCode#<br />
				#request.OrderBilling.BillCountry#<br />
				#request.OrderBilling.BillPhoneNumber# <cfif request.OrderBilling.BillPhoneExt NEQ "">Ext: #request.OrderBilling.BillPhoneExt# </cfif><br /> 
				<cfif request.OrderBilling.BillAltNumber NEQ "">#request.OrderBilling.BillAltNumber# <cfif request.OrderBilling.BillAltExt NEQ "">Ext: #request.OrderBilling.BillAltExt#</cfif> <br /> </cfif>
				#request.OrderBilling.BillEmailAddress# 
			</p>
		</cfoutput>
		</td>
		</tr>	
		</table>
		
		<table width="100%">
		<tr><th>Item</th><th>Quantity</th><th>Item Price</th></tr>	
		<cfoutput query="request.OrderItems" group="OrderDetailsID">
		<cfoutput>
		<tr><td>#ProductName#: #OptionName#
		<br />Shipping Status: #OrderStatus#
		<br />Shipped Date: #dateFormat(ShippingDate, "mm/dd/yyyy")# 
		<br />Tracking Number: #ShippingNumber#
		</td>
		<td>#Quantity#</td>
		<td>#ProductPrice#</td>
		<td>
			<form method="post" action="/add-item-to-shopping-cart.html">
				<input type="hidden" name="ProductID" value="#ProductID#" />
				<input type="hidden" name="ProductQuantity" value="#Quantity#"><br />
				<a class="ReorderItem">Re-order Item</a>
			</form>
		</td>
		</tr>	
		</tr>
		</cfoutput>

		<tr><td>&nbsp;</td><td>&nbsp;</td>
		<td colspan="2">
		<ul class="form vhh tar">
			<li><label>Shipping Charge:</label> #dollarformat(ShippingCharge)#</li>
			<li><label>Sales Tax:</label> #dollarformat(TaxCharge)#</li>
			<li><label>Misc Charge:</label> <cfif MiscCharge eq "">#dollarformat(0)#<cfelse>#dollarformat(MiscCharge)#</cfif></li>
			<li><label>Promotion Discount:</label><cfif DiscountTotal neq "">- #dollarformat(DiscountTotal)#</cfif></li>
			<li><label>Total:</label> #dollarformat(TotalPrice)#</li>
		</ul>
		</td></tr>	
		</cfoutput>
		</table>
		</div>
		
	<cfelse>
		<p>There are no current orders at this time.</p>
	</cfif>
</div>
<cfelse>
	<p>This page is not available to you.  Please login to see you account information.
</cfif>	
</div>

