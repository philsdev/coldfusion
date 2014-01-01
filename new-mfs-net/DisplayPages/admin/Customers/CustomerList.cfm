<script type="text/javascript" src="/Javascript/Customers.js"></script>

<div class="TabbedPanels" id="TabbedPanels1">
<cfinclude template="inc_MainNavigation.cfm" />
	<div class="TabbedPanelsContentGroup">
		<div class="TabbedPanelsContent">
		
			<div id="navigation" >
				<form action="javascript:void(0)" method="post" id="CustomerSearch">
					<h2 class="sectionTitle">Search Customers</h2>
					<ul class="form">
						<li>
							<label>Bill First Name:</label>
							<input type="text" name="BillFirstName" value=""  />
						</li>
						<li>
							<label>Bill Last Name:</label>
							<input type="text" name="BillLastName" value=""  />
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
				<div class="formContainer"><cfoutput>#request.CustomerGrid#</cfoutput></div>
			</div>
			
		</div>
	</div>
</div>