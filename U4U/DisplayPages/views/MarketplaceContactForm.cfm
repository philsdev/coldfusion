<!------------------------------------------------------------------------------------------

	MarketplaceContactForm.cfm

------------------------------------------------------------------------------------------->

<cfscript>
	switch(URL.Message) {	
		case "Contact.Error": {
			variables.Message = "Your information could not be sent";	
			break;
		}
		case "Contact.Sent": {
			variables.Message = "Your information has been sent! Please allow some time for this seller to respond to you before sending a follow-up inquiry.";	
			break;
		}
		default: {
			variables.Message = "";	
		}	
	}
</cfscript>

<div id="content" class="popup">
	
		<h1>Contact Seller</h1>

	
    <p>Fill out the form below to contact this U4U seller directly.</p>
    
	<section class="formSection green">
		<cfif len(variables.Message)>
			<p class="message"><cfoutput>#variables.Message#</cfoutput></p>
		</cfif>
		<form action="/marketplace-contact-submit.html" method="post" id="ContactVendorForm">
			<input type="hidden" name="ItemID" value="<cfoutput>#Event.GetArg('ItemID')#</cfoutput>" />
			<div class="formContainer">
				<cfoutput>
				<span class="required requiredDesignation">Required Fields</span>
				<ul class="form pageForm vhh condensedForm">
					<li class="required">
						<label>First Name</label>
						<input type="text" name="FirstName" value="#Request.Account.FirstName#" />
					</li>
					<li>
						<label>Last Name</label>
						<input type="text" name="LastName" value="#Request.Account.LastName#" />
					</li>
					<li class="required">
						<label>E-mail</label>
						<input type="text" name="Email" value="#Request.Account.Email#" />
					</li>
					<li>
						<label>Phone Number</label>
						<input type="text" name="PhoneNumber" value="#Request.Account.PhoneNumber#" />
					</li>
					<li>
						<label>Comments</label>
						<textarea name="Comments"></textarea>
					</li>
				</ul>
				</cfoutput>
			</div>
			<footer class="actionContainer mt20">
				<input type="submit" class="button actionButton" value="Submit" >
			</footer>  
		</form>
    </section>
</div>

<script type="text/javascript">
	$().ready( function() {
		
		$('#ContactVendorForm').validate({
			rules: {
				FirstName: { required: true },
				LastName: { required: false },
				Email: { required: true, email: true },
				PhoneNumber: { required: false, phoneNumber: true },
				Comments: { required: false }
			}
		});
		
	});
</script>