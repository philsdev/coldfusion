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
						<input type="hidden" name="EmailID" id="EmailID" value="<cfif Request.Email.ID GT 0>#Request.Email.ID#<cfelse>0</cfif>" />
						<input type="hidden" name="ReturnUrl" id="ReturnUrl" value="" />
						<h2 class="sectionTitle">E-mail Information</h2>
						<ul class="form">
							<li>
								<label for="Email">Email:</label>
								<input type="text" class="textinput" name="Email" value="#Request.Email.Email#" />
							</li>
							<li>
								<label for="Status">Status:</label>
								#request.StatusBox#
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
