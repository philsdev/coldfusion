<script type="text/javascript" src="/Javascript/OrderShipping.js"></script>
      		                 
<div id="OrderShippingForm" class="inputForm">
	<form action="index.cfm?event=Admin.Order.Shipping.Submit" method="post" id="OrderShippingEditForm">
		<cfoutput>
		<input type="hidden" name="OrderID" id="OrderID" value="<cfif Request.OrderShipping.OrderID GT 0>#Request.OrderShipping.OrderID#<cfelse>0</cfif>" />
		<input type="hidden" name="ReturnUrl" id="ReturnUrl" value="" />
		<ul class="form">
			<li>
				<label>Institution/Company:</label>
				<input type="text" class="textinput limitedField" name="ShipCompany" id="ShipCompany" value="#request.OrderShipping.ShipCompany#" />
			</li>
			<li class="required">
				<label>First Name:</label>
				<input type="text" class="textinput limitedField" name="ShipFirstName" id="ShipFirstName" value="#request.OrderShipping.ShipFirstName#" />
			</li>
			<li class="required">
				<label>Last Name:</label>
				<input type="text" class="textinput limitedField" name="ShipLastName" id="ShipLastName" value="#request.OrderShipping.ShipLastName#" />
			</li>
			<li class="required">
				<label>E-mail Address:</label>
				<input type="text" class="textinput limitedField" name="ShipEmailAddress" id="ShipEmailAddress" value="#request.OrderShipping.ShipEmailAddress#" />
			</li>
			<li class="required">
				<label>Address:</label>
				<input type="text" class="textinput limitedField" name="ShipAddress" id="ShipAddress" value="#request.OrderShipping.ShipAddress#" />
			</li>
			<li>
				<label>Address 2:</label>
				<input type="text" class="textinput limitedField" name="ShipAddress2" id="ShipAddress2" value="#request.OrderShipping.ShipAddress2#" />
			</li>
			<li class="required">
				<label>City:</label>
				<input type="text" class="textinput limitedField" name="ShipCity" id="ShipCity" value="#request.OrderShipping.ShipCity#" />
			</li>
			<li class="required">
				<label>State:</label>
				#request.ShippingStateBox#
			</li>
			<li class="required">
				<label>ZIP Code:</label>
				<input type="text" class="textinput limitedField zipCode" name="ShipZipCode" id="ShipZipCode" value="#request.OrderShipping.ShipZipCode#" />
			</li>
			<li>
				<label>Province:</label>
				<input type="text" class="textinput limitedField" name="ShipProvince" id="ShipProvince" value="#Request.OrderShipping.ShipProvince#">
			</li>
			<li class="required">
				<label>Country:</label>
				#request.CountryBox#
			</li>
			<li class="required">
				<label>Phone Number:</label>
				<span style="white-space:nowrap">
					<input type="text" class="textinput phone" name="ShipPhoneNumber" id="ShipPhoneNumber" value="#request.OrderShipping.ShipPhoneNumber#" />
					ext
					<input type="text" class="textinput phoneExt" name="ShipPhoneExt" id="ShipPhoneExt" value="#request.OrderShipping.ShipPhoneExt#" />
				</span>
			</li>
			<li>
				<label>Alt Phone Number:</label>
				<span style="white-space:nowrap">
					<input type="text" class="textinput phone" name="ShipAltNumber" id="ShipAltNumber" value="#request.OrderShipping.ShipAltNumber#" />
					ext
					<input type="text" class="textinput phoneExt" name="ShipAltExt" id="ShipAltExt" value="#request.OrderShipping.ShipAltExt#" />
				</span>
			</li>
		</ul>
		<h2 class="sectionTitle">Carrier Information</h2>
		<ul class="form">
			<li>
				<label>Shipping Method:</label>
				#request.OrderShipping.ShippingMethod#
			</li>
		</ul>
		#Request.SubmitButtons#
		</cfoutput>
	</form>
</div>