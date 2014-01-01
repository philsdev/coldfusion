<script type="text/javascript" src="/Javascript/Corporate.js"></script>

<div class="TabbedPanels" id="TabbedPanels1">
<cfinclude template="inc_MainNavigation.cfm" />
	<div class="TabbedPanelsContentGroup">
		<div class="TabbedPanelsContent">
		
			<div id="navigation" >
				<form action="javascript:void(0)" method="post" id="CorporateSearch">
					<h2 class="sectionTitle">Search Companies</h2>
					<ul class="form">
						<li>
							<label>Company Name:</label>
							<input type="text" name="Company" value=""  />
						</li>
						<li>
							<label>First Name:</label>
							<input type="text" name="FirstName" value=""  />
						</li>
						<li>
							<label>Last Name:</label>
							<input type="text" name="LastName" value=""  />
						</li>
						<li>
							<label>Status:</label>
							<cfoutput>#request.StatusBox#</cfoutput>
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
				<div class="formContainer"><cfoutput>#request.CorporateGrid#</cfoutput></div>
			</div>
			
		</div>
	</div>
</div>