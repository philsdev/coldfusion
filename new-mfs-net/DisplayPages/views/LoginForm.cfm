<cfscript>
	variables.LinkManager = Request.ListenerManager.GetListener( "LinkManager" );
</cfscript>
<!------------------------------------------------------------------------------------------

	LoginForm.cfm
	login.html

------------------------------------------------------------------------------------------->


<div id="breadcrumb">
	<a href="/" title="">Home</a>
	<span>Login</span>
</div>
	
<!-- contentContainer nessesary for liquid layouts with static and percentage columns -->
<aside id="sidebar">
	<div class="sideModule navModule module">
		<h3>Module Title</h3>
		<div class="moduleContent">
			<p>Put sidebar content here.</p>
		</div>
	</div>	
</aside>

<div id="contentContainer">
	<div id="content" class="contentSection">
	<cfif IsDefined("SESSION.User.Failed") and Session.User.Failed eq 'yes'>
		<p class="message alert cb">That is not the correct username or password.  Please try again.</p>
	</cfif>
		<div class="inputForm" >
				<FORM id="FrontEndLoginForm" action="index.cfm?event=Customer.Profile.VerifyLogin" method="post">
				<input type="hidden" name="ErrorUrl" id="ErrorUrl" value="/login.html" />
				<input type="hidden" name="ReturnUrl" id="ReturnUrl" value="/my-account.html" />
				
				<h2 class="sectionTitle" style="text-align:left">Login</h2>
				<UL class="form">
					<LI>
						<LABEL>Username:</LABEL>                        
						<input class="textinput" type="text" name="Username" id="Username" style="width:200px" />
					</LI> 
					 <LI>
						<LABEL>Password:</LABEL>                        
						<input class="textinput" type="password" name="Password" id="Password" style="width:200px" />
					</LI>
					<LI>
						<LABEL>Type of Account:</LABEL>                        
						<input type="Radio" value="1" name="UserType" checked>Customer
					</LI>
					<LI>
						<LABEL></LABEL> 
						<input type="Radio" value="2" name="UserType" >Corporate 
					</LI>
				</UL>
				<div class="submitButtonContainer">	
					<button type="submit">Login</button>
				</div> 
				</FORM>	
			</div>
	</div>
</div>

