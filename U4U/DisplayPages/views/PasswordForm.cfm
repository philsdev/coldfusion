<!------------------------------------------------------------------------------------------

	PasswordForm.cfm

------------------------------------------------------------------------------------------->

<cfscript>
	switch(URL.Message) {	
		case "Password.Unique": {
			variables.Message = "Your new password must not match your existing password";	
			break;
		}
		case "Password.Incorrect": {
			variables.Message = "You did not supply the correct existing password";	
			break;
		}
		case "Password.Success": {
			variables.Message = "Your password has been changed";	
			break;
		}
		default: {
			variables.Message = "";	
		}	
	}
	
	variables.Title = "Change My Password";
</cfscript>

<div id="content">
	<div id="breadcrumb">
		<a href="/" title="">Home</a>
		<a href="/profile-edit.html">Edit Profile</a>
		<span><cfoutput>#variables.Title#</cfoutput></span>
	</div>
	<header class="contentListHeader clearfix">
		<h1><cfoutput>#variables.Title#</cfoutput></h1>
	</header>
	<section class="formSection">
		<cfif len(variables.Message)>
			<p class="message"><cfoutput>#variables.Message#</cfoutput></p>
		</cfif>
		<form action="/password-submit.html" method="post" id="PasswordForm">
			<div class="formContainer" >
				
				<ul class="form pageForm vvv">
					<li>
						<label>Existing Password</label>
						<input type="password" id="PasswordExisting" name="PasswordExisting" />
					</li>
					<li>
						<label>New Password</label>
						<input type="password" id="Password" name="Password" />
						<div class="PasswordStrength" style="display:none"></div>			
					</li>
					<li>
						<label>Confirm Password</label>
						<input type="password" id="PasswordConfirm" name="PasswordConfirm" />
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
	<cfinclude template="#Request.ViewManager.getViewPath('Links.Account')#" />	
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
				PasswordExisting: { required: true },
				Password: { required: true, notEqualTo: '#PasswordExisting' },
				PasswordConfirm: { required: true, equalTo: '#Password' },
			}
		});
		
	});
</script>