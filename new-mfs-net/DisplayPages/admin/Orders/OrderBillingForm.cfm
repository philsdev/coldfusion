<script type="text/javascript" src="/Javascript/OrderBilling.js"></script>
      		                 
<div id="OrderBillingForm" class="inputForm">
	<form action="index.cfm?event=Admin.Order.Billing.Submit" method="post" id="OrderBillingEditForm">
		<cfoutput>
		<input type="hidden" name="OrderID" id="OrderID" value="<cfif Request.OrderBilling.OrderID GT 0>#Request.OrderBilling.OrderID#<cfelse>0</cfif>" />
		<input type="hidden" name="ReturnUrl" id="ReturnUrl" value="" />
		<ul class="form">
			<li>
				<label>Institution/Company:</label>
				<input type="text" class="textinput limitedField" name="BillCompany" id="BillCompany" value="#request.OrderBilling.BillCompany#" />
			</li>
			<li class="required">
				<label>First Name:</label>
				<input type="text" class="textinput limitedField" name="BillFirstName" id="BillFirstName" value="#request.OrderBilling.BillFirstName#" />
			</li>
			<li class="required">
				<label>Last Name:</label>
				<input type="text" class="textinput limitedField" name="BillLastName" id="BillLastName" value="#request.OrderBilling.BillLastName#" />
			</li>
			<li class="required">
				<label>E-mail Address:</label>
				<input type="text" class="textinput limitedField" name="BillEmailAddress" id="BillEmailAddress" value="#request.OrderBilling.BillEmailAddress#" />
			</li>
			<li class="required">
				<label>Address:</label>
				<input type="text" class="textinput limitedField" name="BillAddress" id="BillAddress" value="#request.OrderBilling.BillAddress#" />
			</li>
			<li>
				<label>Address 2:</label>
				<input type="text" class="textinput limitedField" name="BillAddress2" id="BillAddress2" value="#request.OrderBilling.BillAddress2#" />
			</li>
			<li class="required">
				<label>City:</label>
				<input type="text" class="textinput limitedField" name="BillCity" id="BillCity" value="#request.OrderBilling.BillCity#" />
			</li>
			<li class="required">
				<label>State:</label>
				#request.BillingStateBox#
			</li>
			<li class="required">
				<label>ZIP Code:</label>
				<input type="text" class="textinput limitedField zipCode" name="BillZipCode" id="BillZipCode" value="#request.OrderBilling.BillZipCode#" />
			</li>
			<li>
				<label>Province:</label>
				<input type="text" class="textinput limitedField" name="BillProvince" id="BillProvince" value="#Request.OrderBilling.BillProvince#">
			</li>
			<li class="required">
				<label>Country:</label>
				#request.CountryBox#
			</li>
			<li class="required">
				<label>Phone Number:</label>
				<span style="white-space:nowrap">
					<input type="text" class="textinput phone" name="BillPhoneNumber" id="BillPhoneNumber" value="#request.OrderBilling.BillPhoneNumber#" />
					ext
					<input type="text" class="textinput phoneExt" name="BillPhoneExt" id="BillPhoneExt" value="#request.OrderBilling.BillPhoneExt#" />
				</span>
			</li>
			<li>
				<label>Alt Phone Number:</label>
				<span style="white-space:nowrap">
					<input type="text" class="textinput phone" name="BillAltNumber" id="BillAltNumber" value="#request.OrderBilling.BillAltNumber#" />
					ext
					<input type="text" class="textinput phoneExt" name="BillAltExt" id="BillAltExt" value="#request.OrderBilling.BillAltExt#" />
				</span>
			</li>
		</ul>
		#Request.SubmitButtons#
		</cfoutput>
	</form>
</div>