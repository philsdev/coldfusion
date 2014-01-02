<cfparam name="URL.AdminID" default="0" />

<cfinclude template="inc_Messages.cfm" />

<script type="text/javascript" src="/Javascript/Administrators.js"></script>

<div class="TabbedPanels" id="TabbedPanels1">
<cfinclude template="inc_MainNavigation.cfm" />
	<div class="TabbedPanelsContentGroup">
		<div class="TabbedPanelsContent">
			<div class="formContainer">       		                 
				<div id="AdministratorForm" class="inputForm">
					<form action="index.cfm?event=Admin.Administrator.Submit" method="post" id="AdministratorEditForm">
						<cfoutput>
						<input type="hidden" name="AdminID" id="AdminID" value="<cfif Request.Administrator.ID GT 0>#Request.Administrator.ID#<cfelse>0</cfif>" />
						<input type="hidden" name="ReturnUrl" id="ReturnUrl" value="" />
						<ul class="form">                        
							<li>
								<label>First Name:</label>
								<input type="text" class="textinput" name="FirstName" id="FirstName" value="#request.Administrator.FirstName#" />
							</li>
							<li>
								<label>Last Name:</label>
								<input type="text" class="textinput" name="LastName" id="LastName" value="#request.Administrator.LastName#" />
							</li>
							<li>
								<label>Username:</label>
								<input type="text" class="textinput" name="Username" id="Username" value="#request.Administrator.Username#" />
							</li>
							<li>
								<label>Password:</label>
								<input type="password" class="textinput" name="Password" id="Password" value="" />
							</li>
							<li>
								<label>Confirm Password:</label>
								<input type="password" class="textinput" name="PasswordConfirm" id="PasswordConfirm" value="" />
							</li>
							<li>
								<label>Status:</label>
								#request.StatusBox#
							</li>
						</cfoutput>
							<li>
								<label>Section Permissions:</label>
								<table class="PermissionsTable">
								<cfoutput query="request.Permissions" group="GroupName">
									<tr>
										<th colspan="2">#GroupName#</th>
									</tr>
									<cfoutput>
									<tr>
										<td class="input"><input type="checkbox" name="Section" value="#SectionID#" 
											<CFIF IsAuthorized>checked="checked"</CFIF> /></td>
										<td class="label">#SectionName#</td>
									</tr>
									</cfoutput>
								</cfoutput>
								</table>
							</li>
							<li>
								<label>&nbsp;</label>
								<a>All</a> <a>None</a>
							</li>
						</UL>
						<cfoutput>#Request.SubmitButtons#</cfoutput>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>