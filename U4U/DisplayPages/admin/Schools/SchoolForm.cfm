<cfparam name="URL.SchoolID" default="0" />

<cfinclude template="inc_Messages.cfm" />

<script type="text/javascript" src="/Javascript/Schools.js"></script>

<div class="TabbedPanels" id="TabbedPanels1">
<cfinclude template="inc_MainNavigation.cfm" />
	<div class="TabbedPanelsContentGroup">
		<div class="TabbedPanelsContent">
			<div class="formContainer">
				<div id="SchoolForm" class="inputForm">
					<form action="index.cfm?event=Admin.School.Submit" method="post" id="SchoolEditForm">
						<cfoutput>
						<input type="hidden" name="IsBackEnd" value="1" />
						<input type="hidden" name="SchoolID" id="SchoolID" value="<cfif Request.School.ID GT 0>#Request.School.ID#<cfelse>0</cfif>" />
						<input type="hidden" name="ReturnUrl" id="ReturnUrl" value="" />
						<h2 class="sectionTitle">School Information</h2>
						<ul class="form">	
							<li>
								<label>Location:</label>
								#request.LocationBox#
							</li>
							<li>
								<label>Title:</label>
								<input type="text" class="textinput" name="Title" value="#Request.School.Title#" />
							</li>
							<li>
								<label>Status:</label>
								#request.StatusBox#
							</li>
						</ul>
						<h2 class="sectionTitle">Address</h2>
						<ul class="form">							
							<li>
								<label>Title:</label>
								<input type="text" class="textinput" name="AddressTitle" value="#Request.School.AddressTitle#" />
							</li>
							<li>
								<label>Street 1:</label>
								<input type="text" class="textinput" name="Street1" value="#Request.School.Street1#" />
							</li>
							<li>
								<label>Street 2:</label>
								<input type="text" class="textinput" name="Street2" value="#Request.School.Street2#" />
							</li>
							<li>
								<label>City:</label>
								<input type="text" class="textinput" name="City" value="#Request.School.City#" />
							</li>
							<li>
								<label>State:</label>
								#Request.StateBox#
							</li>
							<li>
								<label>ZIP Code:</label>
								<input type="text" class="textinput" name="ZipCode" value="#Request.School.ZipCode#" />
							</li>	
							<li>
								<label>Phone Number:</label>
								<input type="text" class="textinput" name="PhoneNumber" value="#Request.School.PhoneNumber#" />
							</li>
							<li>
								<label>URL:</label>
								<input type="text" class="textinput" name="URL" value="#Request.School.URL#" />
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
