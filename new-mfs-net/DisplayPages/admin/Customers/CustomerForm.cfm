<script type="text/javascript" src="/Javascript/Customers.js"></script>
     		                 
<div id="CustomerForm" class="inputForm">
	<form action="index.cfm?event=Admin.Customer.Submit" method="post" id="CustomerEditForm">
		<cfoutput>
		<input type="hidden" name="AccountID" id="AccountID" value="<cfif Request.Customer.AccountID GT 0>#Request.Customer.AccountID#<cfelse>0</cfif>" />
		<input type="hidden" name="ReturnUrl" id="ReturnUrl" value="" />
		<ul class="form">                        
			<li class="required">
				<label>Bill First Name:</label>
				<input type="text" class="textinput limitedField" name="BillFirstName" id="BillFirstName" value="#Request.Customer.BillFirstName#">
			</li>
			<li class="required">
				<label>Bill Last Name:</label>
				<input type="text" class="textinput limitedField" name="BillLastName" id="BillLastName" value="#Request.Customer.BillLastName#">
			</li>
			<li class="required">
				<label>EmailAddress:</label>
				<input type="text" class="textinput limitedField" name="EmailAddress" id="EmailAddress" value="#Request.Customer.EmailAddress#">
			</li>
			<li class="required">
				<label>Username:</label>
				<input type="text" class="textinput limitedField" name="Username" id="Username" value="#Request.Customer.Username#">
			</li>
			<!--- <li>
					<label for="Password">Password:</label>
					<input type="password" class="textinput" name="Password" id="Password" />
			</li> --->
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
			