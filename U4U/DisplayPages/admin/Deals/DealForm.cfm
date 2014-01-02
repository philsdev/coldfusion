<cfparam name="URL.DealID" default="0" />

<cfinclude template="inc_Messages.cfm" />

<script type="text/javascript" src="/Javascript/Deals.js"></script>

<div class="TabbedPanels" id="TabbedPanels1">
<cfinclude template="inc_MainNavigation.cfm" />
	<div class="TabbedPanelsContentGroup">
		<div class="TabbedPanelsContent">
			<div class="formContainer">
				<div id="DealForm" class="inputForm">
					<form action="index.cfm?event=Admin.Deal.Submit" method="post" enctype="multipart/form-data" id="DealEditForm">
						<cfoutput>
						<input type="hidden" name="DealID" id="DealID" value="<cfif Request.Deal.ID GT 0>#Request.Deal.ID#<cfelse>0</cfif>" />
						<input type="hidden" name="ReturnUrl" id="ReturnUrl" value="" />
						<h2 class="sectionTitle">Deal Information</h2>
						<ul class="form">							
							<li>
								<label for="Title">Title:</label>
								<input type="text" class="textinput" name="Title" value="#Request.Deal.Title#" />
							</li>
							<li>
								<label for="Description">Description:</label>
								<textarea name="Description">#Request.Deal.Description#</textarea>
							</li>
							<li>
								<label for="Category">Category:</label>
								#request.CategoryBox#
							</li>
							<li>
								<label for="User">User:</label>
								#request.UserBox#
							</li>
							<li>
								<label for="StartDate">Start Date:</label>
								<input type="text" class="textinput datepicker" name="StartDate" value="#Request.Deal.StartDate#" />
							</li>
							<li>
								<label for="EndDate">End Date:</label>
								<input type="text" class="textinput datepicker" name="EndDate" value="#Request.Deal.EndDate#" />
							</li>
							<li>
								<label>Destination URL:</label>
								<input type="text" class="textinput" name="DestinationUrl" value="#Request.Deal.DestinationUrl#" />
							</li>
							<li>
								<label for="Status">Status:</label>
								#request.StatusBox#
							</li>
						</ul>
						<h2 class="sectionTitle">Address</h2>
						<ul class="form">							
							<li>
								<label>Company Name:</label>
								<input type="text" class="textinput" name="AddressTitle" value="#Request.Deal.AddressTitle#" />
							</li>
							<li>
								<label>Street 1:</label>
								<input type="text" class="textinput" name="Street1" value="#Request.Deal.Street1#" />
							</li>
							<li>
								<label>Street 2:</label>
								<input type="text" class="textinput" name="Street2" value="#Request.Deal.Street2#" />
							</li>
							<li>
								<label>City:</label>
								<input type="text" class="textinput" name="City" value="#Request.Deal.City#" />
							</li>
							<li>
								<label>State:</label>
								#Request.StateBox#
							</li>
							<li>
								<label>ZIP Code:</label>
								<input type="text" class="textinput" name="ZipCode" value="#Request.Deal.ZipCode#" />
							</li>	
							<li>
								<label>Phone Number:</label>
								<input type="text" class="textinput" name="PhoneNumber" value="#Request.Deal.PhoneNumber#" />
							</li>
							<li>
								<label>URL:</label>
								<input type="text" class="textinput" name="URL" value="#Request.Deal.URL#" />
							</li>
						</ul>
						<h2 class="sectionTitle">Monetization</h2>
						<ul class="form">							
							<li>
								<label>Budget:</label>
								$ <input type="text" class="textinput" name="Budget" value="#Request.Deal.Budget#" />
							</li>
							<li>
								<label>Model:</label>
								#Request.MonetizationModelBox#
							</li>
							<li>
								<label>Cost Per Thousand Impressions:</label>
								$ <input type="text" class="textinput" name="CostPerThousandImpressions" id="CPM" value="#Request.Deal.CostPerThousandImpressions#" />
							</li>
							<li>
								<label>Cost Per Click:</label>
								$ <input type="text" class="textinput" name="CostPerClick" id="PPC" value="#Request.Deal.CostPerClick#" />
							</li>
						</ul>
						<h2 class="sectionTitle">Upload Creative</h2>
						<ul class="form">
							<li>
								<label>Image (.jpg):</label>
								<input type="file" class="textinput" name="Image" value="" />
								<cfif LEN(request.ItemFullsizePath)>
									[ Creative on file:	
									<a href="#Request.ItemOriginalPath#" class="fancyUploadPreview">Original</a> |
									<a href="#Request.ItemThumbnailPath#" class="fancyUploadPreview">Thumbnail</a> |
									<a href="#Request.ItemFullsizePath#" class="fancyUploadPreview">Full size</a> 
									]
								</cfif>
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