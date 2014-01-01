<cfinclude template="inc_Messages.cfm" />

<script type="text/javascript" src="/Javascript/Registry.js"></script>

<div class="TabbedPanels" id="TabbedPanels1">
<cfinclude template="inc_MainNavigation.cfm" />
	<div class="TabbedPanelsContentGroup">
		<div class="TabbedPanelsContent">
		
			<div id="navigation" >
				<form action="javascript:void(0)" method="post" id="RegistrySearch">
					<h2 class="sectionTitle">Search Registry</h2>
					<ul class="form">
						<li>
							<label>First Name:</label>
							<input type="text" name="BillFirstName" value=""  />
						</li>
						<li>
							<label>Last Name:</label>
							<input type="text" name="BillLastName" value=""  />
						</li>
						<li>
							<label>Registry Code:</label>
							<input type="text" name="Registry_Code" value=""  />
						</li>
						<li>
							<label>Creation Date:</label>
							<cfoutput><input id="Create_Date" class="textinput datepicker" type="text" value="" name="Create_Date" style="width: 100px;"></cfoutput>
						</li>
						<li>
							<label>Event Date:</label>
							<cfoutput><input id="Event_Date" class="textinput datepicker" type="text" value="" name="Event_Date" style="width: 100px;"></cfoutput>
						</li>
						<li>
							<label>Sort:</label>
							<cfoutput>#Request.SortBox#</cfoutput>
						</li>
						<li>
							<label>Order:</label>
							<cfoutput>#Request.SordBox#</cfoutput>
						</li>
					</ul>
					<div class="submitButtonContainer mb10">
						<button>Submit</button>
					</div>
				</form>
			</div>
			
			<div id="content">
				<div class="formContainer"><cfoutput>#request.RegistryGrid#</cfoutput></div>
			</div>
			
		</div>
	</div>
</div>