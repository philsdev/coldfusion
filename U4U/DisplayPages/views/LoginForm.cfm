<!------------------------------------------------------------------------------------------

	LoginForm.cfm

------------------------------------------------------------------------------------------->

<cfscript>
	switch(URL.Message) {	
		case "Login.Error": {
			variables.Message = "Your login credentials are not valid";	
			break;
		}
		case "Login.Locked": {
			variables.Message = "Your account has been locked due to incorrect attempts";	
			break;
		}
		case "Login.Logout": {
			variables.Message = "You have been logged out of the system";	
			break;
		}
		case "Login.PasswordReset": {
			variables.Message = "A new password has been sent to your e-mail address";	
			break;
		}
		default: {
			variables.Message = "";	
		}	
	}
</cfscript>

<div id="content">
	<header class="contentListHeader clearfix">
		<h1>Login</h1>
	</header>
	<section class="formSection">
		<cfif len(variables.Message)>
			<p class="message"><cfoutput>#variables.Message#</cfoutput></p>
		</cfif>
		<form action="/login-submit.html" method="post" id="LoginForm">
			<div class="formContainer" >				
				<ul class="form pageForm vvv">
					<li>
						<label>Username</label>
						<input type="text" name="Username" />
					</li>
					<li>
						<label>Password</label>
						<input type="password" name="Password" />	
                        <a href="/password-forgot.html" class="bottomNote" style="padding-left:0">Forgot My Password</a>
					</li>
                    <li><input type="submit" class="button actionButton" value="Login" ></li>
				</ul>            
			</div>			 
		</form>
       
    </section>
	
	<h3 class="mt20" style="font-weight:normal;">
		Not signed up yet? 
		<a href="/" title="" ><strong>Sign up now for free!</strong></a>
	</h3>
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
		
		$('#LoginForm').validate({
			rules: {
				Username: { required: true },
				Password: { required: true }
			}
		});
		
	});
</script>