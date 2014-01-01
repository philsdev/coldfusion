<cfinclude template="inc_Messages.cfm" />

<script type="text/javascript" src="/Javascript/Vendors.js"></script>

<div class="TabbedPanels" id="TabbedPanels1">
<cfinclude template="inc_MainNavigation.cfm" />
	<div class="TabbedPanelsContentGroup">
		<div class="TabbedPanelsContent">
		
			<div id="navigation" >
				<form action="javascript:void(0)" method="post" id="VendorSearch">
					<h2 class="sectionTitle">Search Vendors</h2>
					<ul class="form">
						<li>
							<label>Vendor Name:</label>
							<input type="text" name="VendorName" value=""  />
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
				<div class="formContainer"><cfoutput>#request.VendorGrid#</cfoutput></div>
			</div>
			
		</div>
	</div>
</div>