<cfparam name="URL.EmailID" default="0" />

<cfinclude template="inc_Messages.cfm" />

<script type="text/javascript" src="/Javascript/Emails.js"></script>

<div class="TabbedPanels" id="TabbedPanels1">
<cfinclude template="inc_MainNavigation.cfm" />
	<div class="TabbedPanelsContentGroup">
		<div class="TabbedPanelsContent">
			<div class="formContainer">
				<div id="EmailForm" class="inputForm">
					<form action="index.cfm?event=Admin.Email.Submit" method="post" id="EmailEditForm">
						<cfoutput>
						<input type="hidden" name="IsBackEnd" value="1" />
						<input type="hidden" name="EmailID" id="EmailID" value="<cfif Request.Email.EmailID GT 0>#Request.Email.EmailID#<cfelse>0</cfif>" />
						<input type="hidden" name="ReturnUrl" id="ReturnUrl" value="" />
						<h2 class="sectionTitle">E-mail Information</h2>
						<ul class="form">
							<li>
								<label for="Email">Email:</label>
								<input type="text" class="textinput limitedField" name="Email" id="Email" value="#Request.Email.Email#" />
							</li>
							<li>
								<label for="Name">Name:</label>
								<input type="text" class="textinput limitedField" name="Emailname" id="Emailname" value="#Request.Email.Emailname#" />
							</li>
							<cfif URL.EmailID NEQ "0">
								<li>
									<label for="Source">Source:</label>
									#Request.Email.Email_source# 
									
								</li>
								<li>
									<label for="Date">Date Inserted:</label>
									#DateFormat(Request.Email.Email_DateInserted, 'short')# #TimeFormat(Request.Email.Email_DateInserted, 'short')#
								</li>
							</cfif>
							<li>
								<label for="Subscribed">Subscribed:</label>
								#request.IsSubscribedBox#
							</li>
						</ul>
						#Request.SubmitButtons#
						</cfoutput>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>
