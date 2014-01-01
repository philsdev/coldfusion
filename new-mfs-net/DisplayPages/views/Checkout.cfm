<div id="contentContainer" class="fullPage">
	<div id="content" class="contentSection">
		<div id="main" class="fullWidth">
			<ul id="shoppingCartNav">
				<li class="inactive stepOne">STEP 1: Shopping Cart</li>
				<li class="active divider">STEP 2: Shipping and Billing</li>
				<li class="inactive divider">STEP 3: Review Your Order</li>
				<li class="inactive divider">STEP 4: Order Confirmation</li>
			</ul>
			
			<cfoutput>
	
			<form method="post" action="/checkout-submit.html" name="CheckoutForm" id="CheckoutForm">

				<h2 class="shoppingCartTitle"><span class="step">1</span> Shipping Information</h2>
				
				<div class="formContainer checkoutForm">
					<ul class="form vhh tar " id="ShippingFields">
						<li class="required">
							<label></label>
							Designates Required Fields
						</li>
						<li>
							<label>Company:</label>
							<input name="ShipCompany" id="ShipCompany" type="text" class="textInput nameField" value="#Request.ShippingInfo.Company#" />
						</li>
						<li class="required">
							<label>First Name:</label>
							<input name="ShipFirstName" id="ShipFirstName" type="text" class="textInput nameField" value="#Request.ShippingInfo.FirstName#" />
						</li>
						<li class="required">
							<label>Last Name:</label>
							<input name="ShipLastName" id="ShipLastName" type="text" class="textInput nameField" value="#Request.ShippingInfo.LastName#" />
						</li>
						<li class="required">
							<label>E-mail Address:</label>
							<input name="ShipEmail" id="ShipEmail" type="text" class="textInput emailField" value="#Request.ShippingInfo.Email#" />
						</li>
						<li class="required">
							<label>Address:</label>
							<input name="ShipAddress" id="ShipAddress" type="text" class="textInput addressField" value="#Request.ShippingInfo.Address#" />
						</li>
						<li>
							<label></label>
							<input name="ShipAddress2" id="ShipAddress2" type="text" class="textInput addressField" value="#Request.ShippingInfo.Address2#" />
						</li>
						<li class="required">
							<label>City:</label>
							<input name="ShipCity" id="ShipCity" type="text" maxlength="50" class="textInput cityField" value="#Request.ShippingInfo.City#" />
						</li>
						<li class="required">
							<label id="StateLabel">State:</label>
							#request.ShipStateBox#
						</li>
						<li class="required">
							<label>ZIP Code:</label>
							<input name="ShipZipCode" id="ShipZipCode" type="text" class="textInput zipField" value="#Request.ShippingInfo.ZipCode#" />
						</li>
						<li>
							<label>Province:</label>
							<input name="ShipProvince" id="ShipProvince" type="text" class="textInput" value="#Request.ShippingInfo.Province#" />
						</li>
						<li class="required">
							<label>Country:</label>
							#request.ShipCountryBox#
						</li>
						<li class="required">
							<label>Phone Number:</label>
							<input name="ShipPhoneNumber" id="ShipPhoneNumber" type="text" class="textInput phoneField" value="#Request.ShippingInfo.PhoneNumber#" />
							<cite>Ext:</cite>
							<input name="ShipPhoneNumberExt" id="ShipPhoneNumberExt" type="text" class="textInput phoneExtField" value="#Request.ShippingInfo.PhoneNumberExt#" />
						</li>
						<li>
							<label>Alt. Phone Number:</label>
							<input name="ShipPhoneNumberAlt" id="ShipPhoneNumberAlt" type="text" class="textInput phoneField" value="#Request.ShippingInfo.PhoneNumberAlt#" />
							<cite>Ext:</cite>
							<input name="ShipPhoneNumberAltExt" id="ShipPhoneNumberAltExt" type="text" class="textInput phoneExtField" value="#Request.ShippingInfo.PhoneNumberAltExt#" />
						</li>
					</ul>
				</div>

				<h2 class="shoppingCartTitle"><span class="step">2</span> Billing Information</h2>

				<input type="hidden" name="RequestAQuote" value="0">
				<div class="formContainer checkoutForm">
					<p class="mp0">
						<input type="checkbox" name="CopyShippingToBilling" id="CopyShippingToBilling" class="noStyle" />
						&nbsp;Billing Information is the same as Shipping
					</p>
					<p><strong>Note:</strong> For security purposes, your billing information must match your credit card information.</p>
					<ul class="form vhh tar" id="BillingFields">
						<li class="required">
							<label></label>
							Designates Required Fields
						</li>
						<li>
							<label>Company:</label>
							<input name="BillCompany" id="BillCompany" type="text" class="textInput nameField" value="#Request.BillingInfo.Company#" />
						</li>
						<li class="required">
							<label>First Name:</label>
							<input name="BillFirstName" id="BillFirstName" type="text" class="textInput nameField" value="#Request.BillingInfo.FirstName#" />
						</li>
						<li class="required">
							<label>Last Name:</label>
							<input name="BillLastName" id="BillLastName" type="text" class="textInput nameField" value="#Request.BillingInfo.LastName#" />
						</li>
						<li class="required">
							<label>Email Address:</label>
							<input name="BillEmail" id="BillEmail" type="text" class="textInput emailField" value="#Request.BillingInfo.Email#" />
						</li>
						<li class="required">
							<label>Address:</label>
							<input name="BillAddress" id="BillAddress" type="text" class="textInput addressField" value="#Request.BillingInfo.Address#" />
						</li>
						<li >
							<label></label>
							<input name="BillAddress2" id="BillAddress2" type="text"  class="textInput addressField" value="#Request.BillingInfo.Address2#" />
						</li>
						<li class="required">
							<label>City:</label>
							<input name="BillCity" id="BillCity" type="text" class="textInput cityField" value="#Request.BillingInfo.City#" />
						</li>
						<li class="required">
							<label id="BillLabel">State:</label>
							#request.BillStateBox#
						</li>
						<li class="required">
							<label>ZIP Code:</label>
							<input name="BillZipCode" id="BillZipCode" type="text" class="textInput zipField" value="#Request.BillingInfo.ZipCode#" />
						</li>
						<li>
							<label>Province:</label>
							<input name="BillProvince" id="BillProvince" type="text" class="textInput" value="#Request.BillingInfo.Province#" />
						</li>
						<li class="required">
							<label>Country:</label>
							#request.BillCountryBox#
						</li>
						<li class="required">
							<label>Phone Number:</label>
							<input name="BillPhoneNumber" id="BillPhoneNumber" type="text" class="textInput phoneField" value="#Request.BillingInfo.PhoneNumber#" />
							<cite>Ext:</cite>
							<input name="BillPhoneNumberExt" id="BillPhoneNumberExt" type="text" class="textInput phoneExtField" value="#Request.BillingInfo.PhoneNumberExt#" />
						</li>
						<li>
							<label>Alt. Phone Number:</label>
							<input name="BillPhoneNumberAlt" id="BillPhoneNumberAlt" type="text" class="textInput phoneField" value="#Request.BillingInfo.PhoneNumberAlt#" />
							<cite>Ext:</cite>
							<input name="BillPhoneNumberAltExt" id="BillPhoneNumberAltExt" type="text" class="textInput phoneExtField" value="#Request.BillingInfo.PhoneNumberAltExt#" />
						</li>
					</ul>
				</div>

				<h2 class="shoppingCartTitle"><span class="step">3</span>Register for an Account?</h2>
				<div class="formContainer checkoutForm">
					<div class="RegisterAccount">
						<ul class="form vhh tar" style="width:100%;">
							<li>
								<p>
									<input type="checkbox" name="RegisterAccount" value="1">
									&nbsp;Yes. Please register me for an account.
								</p>
							</li>
							<li style="width:100%;">
								<label style="width:150px;">Choose a Password:</label>
								<input id="Password" name="Password" class="textInput usernameField" value="" type="password" required="yes" maxlength="10" message="You must choose a password.">
								<span class="bottomNote" style="margin-left:155px;">(5 to 10 characters)</span>
							</li>
							<li style="width:100%;">
								<label style="width:150px;">Confirm Password:</label>
								<input id="ConfirmPassword" name="ConfirmPassword" class="textInput passwordField" value="" type="password" required="yes" maxlength="50" message="You must confirm your password and it must match.">
							</li>
						</ul>
					</div>
					<input type="hidden" name="RegisterAccount" value="0">
					<div class="WhyRegister">
						<h3>Why Register?</h3>
						<ul>
							<li>Track orders online.</li>
							<li>Expedite future checkouts.</li>
							<li>Your personal information is secure.</li>
						</ul>
					</div>
				</div>

				<div id="ReviewOrderButton" style="float:right; display:block;">
					<input type="submit" id="reviewYourOrderBtn" name="Review" value="">
				</div>
			</form>
			
			</cfoutput>
		</div>
	</div>
