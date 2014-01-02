<cfparam name="URL.AdvertisementID" default="0" />

<cfinclude template="inc_Messages.cfm" />

<script type="text/javascript" src="/Javascript/Advertisements.js"></script>

<div class="TabbedPanels" id="TabbedPanels1">
<cfinclude template="inc_MainNavigation.cfm" />
	<div class="TabbedPanelsContentGroup">
		<div class="TabbedPanelsContent">
			<div class="formContainer">
				<div id="AdvertisementForm" class="inputForm">
					<form action="index.cfm?event=Admin.Advertisement.Submit" method="post" id="AdvertisementEditForm" enctype="multipart/form-data">
						<cfoutput>
						<input type="hidden" name="IsBackEnd" value="1" />
						<input type="hidden" name="AdvertisementID" id="AdvertisementID" value="<cfif Request.Advertisement.ID GT 0>#Request.Advertisement.ID#<cfelse>0</cfif>" />
						<input type="hidden" name="ReturnUrl" id="ReturnUrl" value="" />
						<h2 class="sectionTitle">Advertisement Information</h2>
						<ul class="form">		
							<li>
								<label for="Title">Title:</label>
								<input type="text" class="textinput" name="Title" value="#Request.Advertisement.Title#" />
							</li>
							<li>
								<label for="Type">Description:</label>
								<textarea name="Description">#Request.Advertisement.Description#</textarea>
							</li>
							<li>
								<label for="Type">Type:</label>
								#Request.TypeBox#
							</li>
							<li>
								<label for="Size">Size:</label>
								#Request.SizeBox#
							</li>
							<li>
								<label for="User">User:</label>
								#Request.UserBox#
							</li>
							<li>
								<label for="Image">Image:</label>
								<input type="file" class="textinput" name="Image" />
								<cfif LEN(request.CreativePath)>
									[ Creative on file:	
									<a href="#Request.CreativePath#" class="fancyUploadPreview">Original</a>
									]
								</cfif>
							</li>
							<li>
								<label>Is House Advertisement?</label>
								#Request.HouseAdBox#
							</li>
							<li>
								<label>Destination Url:</label>
								<input type="text" class="textinput" name="DestinationUrl" value="#Request.Advertisement.DestinationUrl#" />
							</li>
							<li>
								<label>Locations:</label>
								<table class="PermissionsTable">
								<cfloop query="request.Locations">
									<tr>
										<td class="input"><input type="checkbox" name="Location" value="#request.Locations.ID#" 
											<CFIF request.Locations.IsSelected>checked="checked"</CFIF> /></td>
										<td class="label">#request.Locations.Title#</td>
									</tr>
								</cfloop>
								</table>
							</li>
							<li>
								<label>Placements:</label>
								<table class="PermissionsTable">
								<cfloop query="request.Placements">
									<tr>
										<td class="input"><input type="checkbox" name="Placement" value="#request.Placements.ID#" 
											<CFIF request.Placements.IsSelected>checked="checked"</CFIF> /></td>
										<td class="label">#request.Placements.Title#</td>
									</tr>
								</cfloop>
								</table>
							</li>
							<li>
								<label for="Status">Status:</label>
								#request.StatusBox#
							</li>
						</ul>
						<h2 class="sectionTitle">Monetization</h2>
						<ul class="form">							
							<li>
								<label>Budget:</label>
								$ <input type="text" class="textinput" name="Budget" value="#Request.Advertisement.Budget#" />
							</li>
							<li>
								<label>Model:</label>
								#Request.MonetizationModelBox#
							</li>
							<li>
								<label>Cost Per Thousand Impressions:</label>
								$ <input type="text" class="textinput" name="CostPerThousandImpressions" id="CPM" value="#Request.Advertisement.CostPerThousandImpressions#" />
							</li>
							<li>
								<label>Cost Per Click:</label>
								$ <input type="text" class="textinput" name="CostPerClick" id="PPC" value="#Request.Advertisement.CostPerClick#" />
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
