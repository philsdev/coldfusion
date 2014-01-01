<div id="breadcrumb">
	<a href="/">Home</a><span>Review Order</span>
</div>

<!--- contentContainer nessesary for liquid layouts with static and percentage columns --->
<div id="contentContainer" class="fullPage">
	<div id="content" class="contentSection">		
		
		<cfif ArrayLen(Request.CartItems)>
		
			<ul id="shoppingCartNav">
				<li class="inactive stepOne">STEP 1: Shopping Cart</li>
				<li class="inactive divider">STEP 2: Contact Information</li>
				<li class="active divider">STEP 3: Review Your Order</li>
				<li class="inactive divider">STEP 4: Order Confirmation</li>
			</ul>
			
			
		
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
									1
								</td>
								<td rowspan="2" align="center" class="ItemTotal">#DollarFormat(variables.ThisItem.ProductSubtotal)#<!--- TODO: adjust this ---></td>
							</tr>
							<tr>
								<td align="left" valign="bottom">
									&nbsp;
								</td>
							</tr>
							</cfoutput>
						</cfloop>
					</tbody>
				</table>
				
			</div>

			
           <div id="shoppingCartPromos">
            
            <a href="" class="button fl mt10" > Edit Cart </a>
            
            </div>
            
			
			<div id="TotalsContainer">
				<ul id="Totals">
					<li id="OrderSubTotal">Order Sub Total: <cfoutput>#DollarFormat(request.CartTotals.ItemTotal)#</cfoutput></li>
					
					<li id="OrderTotal">Order Total: <cfoutput>#DollarFormat(request.CartTotals.OrderTotal)#</cfoutput></li>
				</ul>
			</div>
		
            
            
            <h2 class="cb">Shipping Information</h2>
            <div class="formContainer">
            <cfoutput>
            	<ul class="form">
                	<li>Shipping Method: Ground - $10.00</li>
					<cfif SESSION.Cart.ShippingInfo.Company NEQ "">
						<li>#SESSION.Cart.ShippingInfo.Company#</li>
					</cfif>
                    <li>#SESSION.Cart.ShippingInfo.FirstName# #SESSION.Cart.ShippingInfo.LastName#</li>
                    <li>#SESSION.Cart.ShippingInfo.Address# 
					<cfif SESSION.Cart.ShippingInfo.Address2 NEQ "">
						<br/>#SESSION.Cart.ShippingInfo.Address2#
					</cfif>
					<br/>#SESSION.Cart.ShippingInfo.City#, #SESSION.Cart.ShippingInfo.State# #SESSION.Cart.ShippingInfo.Province# #SESSION.Cart.ShippingInfo.ZipCode# 
					<br/>#SESSION.Cart.ShippingInfo.Country#</li>
					 <li>#SESSION.Cart.ShippingInfo.Email#</li>
					 <li>Phone Number: #SESSION.Cart.ShippingInfo.PhoneNumber#  <cfif SESSION.Cart.ShippingInfo.PhoneNumberExt NEQ "">Ext: #SESSION.Cart.ShippingInfo.PhoneNumberExt#</cfif></li>
					 <cfif SESSION.Cart.ShippingInfo.PhoneNumberAlt NEQ "">
					 <li>Alternate Phone Number: #SESSION.Cart.ShippingInfo.PhoneNumberAlt# <cfif SESSION.Cart.ShippingInfo.PhoneNumberAltExt NEQ "">Ext: #SESSION.Cart.ShippingInfo.PhoneNumberAltExt#</cfif></li>
					 </cfif>
                    <li><a href="/checkout.html" class="button grayButton">Edit Shipping Information</a></li>
                </ul>
            
            </div>
            
            <h2>Billing Information</h2>
            <div class="formContainer">
            
            	<ul class="form">
                	
                 <cfif SESSION.Cart.ShippingInfo.Company NEQ "">
						<li>#SESSION.Cart.BillingInfo.Company#</li>
					</cfif>
                    <li>#SESSION.Cart.BillingInfo.FirstName# #SESSION.Cart.BillingInfo.LastName#</li>
                    <li>#SESSION.Cart.BillingInfo.Address# 
					<cfif SESSION.Cart.BillingInfo.Address2 NEQ "">
						<br/>#SESSION.Cart.BillingInfo.Address2#
					</cfif>
					<br/>#SESSION.Cart.BillingInfo.City#, #SESSION.Cart.BillingInfo.State# #SESSION.Cart.BillingInfo.Province# #SESSION.Cart.BillingInfo.ZipCode# 
					<br/>#SESSION.Cart.BillingInfo.Country#</li>
					 <li>#SESSION.Cart.BillingInfo.Email#</li>
					 <li>Phone Number: #SESSION.Cart.BillingInfo.PhoneNumber#  <cfif SESSION.Cart.BillingInfo.PhoneNumberExt NEQ "">Ext: #SESSION.Cart.BillingInfo.PhoneNumberExt#</cfif></li>
					 <cfif SESSION.Cart.BillingInfo.PhoneNumberAlt NEQ "">
					 <li>Alternate Phone Number: #SESSION.Cart.BillingInfo.PhoneNumberAlt# <cfif SESSION.Cart.BillingInfo.PhoneNumberAltExt NEQ "">Ext: #SESSION.Cart.BillingInfo.PhoneNumberAltExt#</cfif></li>
					 </cfif>
                    <li><a href="" class="button grayButton">Edit Billing Information</a></li>
                </ul>
            
            </div>
			</cfoutput>
            <h2>Payment Information</h2>
            <div class="formContainer">
            
            	<ul class="form tar ccForm">              
						
					<li>
					  <label>Card Type:</label>
					  <select name="CardType" id="CardType" class="textInput cardTypeField">
						<option value="">- Select a Card Type -</option>
						<option value="American Express">American Express</option>
						<option value="Discover">Discover</option>
						<option value="Mastercard">Mastercard</option>
						<option value="Visa">Visa</option>
					  </select>&nbsp;
					</li>
					<li>
					  <label>Card Number:</label>
					  <input name="CardNumber" type="text" maxlength="19" class="textInput cardNumberField" id="CardNumber">&nbsp; (no spaces or dashes)</li>
					<li>
					  <label>Card Exp. Date:</label>
					  <select name="CardExpMonth" id="b_cardExpMonth" class="textInput cardExpMonthField">
						 <option value=""> - Month -</option>
						  
							<option value="01">01</option>
						  
							<option value="02">02</option>
						  
							<option value="03">03</option>
						  
							<option value="04">04</option>
						  
							<option value="05">05</option>
						  
							<option value="06">06</option>
						  
							<option value="07">07</option>
						  
							<option value="08">08</option>
						  
							<option value="09">09</option>
						  
							<option value="10">10</option>
						  
							<option value="11">11</option>
						  
							<option value="12">12</option>
						            
					  </select>
					  <select name="CardExpYear" id="b_cardExpYear" class="textInput cardExpYearField">
						  <option value=""> - Year -</option>
						  
							<option value="2011">2011</option>
						  
							<option value="2012">2012</option>
						  
							<option value="2013">2013</option>
						  
							<option value="2014">2014</option>
						  
							<option value="2015">2015</option>
						  
							<option value="2016">2016</option>
						  
							<option value="2017">2017</option>
						  
							<option value="2018">2018</option>
						  
							<option value="2019">2019</option>
						  
							<option value="2020">2020</option>
						  
					  </select>&nbsp; </li>
					<li>
					  <label>Card Security Code:</label>
					  <input name="CardSecCode" type="text" maxlength="4" class="textInput cardSecurityCodeField" id="CardSecCode">&nbsp;<a class="fancyLinkNoHeight" href="http://capitalcity.amp.com/DisplayPages/CCImage.cfm">Find Security Code</a> 
					  </li>
					  
					  
					
					</ul>
                    
                    <h3>Gift Cards:</h3>
            		
                    <ul class="form ccForm">
                    	<li class="inline"><label>E-GIFT Card Number</label><input type="text" /><input type="submit" class="button grayButton" value="Apply Gift Card" /></li>
                    </ul>
                    
                    <!--- IF THERE ARE GIFT CARDS APPLIED, SHOW THIS TABLE --->
                    <h4>Gift Cards Applied:</h4>
                    <table cellpadding="0" cellspacing="0" border="1" class="giftCardTableLayout" id="appliedGiftCards">
                    	
                        <tbody>
                    		<tr>
                            	<td>1847293483209</td><td align="center">$10.00</td><td align="center"><a href="" class="RemoveItem">Remove</a></td>
                                
                           </tr>
                           <tr>
                            	<td>1847293483209</td><td align="center">$10.00</td><td align="center"><a href="" class="RemoveItem">Remove</a></td>
                                
                           </tr>
                        </tbody>
                    </table>
                    
                    
            </div>
           
           <div id="priceSummary">
           	<ul >
            	<li>Order Subtotal: $100.00 </li>
                <li>Shipping &amp; Handling: $10.00</li>
                <li>Taxes: $10.00</li>
                <li class="adj">Coupon Code Adjustments: $-5.00 </li>
                <li class="adj">Gift Cards: -$20.00</li>
                <li><span class="total">Total (Charged to credit card): $95.00</span> </li>
                <li><input id="reviewOrder" type="submit" name="submit" value="" /></li>
            </ul>
            
            </div>
            
		<cfelse>
		
			<p class="message alert cb">Your shopping cart is empty!</p>
		
		</cfif>
	</div>
</div>