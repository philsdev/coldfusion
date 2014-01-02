<script type="text/javascript" src="/Javascript/Login.js"></script>

<CFIF StructKeyExists(Session, "Admin")>
	<CFLOCATION url="index.cfm?event=Admin.HomePage" addtoken="no" />
<CFELSE>
	<CFLOCK type="exclusive" scope="session" timeout="10">
		<CFSET Session.SendToLogin = "true" />	
		
		<CFIF StructKeyExists(session, "Failed") AND session.Failed IS "Yes">
			<p class="Message" align="CENTER">
				Your administrator account was not found with the username and password entered.
			</p>
		</CFIF>
	</CFLOCK>
	
	<DIV align="center">
		<DIV class="formContainer" style="width: 400px">
			<div class="inputForm" >
				<FORM id="AdminLoginForm" action="index.cfm?event=Admin.Verify" method="post">
				<h2 class="sectionTitle" style="text-align:left">Administrator Login</h2>
				<UL class="form">
					<LI>
						<LABEL>Username:</LABEL>                        
						<input class="textinput" type="text" name="Username" id="Username" />
					</LI> 
					<LI>
						<LABEL>Password:</LABEL>                        
						<input class="textinput" type="password" name="Password" id="Password" />
					</LI> 
				</UL>
				<DIV class="submitButtonContainer">	
					<button type="submit">Login</button>
				</DIV> 
				</FORM>	
			</div>
		</DIV>
	</DIV>

</CFIF>