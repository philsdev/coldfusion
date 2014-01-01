<script type="text/javascript" src="/Javascript/Corporate.js"></script>
     		                 
<div id="CustomerForm" class="inputForm">
	<form action="index.cfm?event=Admin.Corporate.Submit" method="post" id="CorporateEditForm">
		<cfoutput>
		<input type="hidden" name="DealerID" id="DealerID" value="<cfif request.Corporate.DealerID GT 0>#request.Corporate.DealerID#<cfelse>0</cfif>" />
		<input type="hidden" name="ReturnUrl" id="ReturnUrl" value="" />
		<ul class="form">
			<li>
				<label>Corporate Dealer ID:</label>
				#request.Corporate.DealerID#&nbsp;
			</li>      
			<li class="required">
				<label>Company:</label>
				<input type="text" class="textinput limitedField" name="Company" id="Company" value="#request.Corporate.Company#">
			</li>                  
			<li class="required">
				<label>First Contact First Name:</label>
				<input type="text" class="textinput limitedField" name="FirstName" id="FirstName" value="#request.Corporate.FirstName#">
			</li>
			<li class="required">
				<label>First Contact Last Name:</label>
				<input type="text" class="textinput limitedField" name="LastName" id="LastName" value="#request.Corporate.LastName#">
			</li>
			<li class="required">
				<label>First Contact Phone Number:</label>
				<input type="text" class="textinput limitedField" name="PhoneNumber" id="PhoneNumber" value="#request.Corporate.Phonenumber#">
			</li>
			<li>
				<label>Second Contact First Name:</label>
				<input type="text" class="textinput limitedField" name="FirstName2" id="FirstName2" value="#request.Corporate.FirstName2#">
			</li>
			<li>
				<label>Second Contact Last Name:</label>
				<input type="text" class="textinput limitedField" name="LastName2" id="LastName2" value="#request.Corporate.LastName2#">
			</li>
			<li>
				<label>Second Contact Phone Number:</label>
				<input type="text" class="textinput limitedField" name="PhoneNumber2" id="PhoneNumber2" value="#request.Corporate.Phonenumber2#">
			</li>
			<li class="required">
				<label>Email Address:</label>
				<input type="text" class="textinput limitedField" name="EmailAddress" id="EmailAddress" value="#request.Corporate.EmailAddress#">
			</li>
			<li class="required">
				<label>Years In Business:</label>
				<input type="text" class="textinput limitedField" name="YearsInBusiness" id="YearsInBusiness" value="#request.Corporate.YearsInBusiness#">
			</li>
			<li class="required">
				<label>Username:</label>
				<input type="text" class="textinput limitedField" name="Username" id="Username" value="#request.Corporate.Username#">
			</li>
			<!--- <li>
					<label for="Password">Password:</label>
					<input type="password" class="textinput" name="Password" id="Password" />
			</li> --->
			<li class="required">
				<label>Discount Percent:</label>
				<input type="text" class="textinput limitedField" name="DiscountPercent" id="DiscountPercent" value="#request.Corporate.DiscountPercent#">
			</li>
			<li class="required">
				<label>Tax Exempt:</label>
				#request.TaxExemptBox#
			</li>
			<li class="required">
				<label>Status:</label>
				#request.StatusBox#
			</li>
		</ul>
		#Request.SubmitButtons#
		</cfoutput>
	</form>
</div>
			