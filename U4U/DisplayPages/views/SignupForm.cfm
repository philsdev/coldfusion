<!------------------------------------------------------------------------------------------

	SignupForm.cfm

------------------------------------------------------------------------------------------->

<cfscript>
	switch(URL.Message) {	
		case "Signup.Error": {
			variables.Message = "Your signup form could not be processed";	
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
		<form action="/sign-up-submit.html" method="post" id="SignupForm">
			<div class="formContainer" >
				
				<ul class="form pageForm vvv">
					<li>
						<label>First Name</label>
						<input type="text" name="FirstName" />
					</li>
					<li>
						<label>Last Name</label>
						<input type="text" name="LastName" />
					</li>
					<li>
						<label>E-mail</label>
						<input type="text" name="Email" />
					</li>
					<li>
						<label>Username</label>
						<input type="text" name="Username" />
					</li>
					<li>
						<label>Password</label>
						<input type="password" name="Password" />	
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
			#Request.AdPlacement#
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