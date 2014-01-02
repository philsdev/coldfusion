<cfparam name="URL.ItemID" default="0" />

<cfinclude template="inc_Messages.cfm" />

<script type="text/javascript" src="/Javascript/Marketplace.js"></script>

<div class="TabbedPanels" id="TabbedPanels1">
<cfinclude template="inc_MainNavigation.cfm" />
	<div class="TabbedPanelsContentGroup">
		<div class="TabbedPanelsContent">
			<div class="formContainer">
				<div id="MarketplaceForm" class="inputForm">
					<form action="index.cfm?event=Admin.Marketplace.Submit" method="post" enctype="multipart/form-data" id="MarketplaceEditForm">
						<cfoutput>
						<input type="hidden" name="ItemID" id="ItemID" value="<cfif Request.Item.ID GT 0>#Request.Item.ID#<cfelse>0</cfif>" />
						<input type="hidden" name="ReturnUrl" id="ReturnUrl" value="" />
						<h2 class="sectionTitle">Marketplace Information</h2>
						<ul class="form">		
							<li>
								<label for="Title">Title:</label>
								<input type="text" class="textinput" name="Title" value="#Request.Item.Title#" />
							</li>
							<li>
								<label for="Type">Description:</label>
								<textarea name="Description">#Request.Item.Description#</textarea>
							</li>
							<li>
								<label for="Category">Category:</label>
								#Request.CategoryBox#
							</li>
							<li>
								<label for="User">User:</label>
								#Request.UserBox#
							</li>
							<li>
								<label for="StartDate">Start Date:</label>
								<input type="text" class="textinput datepicker" name="StartDate" value="#Request.Item.StartDate#" />
							</li>
							<li>
								<label for="EndDate">End Date:</label>
								<input type="text" class="textinput datepicker" name="EndDate" value="#Request.Item.EndDate#" />
							</li>
							<li>
								<label for="Price">Price:</label>
								$ <input type="text" class="textinput" name="Price" value="#Request.Item.Price#" />
							</li>
							<li>
								<label for="Image">Image:</label>
								<input type="file" class="textinput" name="Image" />
								<cfif LEN(request.ItemFullsizePath)>
									Creative on file:	
									<a href="#Request.ItemOriginalPath#" class="fancyUploadPreview">[+] Original</a> |
									<a href="#Request.ItemThumbnailPath#" class="fancyUploadPreview">[+] Thumbnail</a> |
									<a href="#Request.ItemFullsizePath#" class="fancyUploadPreview">[+] Full size</a>
								</cfif>
							</li>
							<li>
								<label for="Status">Status:</label>
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
