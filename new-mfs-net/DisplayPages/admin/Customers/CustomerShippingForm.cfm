<script type="text/javascript" src="/Javascript/CustomerShipping.js"></script>

<div id="CustomerForm" class="inputForm">
	<cfif URL.AccountID GT 0>
		<form action="index.cfm?event=Admin.Customer.Shipping.Submit" method="post" id="CustomerShippingEditForm">
			<cfoutput>
			<input type="hidden" name="AccountID" id="AccountID" value="#URL.AccountID#" />
			<input type="hidden" name="ReturnUrl" id="ReturnUrl" value="" />
			<ul class="form">                        
			<cfloop query="request.Customer">
				<li class="required">
					<label>Ship First Name:</label>
					<input type="text" class="textinput limitedField" name="ShipFirstName" id="ShipFirstName" value="#Request.Customer.ShipFirstName#">
				</li>
				<li class="required">
					<label>Ship Last Name:</label>
					<input type="text" class="textinput limitedField" name="ShipLastName" id="ShipLastName" value="#Request.Customer.ShipLastName#">
				</li>
				<li class="required">
					<label>Ship Address:</label>
					<input type="text" class="textinput limitedField" name="ShipAddress" id="ShipAddress" value="#Request.Customer.ShipAddress#">
				</li>
				<li>
					<label>Ship Address 2:</label>
					<input type="text" class="textinput limitedField" name="ShipAddress2" id="ShipAddress2" value="#Request.Customer.ShipAddress2#">
				</li>
				<li class="required">
					<label>Ship City:</label>
					<input type="text" class="textinput limitedField" name="ShipCity" id="ShipCity" value="#Request.Customer.ShipCity#">
				</li>
				<li class="required">
					<label>Ship State:</label>
					#request.StateBox#
					<!--- <input type="text" class="textinput limitedField" name="ShipState" id="ShipState" value="#Request.Customer.ShipState#"> --->
				</li>
				<li class="required">
					<label>Ship Zip Code:</label>
					<input type="text" class="textinput limitedField" name="ShipZipCode" id="ShipZipCode" value="#Request.Customer.ShipZipCode#">
				</li>
				<li>
					<label>Ship Province:</label>
					<input type="text" class="textinput limitedField" name="ShipProvince" id="ShipProvince" value="#Request.Customer.ShipProvince#">
				</li>
				<li class="required">
					<label>Ship Country:</label>
					#request.CountryBox#
					<!--- <input type="text" class="textinput limitedField" name="ShipCountry" id="ShipCountry" value="#Request.Customer.ShipCountry#"> --->
				</li>
				<li class="required">
					<label>Ship Phone Number:</label>
					<input type="text" class="textinput" name="ShipPhoneNumber" id="ShipPhoneNumber" value="#Request.Customer.ShipPhoneNumber#">
					ext <input type="text" class="textinput phoneExt" name="ShipPhoneExt" id="ShipPhoneExt" value="#Request.Customer.ShipPhoneExt#">
				</li>
				<li>
					<label>Ship Alternate number:</label>
					<input type="text" class="textinput" name="ShipAltNumber" id="ShipAltNumber" value="#Request.Customer.ShipAltNumber#">
					ext <input type="text" class="textinput phoneExt" name="ShipAltExt" id="ShipAltExt" value="#Request.Customer.ShipAltExt#">
				</li>
			</cfloop>
			</ul>
			#Request.SubmitButtons#
			</cfoutput>
		</form>
	<cfelse>
		<p style="margin-left:10px;">You must create and save the customer details before adding Shiping information.</p>
	</cfif>
</div>