</div>

<script type="text/javascript">
	$().ready( function() {
		
		var thisShipCountry = $("#ShipCountry").val();
		var thisBillCountry = $("#BillCountry").val();
			
		$('#CheckoutForm').validate({
		
			rules: {
				ShipCompany: { required: false, maxlength: 50 },
				ShipFirstName: { required: true, maxlength: 50 },
				ShipLastName: { required: true, maxlength: 50 },
				ShipEmail: { required: true, maxlength: 50, email: true },				
				ShipAddress: { required: false, minlength: 2, maxlength: 50 },
				ShipAddress2: { required: false, minlength: 2, maxlength: 255 },
				ShipCity: { required: true, minlength: 2, maxlength: 50 },
				ShipState: { required: function(element) { return $('#ShipCountry').val() == 'US'; } },
				//ShipState: { required: (thisShipCountry == 'US') ? "true" : "false" },
				//ShipState: { required: true },
				ShipZipCode: { required: true },
				ShipCountry: { required: true },
				ShipPhoneNumber: { required: true },
				ShipPhoneNumberExt: { required: false, digits: true },
				ShipPhoneNumberAlt: { required: false },
				ShipPhoneNumberAltExt: { required: false, digits: true },
				
				BillCompany: { required: false, maxlength: 50 },
				BillFirstName: { required: true, maxlength: 50 },
				BillLastName: { required: true, maxlength: 50 },
				BillEmail: { required: true, maxlength: 50, email: true },				
				BillAddress: { required: false, minlength: 2, maxlength: 50 },
				BillAddress2: { required: false, minlength: 2, maxlength: 255 },
				BillCity: { required: true, minlength: 2, maxlength: 50 },
				//BillState: { required: (thisBillCountry == 'US') ? "true" : "false" },
				BillState: { required: function(element) { return $('#BillCountry').val() == 'US'; } },

				//BillState: { required: true } ,
				BillZipCode: { required: true },
				BillCountry: { required: true },
				//BillPhoneNumber: { required: true, phoneNumber: true },
				BillPhoneNumber: { required: true },
				BillPhoneNumberExt: { required: false, digits: true },
				BillPhoneNumberAlt: { required: false },
				BillPhoneNumberAltExt: { required: false, digits: true }
			}
		});
		
		//$('#ShipCountry').live('change', function(e) {

		//$('select.ShipCountry option:selected').val(); 
 
			//var thisShipCountry = $("#ShipCountry").val();
			//var thisBillCountry = $("#BillCountry").val();

		 	//alert($(this).val());
			//alert (thisShipCountry);

		if (thisShipCountry == 'US') {
			//alert('State is required.');
			$('#ShipState').show();
			$('#StateLabel').show();
			
		}
		else {
			$('#ShipState').hide().val('');
			$('#StateLabel').hide();
		}
		
		if (thisBillCountry == 'US') {
			//alert('State is required.');
			$('#BillState').show();
			$('#BillLabel').show();
			
		}
		else {
			$('#BillState').hide().val('');
			$('#BillLabel').hide();
		}
				
				
	//});
		
	});
</script>