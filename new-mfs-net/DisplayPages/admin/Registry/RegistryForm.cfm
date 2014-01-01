<cfparam name="URL.RegistryID" default="0" />

<cfinclude template="inc_Messages.cfm" />

<script type="text/javascript" src="/Javascript/Registrys.js"></script>

<div class="TabbedPanels" id="TabbedPanels1">
<cfinclude template="inc_MainNavigation.cfm" />
	<div class="TabbedPanelsContentGroup">
		<div class="TabbedPanelsContent">
			<div class="formContainer">       		                 
				<div id="RegistryForm" class="inputForm">
					<form action="index.cfm?event=Admin.Registry.Submit" method="post" id="RegistryEditForm">
						<cfoutput>
						<input type="hidden" name="RegistryID" id="RegistryID" value="<cfif Request.Registry.RegistryID GT 0>#Request.Registry.RegistryID#<cfelse>0</cfif>" />
						<input type="hidden" name="ReturnUrl" id="ReturnUrl" value="" />
						<ul class="form">                        
							<li>
								<label>Billing Name:</label>
								#Request.Registry.BillFirstName#&nbsp;#Request.Registry.BillLastName# &nbsp;
							</li>
							<li>
								<label>EmailAddress:</label>
								#request.Registry.EmailAddress# &nbsp;
							</li>
							
							
							<li>
								<label>Registry Code:</label>
								#request.Registry.Registry_Code# &nbsp;
							</li>
							<li>
								<label>Registry Name:</label>
								#request.Registry.Registry_Name# &nbsp;
							</li>
							<li>
								<label>Event Date:</label>
								#DateFormat(request.Registry.Event_Date, 'mm/dd/yyyy')# &nbsp;
							</li>
							<li>
								<label>Date Created:</label>
								#DateFormat(request.Registry.Create_Date, 'mm/dd/yyyy')#&nbsp;
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