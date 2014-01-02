<cfinclude template="inc_Messages.cfm" />

<script type="text/javascript" src="/Javascript/Accounts.js"></script>

<div class="TabbedPanels" id="TabbedPanels1">
<cfinclude template="inc_MainNavigation.cfm" />
	<div class="TabbedPanelsContentGroup">
		<div class="TabbedPanelsContent">
		
			<div id="navigation" >
				<form action="javascript:void(0)" method="post" id="AccountSearch">
					<h2 class="sectionTitle">Search Accounts</h2>
					<ul class="form">
						<li>
							<label>First Name:</label>
							<input type="text" name="FirstName" value=""  />
						</li>
						<li>
							<label>Last Name:</label>
							<input type="text" name="LastName" value=""  />
						</li>
						<li>
							<label>Username:</label>
							<input type="text" name="Username" value=""  />
						</li>
						<li>
							<label>School:</label>
							<cfoutput>#Request.SchoolBox#</cfoutput>
						</li>
						<li>
							<label>City:</label>
							<input type="text" name="City" value=""  />
						</li>
						<li>
							<label>State:</label>
							<cfoutput>#Request.StateBox#</cfoutput>
						</li>
						<li>
							<label>Status:</label>
							<cfoutput>#Request.StatusBox#</cfoutput>
						</li>
						<li>
							<label>Sort:</label>
							<cfoutput>#Request.SortBox#</cfoutput>
						</li>
					</ul>
					<div class="submitButtonContainer mb10">
						<button>Submit</button>
					</div>
				</form>
			</div>
			
			<div id="content">
				<div class="formContainer"><cfoutput>#Request.AccountGrid#</cfoutput></div>
			</div>
			
		</div>
	</div>
</div>