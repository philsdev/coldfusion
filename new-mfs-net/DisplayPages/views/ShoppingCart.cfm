<div id="breadcrumb">
	<a href="/">Home</a><span>Shopping Cart</span>
</div>

<!--- contentContainer nessesary for liquid layouts with static and percentage columns --->
<div id="contentContainer" class="fullPage">
	<div id="content" class="contentSection">		
		
		<cfif ArrayLen(Request.CartItems)>
		
			<ul id="shoppingCartNav">
				<li class="active stepOne">STEP 1: Shopping Cart</li>
				<li class="inactive divider">STEP 2: Contact Information</li>
				<li class="inactive divider">STEP 3: Review Your Order</li>
				<li class="inactive divider">STEP 4: Order Confirmation</li>
			</ul>
			
			<!--- <p class="message alert cb">This is where a message goes!</p> --->
		
			<div id="ShoppingCart">			
				<table cellpadding="0" cellspacing="0" border="0" summary="Shopping Cart">
					<thead>
						<tr>
							<th class="h_ItemImage">&nbsp;</th>
							<th align="left" class="h_ItemDesription">Item Description</th>
							<th align="center" class="h_ItemPrice">Price</th>
							<th align="center" class="h_ItemQuantity">Quantity </th>
							<th align="center" class="h_ItemTotal">Total</th>
						</tr>
					</thead>
					<tbody>
						<cfloop from="1" to="#ArrayLen(Request.CartItems)#" index="variables.CartIndex">	
							<cfset variables.ThisItem = Request.CartItems[variables.CartIndex] />
							<cfoutput>
							<tr>
								<td rowspan="2" class="ItemImage">
									<img src="#variables.ThisItem.ProductImage#" border="0" style="display:inline; margin:0; padding:0; height:auto;">
								</td>
								<td align="left" class="ItemDescription">
									<a href="#variables.ThisItem.ProductLink#" class="bold">#variables.ThisItem.ProductName#</a>
									<cfif ArrayLen( variables.ThisItem.ProductOptions )>
										<br />
										<ul>
											<cfloop from="1" to="#ArrayLen(variables.ThisItem.ProductOptions)#" index="variables.ThisItemIndex">
												<cfset variables.ThisOption = variables.ThisItem.ProductOptions[variables.ThisItemIndex] />
												<li>
													#variables.ThisOption.AttributeName#: [#variables.ThisOption.OptionName#]
													<cfif variables.ThisOption.OptionPrice GT 0>
														[#DollarFormat( variables.ThisOption.OptionPrice )#]
													<cfelseif variables.ThisOption.OptionAddPrice GT 0>
														[+ #DollarFormat( variables.ThisOption.OptionAddPrice )#]
													</cfif>
												</li>
											</cfloop>
										</ul>
									</cfif>
									<cfif StructKeyExists( variables.ThisItem, "ProductPersonalization" ) AND variables.ThisItem.ProductPersonalization.TotalCharge GT 0>
										<cfset variables.PersonalizationList = "" />
										
										<cfloop collection="#variables.ThisItem.ProductPersonalization.Options#" item="variables.ThisPersonalizationOption">
											<cfset variables.PersonalizationList = ListAppend( variables.PersonalizationList, REQUEST.Personalization[variables.ThisPersonalizationOption].Title ) />
										</cfloop>
										
										<ul>
											<li>
												Personalization: #variables.PersonalizationList#
												[+ #DollarFormat( variables.ThisItem.ProductPersonalization.TotalCharge )#]
											</li>											
										</ul>
									</cfif>
								</td>
								<td rowspan="2" align="center" class="ItemPrice">#DollarFormat(variables.ThisItem.ProductPrice)#</td>
								<td rowspan="2" align="center" class="ItemQuantity">
									<form method="post" action="/adjust-item-quantity-in-shopping-cart.html">
										<input type="hidden" name="ProductID" value="#variables.ThisItem.ProductID#" />
										<input class="textInput qtyField" type="text" name="Quantity" value="#variables.ThisItem.ProductQuantity#"><br />
										<a class="UpdateItem">Update</a>
									</form>
								</td>
								<td rowspan="2" align="center" class="ItemTotal">#DollarFormat(variables.ThisItem.ProductSubtotal)#<!--- TODO: adjust this ---></td>
							</tr>
							<tr>
								<td align="left" valign="bottom">
									<form method="post" action="/remove-item-from-shopping-cart.html">
										<input type="hidden" name="ProductID" value="#variables.ThisItem.ProductID#" />
										<a class="RemoveItem">Remove Item</a>
									</form>
								</td>
							</tr>
							</cfoutput>
						</cfloop>
					</tbody>
				</table>
				</form>
			</div>

			<div id="shoppingCartPromos">
				<!--- PROMO SLOT 6 --->
				<div id="promoSlot6" class="promo">
					<img src="images/free-shipping-promotion-460.jpg" />
				</div>
				<a href="" class="button fl mt10" > Continue Shopping </a>
			</div>
			
			<div id="TotalsContainer">
				<ul id="Totals">
					<li id="OrderSubTotal">Order Sub Total: <cfoutput>#DollarFormat(request.CartTotals.ItemTotal)#</cfoutput></li>
					<li id="Promo" style="border:none;">
						<form class="mp0" name="PromoCodeForm" id="PromoCodeForm" onsubmit="return false;">
							<label><strong>Enter Promotional Code:</strong></label>
							<input class="nameField textInput" style="margin:6px 5px 0 0; height:16px;" id="PromoCode" maxlength="50" name="PromoCode" type="text" title="Promotional Code" />
							<div class="buttonLeft">
								<input type="button" class="button  grayButton" value="Apply Code" />
							</div>
						</form>
					</li>
					<li id="ShipValueNotFound" style="display:none; border-bottom:1px solid #CCC;"></li>
					<li id="PromoCodeNotFound" style="display:none"></li>
					<li id="PromoCodeFound" style="display: none; "></li>
					<li id="OrderTotal">Order Total: <cfoutput>#DollarFormat(request.CartTotals.OrderTotal)#</cfoutput></li>
				</ul>
			</div>
			
			<div id="checkoutBtnContainer">
				<cfif IsDefined("SESSION.User.LoggedIN") and Session.User.LoggedIN eq "1">	
					<cfset variables.FormAction = "/checkout.html" />
				<cfelse>
					<cfset variables.FormAction = "/shopping-cart-proceed.html" />
				</cfif>
				<form name="CheckoutForm" id="CheckoutForm" action="" method="post">
					<input id="BeginCheckoutSubmit" type="submit" name="submit" value="" />
				</form>
			</div>
			
		<cfelse>
		
			<p class="message alert cb">Your shopping cart is empty!</p>
		
		</cfif>
	</div>
</div>