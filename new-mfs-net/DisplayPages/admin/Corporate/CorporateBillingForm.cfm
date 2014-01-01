<script type="text/javascript" src="/Javascript/CorporateBilling.js"></script>

<div id="CustomerForm" class="inputForm">
	<cfif URL.DealerID GT 0>
		<form action="index.cfm?event=Admin.Corporate.Billing.Submit" method="post" id="CorporateBillingEditForm">
			<cfoutput>
			<input type="hidden" name="DealerID" id="DealerID" value="#URL.DealerID#" />
			<input type="hidden" name="ReturnUrl" id="ReturnUrl" value="" />
			<ul class="form">                        
			<cfloop query="Request.Corporate">
			<li class="required">
				<label>Bill First Name:</label>
				<input type="text" class="textinput limitedField" name="BillFirstName" id="BillFirstName" value="#request.Corporate.BillFirstName#">
			</li>
			<li class="required">
				<label>Bill Last Name:</label>
				<input type="text" class="textinput limitedField" name="BillLastName" id="BillLastName" value="#request.Corporate.BillLastName#">
			</li>
			<li class="required">
				<label>Bill Address:</label>
				<input type="text" class="textinput limitedField" name="BillAddress" id="BillAddress" value="#Request.Corporate.BillAddress#">
			</li>
			<li>
				<label>Bill Address 2:</label>
				<input type="text" class="textinput limitedField" name="BillAddress2" id="BillAddress2" value="#Request.Corporate.BillAddress2#">
			</li>
			<li class="required">
				<label>Bill City:</label>
				<input type="text" class="textinput limitedField" name="BillCity" id="BillCity" value="#Request.Corporate.BillCity#">
			</li>
			<li class="required">
				<label>Bill State:</label>
				#request.StateBox#
				<!--- <input type="text" class="textinput limitedField" name="BillState" id="BillState" value="#Request.Corporate.BillState#"> --->
			</li>
			<li class="required">
				<label>Bill Zip Code:</label>
				<input type="text" class="textinput limitedField" name="BillZipCode" id="BillZipCode" value="#Request.Corporate.BillZipCode#">
			</li>
			<li>
				<label>Bill Province:</label>
				<input type="text" class="textinput limitedField" name="BillProvince" id="BillProvince" value="#Request.Corporate.BillProvince#">
			</li>
			<li class="required">
				<label>Bill Country:</label>
				#request.CountryBox#
				<!--- <input type="text" class="textinput limitedField" name="BillCountry" id="BillCountry" value="#Request.Corporate.BillCountry#"> --->
			</li>
			<li class="required">
				<label>Bill Phone Number:</label>
				<input type="text" class="textinput" name="BillPhoneNumber" id="BillPhoneNumber" value="#Request.Corporate.BillPhoneNumber#">
				ext <input type="text" class="textinput phoneExt" name="BillPhoneExt" id="BillPhoneExt" value="#Request.Corporate.BillPhoneExt#">
			</li>
			<li>
				<label>Bill Alternate number:</label>
				<input type="text" class="textinput" name="BillAltNumber" id="BillAltNumber" value="#Request.Corporate.BillAltNumber#">
				ext <input type="text" class="textinput phoneExt" name="BillAltExt" id="BillAltExt" value="#Request.Corporate.BillAltExt#">
			</li>
			<input type="checkbox" name="IsShippingToBilling" id="IsShippingToBilling" class="noStyle"  value="1" />
						&nbsp;Billing Information is the same as Shipping	
			
			</cfloop>
			</ul>
			#Request.SubmitButtons#
			</cfoutput>
		</form>
	<cfelse>
		<p style="margin-left:10px;">You must create and save the customer details before adding billing information.</p>
	</cfif>
</div>