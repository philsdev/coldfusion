
<div id="breadcrumb">
	<a href="/" title="">Home</a>
		<span><cfif SESSION.User.UserType eq 1>
						Customer Account
					<cfelseif SESSION.User.UserType eq 2>
						Corporate Account
					</cfif></span>
</div>

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
	<cfif IsDefined("URL.Message") and URL.Message eq 'Customer.Updated'>
		<p class="message alert cb">Your Information was updated.  Thank you.</p>
	</cfif>
			
			<cfoutput>
	
			<form method="post" action="index.cfm?event=Customer.Profile.Account.Submit" name="ViewAccountInfoForm" id="ViewAccountInfoForm">
			<input type="hidden" name="ReturnUrl" id="ReturnUrl" value="/view-account-info.html" />
			<input type="hidden" name="AccountID" value="#SESSION.User.UserID#">
			<h2 class="shoppingCartTitle">Login Information</h2>
				<div class="formContainer checkoutForm">
					<ul class="form vhh tar " id="ShippingFields">
							<li class="required">
								<label>	Username/Email Address:</label>
								<input name="username" id="username" type="text" class="textInput usernameField" value="#request.Customer.username#" />
							</li>
							
							<li class="required" style="width:100%;">
								<label style="width:150px;">Choose a Password:</label>
								<input id="Password" name="Password" class="textInput passwordField" value="#request.Customer.Password#" type="password" required="yes" maxlength="10" message="You must choose a password.">
								<span class="bottomNote" style="margin-left:155px;">(5 to 10 characters)</span>
							</li>
							<li style="width:100%;">
								<label style="width:150px;">Confirm Password:</label>
								<input id="ConfirmPassword" name="ConfirmPassword" class="textInput passwordField" value="" type="password" required="yes" maxlength="50" message="You must confirm your password and it must match.">
							</li>
						</ul>
				</div>


				<h2 class="shoppingCartTitle">Shipping Information</h2>
				
				<div class="formContainer checkoutForm">
					<ul class="form vhh tar " id="ShippingFields">
						<li class="required">
							<label></label>
							Designates Required Fields
						</li>
						<li class="required">
							<label>First Name:</label>
							<input name="ShipFirstName" id="ShipFirstName" type="text" class="textInput nameField" value="#request.Customer.ShipFirstName#" />
						</li>
						<li class="required">
							<label>Last Name:</label>
							<input name="ShipLastName" id="ShipLastName" type="text" class="textInput nameField" value="#request.Customer.ShipLastName#" />
						</li>
						<li class="required">
							<label>Email Address:</label>
							<input name="EmailAddress" id="EmailAddress" type="text" maxlength="50" class="textInput nameField" value="#request.Customer.EmailAddress#" />
						</li>
						<li class="required">
							<label>Address:</label>
							<input name="ShipAddress" id="ShipAddress" type="text" class="textInput addressField" value="#request.Customer.ShipAddress#" />
						</li>
						<li>
							<label></label>
							<input name="ShipAddress2" id="ShipAddress2" type="text" class="textInput addressField" value="#request.Customer.ShipAddress2#" />
						</li>
						<li class="required">
							<label>City:</label>
							<input name="ShipCity" id="ShipCity" type="text" class="textInput cityField" value="#request.Customer.ShipCity#" />
						</li>
						<li class="required">
							<label>State:</label>
							#request.ShipStateBox#
						</li>
						<li class="required">
							<label>Postal Code:</label>
							<input name="ShipZipCode" id="ShipZipCode" type="text" class="textInput zipField" value="#request.Customer.ShipZipCode#" />
						</li>
						<li>
							<label>Province:</label>
							<input name="ShipProvince" id="ShipProvince" type="text" class="textInput" value="#request.Customer.ShipProvince#" />
						</li>
						<li class="required">
							<label>Country:</label>
							#request.ShipCountryBox#
						</li>
						<li class="required">
							<label>Phone Number:</label>
							<input name="ShipPhoneNumber" id="ShipPhonenumber" type="text" class="textInput phoneField" value="#request.Customer.ShipPhoneNumber#" />
							<cite>Ext:</cite>
							<input name="ShipPhoneExt" id="ShipPhoneExt" type="text" class="textInput phoneExtField" value="#request.Customer.ShipPhoneExt#" />
						</li>
						<li>
							<label>Alt. Phone Number:</label>
							<input name="ShipAltnumber" id="ShipAltnumber" type="text" class="textInput phoneField" value="#request.Customer.ShipAltNumber#" />
							<cite>Ext:</cite>
							<input name="ShipAltExt" id="ShipAltExt" type="text" class="textInput phoneExtField" value="#request.Customer.ShipAltExt#" />
						</li>
					</ul>
				</div>

				<h2 class="shoppingCartTitle">Billing Information</h2>

				
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
						<li class="required">
							<label>First Name:</label>
							<input name="BillFirstName" id="BillFirstName" type="text" class="textInput nameField" value="#request.Customer.BillFirstName#" />
						</li>
						<li class="required">
							<label>Last Name:</label>
							<input name="BillLastName" id="BillLastName" type="text" class="textInput nameField" value="#request.Customer.BillLastName#" />
						</li>
						<li class="required">
							<label>Address:</label>
							<input name="BillAddress" id="BillAddress" type="text" class="textInput addressField" value="#request.Customer.BillAddress#" />
						</li>
						<li >
							<label></label>
							<input name="BillAddress2" id="BillAddress2" type="text"  class="textInput addressField" value="#request.Customer.BillAddress2#" />
						</li>
						<li class="required">
							<label>City:</label>
							<input name="BillCity" id="BillCity" type="text" class="textInput cityField" value="#request.Customer.BillCity#" />
						</li>
						<li class="required">
							<label>State:</label>
							#request.BillStateBox#
						</li>
						<li class="required">
							<label>Postal Code:</label>
							<input name="BillZipCode" id="BillZipCode" type="text" class="textInput zipField" value="#request.Customer.BillZipCode#" />
						</li>
						<li>
							<label>Province:</label>
							<input name="BillProvince" id="BillProvince" type="text" class="textInput" value="#request.Customer.BillProvince#" />
						</li>
						<li class="required">
							<label>Country:</label>
							#request.BillCountryBox#
						</li>
						<li class="required">
							<label>Phone Number:</label>
							<input name="BillPhoneNumber" id="BillPhoneNumber" type="text" class="textInput phoneField" value="#request.Customer.BillPhoneNumber#" />
							<cite>Ext:</cite>
							<input name="BillPhoneExt" id="BillPhoneExt" type="text" class="textInput phoneExtField" value="#request.Customer.BillPhoneExt#" />
						</li>
						<li>
							<label>Alt. Phone Number:</label>
							<input name="BillAltNumber" id="BillAltNumber" type="text" class="textInput phoneField" value="#request.Customer.BillAltNumber#" />
							<cite>Ext:</cite>
							<input name="BillAltExt" id="BillAltExt" type="text" class="textInput phoneExtField" value="#request.Customer.BillAltExt#" />
						</li>
						<li><input type="submit" value="Update Customer Information" class="button" />
						</li>
					</ul>
				</div>
		
				</form>
			
			</cfoutput>
		</div>
	</div>
