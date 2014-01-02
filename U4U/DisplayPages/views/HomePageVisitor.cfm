<!------------------------------------------------------------------------------------------

	HomePageVisitor.cfm

------------------------------------------------------------------------------------------->

<div id="centralAreaContainer" class="blue">
	<div id="centralArea" class="siteWidth">
		<div id="centralContent">
			<h1>Parties, study groups, and the latest campus buzz all in one spot.  <em>U4U Helps You Stay Connected.</em></h1>
			<p>
				Welcome to U4U, an interactive online social community for Boston area college students. 
				U4U will keep you up to date on all the latest local happenings, events and campus news. 
				You can even discuss coursework in one of our study groups. 
				<strong>Join today and get in the loop!</strong>
			</p>
		</div>
		<div class="module coloredModule shadowed" id="signup">
			<h3>Sign up for a FREE Account!</h3>
			<p>Start your free membership so you can stay connected to your local campus culture.</p>
			<p class="signupError message" style="color:red;display:none"></p>
			<div class="moduleContent">				
				<form action="/sign-up.html" method="post" id="SignUpForm" autocomplete="off">
					<ul class="form vvv" id="signupForm">
						<li>
							<cfoutput>#Request.SchoolBox#</cfoutput>
						</li>
						<li class="fname">
							<input type="text" name="FirstName" value="First Name" />
						</li>
						<li class="lname">
							<input type="text" name="LastName" value="Last Name" />
						</li>
						<li class="emailAddress">
							<input type="text" name="Email" value="E-mail Address" />
							<a href="/privacy.html" class="privacyLink">Privacy Policy</a>
						</li>
						<li>
							<input type="text" name="Username" id="Username" value="Username" />
						</li>
						<li class="labelTest">
							<label>Password</label>
							<input type="password" name="Password" id="Password" />
						</li>
						<li class="inline" style="padding-bottom:10px;">
							<input type="checkbox" name="TermsAndConditions" />
							<label>I agree to <a href="/terms-and-conditions.html">terms of service</a></label>
						</li>
						<li>
                        	<label style="width:100%;">Enter the letters below to validate your sign up. </label>
							<cfoutput>#Request.CaptchaFields#</cfoutput>
						</li>
						<li class="last actionContainer">
							<input type="Submit" class="button actionButton" value="Sign Up!" />
						</li>
					</ul>
				</form>
			</div>
		</div>
	</div>
</div>

<div id="main">
	<div id="content" style="padding-bottom:40px;margin-top:0px;">
		<cfoutput>#Request.LatestActivityWrapper#</cfoutput>
	</div>
	<div id="sidebar">
		<div class="module">
			<div class="moduleContent">
				<cfoutput>#Request.AdPlacementRight#</cfoutput>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
	$().ready( function() {
	
		GetLatestActivity('',1);
		
		$('#SignUpForm').validate({
			rules: {
				FirstName: { required: true, maxlength: 50, not: 'First Name' },
				LastName: { required: true, maxlength: 50, not: 'Last Name' },
				Email: { required: true, email: true, not: 'E-mail Address' },
				Username: { required: true, minlength: 4, maxlength: 20, username: true, not: 'Username' },
				Password: { required: true, minlength: 6, maxlength: 20, not: 'Password' },
				TermsAndConditions: { required: true }
			},
			submitHandler: function(form) {
				var params = "username=" + $('#Username').val();
				$.post( 
					'/profile-check-username.html', 
					params, 
					function(data) {
						if (data == 0) {
							$('.signupError').hide();	
							form.submit();
						} else {
							$('.signupError').html('Please choose another username').show();							
						}
					}
				);
			}
		});		
		
	});
</script>


