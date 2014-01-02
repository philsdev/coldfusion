<!------------------------------------------------------------------------------------------

	ProfileForm.cfm

------------------------------------------------------------------------------------------->

<cfscript>

	variables.Title = "Edit Profile";
	variables.ButtonTitle = "Edit Profile";
	variables.IsNewItem = false;
	
	switch(URL.Message) {
		case "Profile.Welcome": {
			variables.Message = "Welcome to U4U! Please create a profile before proceeding. Thank You! ";	
			variables.Title = "Create Profile";
			variables.ButtonTitle = "Create Profile";
			variables.IsNewItem = true;
			break;
		}
		case "Profile.Error": {
			variables.Message = "Your profile form could not be processed";	
			break;
		}
		case "Profile.Updated": {
			variables.Message = "Your profile was updated";	
			break;
		}
		default: {
			variables.Message = "";	
		}	
	}	
	
</cfscript>

<div id="content">
	<div id="breadcrumb">
		<a href="/" title="">Home</a>
		<span><cfoutput>#variables.Title#</cfoutput></span>
	</div>
	
	<header class="contentListHeader clearfix">
		<h1><cfoutput>#variables.Title#</cfoutput></h1>
	</header>
	
	<section class="formSection">
		<cfif len(variables.Message)>
			<p class="message"><cfoutput>#variables.Message#</cfoutput></p>
		</cfif>
		<form action="/profile-submit.html" method="post" id="ProfileForm">
			<div class="formContainer" >
				<cfoutput>
				<span class="required requiredDesignation">Required Fields</span>
				<ul class="form pageForm vvv">
					<li class="required">
						<label>School</label>
						#Request.SchoolBox#
					</li>
					<li class="required">
						<label>First Name</label>
						<input type="text" name="FirstName" value="#Request.Account.FirstName#" />
					</li>
					<li class="required">
						<label>Last Name</label>
						<input type="text" name="LastName" value="#Request.Account.LastName#" />
					</li>
					<li class="required">
						<label>E-mail</label>
						<input type="text" name="Email" value="#Request.Account.Email#" />
					</li>
					<li class="required">
						<label>Username</label>
						<input type="text" name="Username" value="#Request.Account.Username#" readonly />
					</li>
					<li>
						<label>Street 1</label>
						<input type="text" name="Street1" value="#Request.Account.Street1#" />
					</li>
					<li>
						<label>Street 2</label>
						<input type="text" name="Street2" value="#Request.Account.Street2#" />
					</li>
					<li>
						<label>City</label>
						<input type="text" name="City" value="#Request.Account.City#" />
					</li>
					<li>
						<label>State</label>
						#Request.StateBox#
					</li>
					<li>
						<label>ZIP Code</label>
						<input type="text" name="ZipCode" value="#Request.Account.ZipCode#" />
					</li>
					<li>
						<label>Phone Number</label>
						<input type="text" name="PhoneNumber" value="#Request.Account.PhoneNumber#" />
					</li>
					<li>
						<label>URL</label>
						<input type="text" name="URL" value="#Request.Account.URL#" />
					</li>
					<li>
						<label>Signature</label>
						<textarea name="Signature">#Request.Account.Signature#</textarea>
					</li>
                    <!--- 
					<cfif variables.IsNewItem>
						<li class="required inline" >
							<label>I agree to <a href="/terms-and-conditions.html">terms of service</a></label>
							<input type="checkbox" name="TermsAndConditions" />
						</li>	
					</cfif> --->
				</ul>
				</cfoutput>
			</div>
			<footer class="actionContainer mt20">
				<input type="submit" class="button actionButton" value="<cfoutput>#variables.ButtonTitle#</cfoutput>" >
			</footer>  
		</form>
    </section>
</div>

<div id="sidebar">
	<cfinclude template="#Request.ViewManager.getViewPath('Links.AccountDetails')#" />
	<cfinclude template="#Request.ViewManager.getViewPath('Links.Account')#" />	
	<div class="module">
		<div class="moduleContent">
			<cfoutput>#Request.AdPlacementRight#</cfoutput>
		</div>
	</div>
</div>

<script type="text/javascript">
	$().ready( function() {
		
		$('#ProfileForm').validate({
			rules: {
				<!--- <cfif variables.IsNewItem>
					TermsAndConditions: { required: true },
				</cfif> --->
				School: { required: false },
				FirstName: { required: true, maxlength: 50 },
				LastName: { required: true, maxlength: 50 },
				Email: { required: true, email: true },				
				Street1: { required: false, minlength: 2 },
				Street2: { required: false, minlength: 2 },
				City: { required: false, minlength: 2 },
				State: { required: false },
				ZipCode: { required: false, zipCode: true },
				PhoneNumber: { required: false, phoneNumber: true },
				URL: { required: false, url: true },
				Signature: { required: false, maxlength: 2000 }				
			}
		});
		
	});
</script>