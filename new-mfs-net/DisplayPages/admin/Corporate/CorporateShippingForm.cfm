<script type="text/javascript" src="/Javascript/CorporateShipping.js"></script>

<div id="CustomerForm" class="inputForm">
	<cfif URL.DealerID GT 0>
		<form action="index.cfm?event=Admin.Corporate.Shipping.Submit" method="post" id="CorporateShippingEditForm">
			<cfoutput>
			<input type="hidden" name="DealerID" id="DealerID" value="#URL.DealerID#" />
			<input type="hidden" name="ReturnUrl" id="ReturnUrl" value="" />
			<ul class="form">                        
			<cfloop query="Request.Corporate">
				<li class="required">
					<label>Ship First Name:</label>
					<input type="text" class="textinput limitedField" name="ShipFirstName" id="ShipFirstName" value="#request.Corporate.ShipFirstName#">
				</li>
				<li class="required">
					<label>Ship Last Name:</label>
					<input type="text" class="textinput limitedField" name="ShipLastName" id="ShipLastName" value="#request.Corporate.ShipLastName#">
				</li>
				<li class="required">
					<label>Ship Address:</label>
					<input type="text" class="textinput limitedField" name="ShipAddress" id="ShipAddress" value="#Request.Corporate.ShipAddress#">
				</li>
				<li>
					<label>Ship Address 2:</label>
					<input type="text" class="textinput limitedField" name="ShipAddress2" id="ShipAddress2" value="#Request.Corporate.ShipAddress2#">
				</li>
				<li class="required">
					<label>Ship City:</label>
					<input type="text" class="textinput limitedField" name="ShipCity" id="ShipCity" value="#Request.Corporate.ShipCity#">
				</li>
				<li class="required">
					<label>Ship State:</label>
					#request.StateBox#
					<!--- <input type="text" class="textinput limitedField" name="ShipState" id="ShipState" value="#Request.Corporate.ShipState#"> --->
				</li>
				<li class="required">
					<label>Ship Zip Code:</label>
					<input type="text" class="textinput limitedField" name="ShipZipCode" id="ShipZipCode" value="#Request.Corporate.ShipZipCode#">
				</li>
				<li>
					<label>Ship Province:</label>
					<input type="text" class="textinput limitedField" name="ShipProvince" id="ShipProvince" value="#Request.Corporate.ShipProvince#">
				</li>
				<li class="required">
					<label>Ship Country:</label>
					#request.CountryBox#
					<!--- <input type="text" class="textinput limitedField" name="ShipCountry" id="ShipCountry" value="#Request.Corporate.ShipCountry#"> --->
				</li>
				<li class="required">
					<label>Ship Phone Number:</label>
					<input type="text" class="textinput" name="ShipPhoneNumber" id="ShipPhoneNumber" value="#Request.Corporate.ShipPhoneNumber#">
					ext <input type="text" class="textinput phoneExt" name="ShipPhoneExt" id="ShipPhoneExt" value="#Request.Corporate.ShipPhoneExt#">
				</li>
				<li>
					<label>Ship Alternate number:</label>
					<input type="text" class="textinput" name="ShipAltNumber" id="ShipAltNumber" value="#Request.Corporate.ShipAltNumber#">
					ext <input type="text" class="textinput phoneExt" name="ShipAltExt" id="ShipAltExt" value="#Request.Corporate.ShipAltExt#">
				</li>
			</cfloop>
			</ul>
			#Request.SubmitButtons#
			</cfoutput>
		</form>
	<cfelse>
		<p style="margin-left:10px;">You must create and save the customer details before adding shipping information.</p>
	</cfif>
</div>