<cfelse>
	<p>This page is not available to you.  Please login to see you account information.
</cfif>	


<script type="text/javascript">
	$().ready( function() {
		
		$('#ViewAccountInfoForm').validate({
			rules: {
				ShipCompany: { required: false, maxlength: 50 },
				ShipFirstName: { required: true, maxlength: 50 },
				ShipLastName: { required: true, maxlength: 50 },
				ShipAddress: { required: false, minlength: 2, maxlength: 50 },
				ShipAddress2: { required: false, minlength: 2, maxlength: 255 },
				ShipCity: { required: true, minlength: 2, maxlength: 50 },
				ShipState: { required: true },
				ShipZipCode: { required: true, zipCode: true },
				ShipCountry: { required: true },
				ShipPhoneNumber: { required: true, phoneNumber: true },
				ShipPhoneNumberExt: { required: false, digits: true },
				ShipPhoneNumberAlt: { required: false, phoneNumber: true },
				ShipPhoneNumberAltExt: { required: false, digits: true },
				
				BillCompany: { required: false, maxlength: 50 },
				BillFirstName: { required: true, maxlength: 50 },
				BillLastName: { required: true, maxlength: 50 },			
				BillAddress: { required: false, minlength: 2, maxlength: 50 },
				BillAddress2: { required: false, minlength: 2, maxlength: 255 },
				BillCity: { required: true, minlength: 2, maxlength: 50 },
				BillState: { required: true },
				BillZipCode: { required: true, zipCode: true },
				BillCountry: { required: true },
				BillPhoneNumber: { required: true, phoneNumber: true },
				BillPhoneNumberExt: { required: false, digits: true },
				BillPhoneNumberAlt: { required: false, phoneNumber: true },
				BillPhoneNumberAltExt: { required: false, digits: true },
				
				EmailAddress: { required: true, maxlength: 50, email: true }
			}
		});
		
	});
</script>