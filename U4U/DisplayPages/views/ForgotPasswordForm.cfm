<!------------------------------------------------------------------------------------------

	ForgotPasswordForm.cfm

------------------------------------------------------------------------------------------->

<cfscript>
	switch(URL.Message) {	
		case "Reset.NotFound": {
			variables.Message = "Your username was not found in the system";	
			break;
		}
		default: {
			variables.Message = "";	
		}	
	}
</cfscript>

<div id="content">
	<header class="contentListHeader clearfix">
		<h1>Forgot My Password</h1>
	</header>
	<section class="formSection">
		<cfif len(variables.Message)>
			<p class="message"><cfoutput>#variables.Message#</cfoutput></p>
		</cfif>
		
		<p>Please enter the username you used to sign up for U4U, and we will send a new password to the e-mail address on file.</p>
		
		<form action="/password-reset.html" method="post" id="PasswordForm">
			<div class="formContainer" >
				
				<ul class="form pageForm vvv">
					<li>
						<label>Username</label>
						<input type="text" name="Username" />
					</li>
				</ul>
			</div>
			<footer class="actionContainer mt20">
				<input type="submit" class="button actionButton" value="Submit" >
			</footer>  
		</form>
    </section>
</div>

<div id="sidebar">
	<div class="module">
		<div class="moduleContent">
			<cfoutput>#Request.AdPlacementRight#</cfoutput>
		</div>
	</div>
</div>

<script type="text/javascript">
	$().ready( function() {
		
		$('#PasswordForm').validate({
			rules: {
				Username: { required: true }
			}
		});
		
	});
</script>