<cfscript>
	variables.LinkManager = Request.ListenerManager.GetListener( "LinkManager" );
</cfscript>

<script type="text/javascript" src="/Javascript/OrderItems.js"></script>
							 
<div id="OrderItemsForm" class="inputForm">
	<form action="index.cfm?event=Admin.Order.Items.Submit" method="post" id="OrderItemsEditForm">
		<cfoutput>

		<input type="hidden" name="OrderID" id="OrderID" value="<cfif Request.OrderItems.OrderID GT 0>#Request.OrderItems.OrderID#<cfelse>0</cfif>" />
		<input type="hidden" name="ReturnUrl" id="ReturnUrl" value="" />
		<cfset variables.Subtotal = 0 />
		</cfoutput>
		<cfset variables.ItemCount = 0 />
		<cfoutput query="Request.OrderItems" group="OrderDetailsID">
		<input type="hidden" name="OrderDetailsID" id="OrderDetailsID" value="#Request.OrderItems.OrderDetailsID#" />
			<cfset variables.ItemCount = variables.ItemCount + 1 />
			<cfset variables.Subtotal = variables.Subtotal + request.OrderItems.TotalPrice />
			<h2 class="sectionTitle">
				<!--- #Request.OrderItems.CurrentRow# of #Request.OrderItems.RecordCount# )  --->
				#variables.ItemCount#)
				#variables.LinkManager.GetDisplayName( request.OrderItems.ProductName )#
			</h2>
			<ul class="form">				
				<li>
					<label>Product No:</label>
					#request.OrderItems.ProductItemNumber#&nbsp;
				</li>
				<li>
					<label>Vendor:</label>
					#request.OrderItems.VendorName#
				</li>
					<cfoutput>
					<li>
						<label>#request.OrderItems.OptionName#:</label>
						#request.OrderItems.OptionValue# <cfif request.OrderItems.Price NEQ 0>(#dollarformat(request.OrderItems.Price)#)</cfif> <cfif request.OrderItems.AddPrice NEQ 0>( + #dollarformat(request.OrderItems.AddPrice)#)</cfif>
					</li>
					</cfoutput>
				<li>
					<label>Shipping Status:</label>
					<select name="OrderStatusID_#OrderDetailsID#" id="OrderStatusID_#OrderDetailsID#">
						<cfloop query="request.OrderStatus">
							<option value="#request.OrderStatus.OrderStatusID#" <cfif Request.OrderItems.ShippingStatus EQ request.OrderStatus.OrderStatusID>selected="selected"</cfif> >#request.OrderStatus.OrderStatus#
						</cfloop>
					</select>
				</li>
				<li>
					<label>Tracking Number:</label>
					<input type="text" class="textinput" name="ShippingNumber_#OrderDetailsID#" id="ShippingNumber_#OrderDetailsID#" value="#request.OrderItems.ShippingNumber#" />
				</li>
				<li>
					<label>Shipping Date:</label>
					<input type="text" class="textinput datepicker" name="ShippingDate_#OrderDetailsID#" id="ShippingDate_#OrderDetailsID#" value="#request.OrderItems.ShippingDate#" />
				</li>
				<li>
					<label>Quantity:</label>
					#request.OrderItems.Quantity#
				</li>
				<li>
					<label>Unit Price:</label>
					#DollarFormat( request.OrderItems.ProductPrice )#
				</li>
				<li>
					<label>Total Cost:</label>
					#DollarFormat( request.OrderItems.TotalPrice )#
				</li>
			</ul>
		</cfoutput>
		<cfoutput>
		<cfif request.OrderItems.TaxCharge eq "">
			<cfset variable.TaxCharge = 0>
		<cfelse>
			<cfset variable.TaxCharge = request.OrderItems.TaxCharge>
		</cfif>
		
		<cfif request.OrderItems.ShippingCharge eq "">
			<cfset variable.ShippingCharge = 0>
		<cfelse>
			<cfset variable.ShippingCharge = request.OrderItems.ShippingCharge>
		</cfif>
		
		<cfif request.OrderItems.MiscCharge eq "">
			<cfset variable.MiscCharge = 0>
		<cfelse>
			<cfset variable.MiscCharge = request.OrderItems.MiscCharge>
		</cfif>

		<cfset variables.Total = variables.Subtotal + variable.TaxCharge + variable.ShippingCharge + variable.MiscCharge />

	<h2 class="sectionTitle">TOTALS</h2>
		<ul class="form">
			<li>
				<label>Subtotal:</label>
				#DollarFormat( variables.Subtotal )#
				<input type="hidden" name="Subtotal" id="Subtotal" value="#variables.Subtotal#" />
			</li>
			<li>
				<label>Sales Tax:</label>
				<input type="text" class="textinput price" name="TaxCharge" id="TaxCharge" value="#request.OrderItems.TaxCharge#" />
			</li>
			<li>
				<label>Shipping Charge:</label>
				<input type="text" class="textinput price" name="ShippingCharge" id="ShippingCharge" value="#request.OrderItems.ShippingCharge#" />
			</li>
			<li>
				<label>Misc Charge:</label>
				<input type="text" class="textinput price" name="MiscCharge" id="MiscCharge" value="#request.OrderItems.MiscCharge#" />
			</li>
			<li>
				<label>Promotion Code:</label>
				<cfif request.OrderItems.PromotionName NEQ "">
				#request.OrderItems.PromotionName#
				<cfelse>
				No Promotion used
				</cfif>
			</li>
			<li>
				<label>Promotion Discount:</label>
				<cfif request.OrderItems.DiscountPercent GT 0>
					#request.OrderItems.DiscountPercent# %
				<cfelseif request.OrderItems.DiscountAmount GT 0>
					#dollaramount(request.OrderItems.DiscountAmount)#
				<cfelse>
					No Promotion Discount
				</cfif>
			</li>
			<li>
				<label>Total Cost:</label>
				
				<input type="text" class="textinput price" name="TotalCharge" id="TotalCharge" value="#NumberFormat(variables.Total, '9.99')#" />
			</li>
		</ul>
			<span class="ButtonLinks">
				<a class="updateTotal">Update Total Cost</a>
			</span>
		
		#Request.SubmitButtons#
		</cfoutput>
	</form>
</div>