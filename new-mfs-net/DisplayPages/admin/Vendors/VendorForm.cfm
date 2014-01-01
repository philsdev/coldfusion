<cfparam name="URL.VendorID" default="0" />

<cfinclude template="inc_Messages.cfm" />

<script type="text/javascript" src="/Javascript/Vendors.js"></script>

<div class="TabbedPanels" id="TabbedPanels1">
<cfinclude template="inc_MainNavigation.cfm" />
	<div class="TabbedPanelsContentGroup">
		<div class="TabbedPanelsContent">
			<div class="formContainer">       		                 
				<div id="VendorForm" class="inputForm">
					<form action="index.cfm?event=Admin.Vendor.Submit" method="post" id="VendorEditForm">
						<cfoutput>
						<input type="hidden" name="VendorID" id="VendorID" value="<cfif Request.Vendor.VendorID GT 0>#Request.Vendor.VendorID#<cfelse>0</cfif>" />
						<input type="hidden" name="ReturnUrl" id="ReturnUrl" value="" />
						<ul class="form">                        
							<li>
								<label>Vendor Name:</label>
								<input type="text" class="textinput limitedField" name="VendorName" id="VendorName" value="#request.Vendor.VendorName#" />
							</li>
							<li>
								<label>Status:</label>
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