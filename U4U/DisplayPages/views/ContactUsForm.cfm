<!------------------------------------------------------------------------------------------

	ContactUsForm.cfm

------------------------------------------------------------------------------------------->

<cfscript>
	switch(URL.Message) {	
		case "Contact.Error": {
			variables.Message = "Your information could not be sent, please try again.";	
			break;
		}
		case "Contact.Sent": {
			variables.Message = "Your information was sent. We will make sure to address your questions or comments in a timely manner. Thank you for contacting U4U!  ";	
			break;
		}
		default: {
			variables.Message = "";	
		}	
	}
</cfscript>

<div id="content">
	<header class="contentListHeader clearfix">
		<h1>Contact Us</h1>
	</header>
	
    <p>Here at U4U we want our users to have a fun, fulfilling and safe online experience with their peers. 
	If there is an issue that you feel needs to be addressed, please contact us anytime. 
	We'll do our best to help you and get back to you as soon as possible!</p>
    
	<dl>
		<dt>Contact Information:</dt>
		<dd>Phone: 847-756-4056</dd>
		<!--- <dd>2537 Harvard Yard Mail Center</dd>
		<dd>Cambridge, MA</dd> --->
	</dl>
 
	<section class="formSection">
		<cfif len(variables.Message)>
			<p class="message"><cfoutput>#variables.Message#</cfoutput></p>
		</cfif>
		<h3>Contact Form</h3>
		<form action="/contact-submit.html" method="post" id="ContactUsForm">
			<div class="formContainer" >
				<cfoutput>
				<span class="required requiredDesignation">Required Fields</span>
				<ul class="form pageForm vvv">
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

<div id="sidebar">
	<cfinclude template="#Request.ViewManager.getViewPath('Links.AccountDetails')#" />
	<div class="module">
		<div class="moduleContent">
			<cfoutput>#Request.AdPlacementRight#</cfoutput>
		</div>
	</div>
</div>

<script type="text/javascript">
	$().ready( function() {
		
		$('#ContactUsForm').validate({
			rules: {
				FirstName: { required: true },
				LastName: { required: false },
				Email: { required: true, email: true },
				PhoneNumber: { required: false, phoneNumber: true }
			}
		});
		
	});
</script>