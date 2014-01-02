<cfparam name="URL.MarketplaceCategoryID" default="0" />

<cfinclude template="inc_Messages.cfm" />

<script type="text/javascript" src="/Javascript/MarketplaceCategories.js"></script>

<div class="TabbedPanels" id="TabbedPanels1">
<cfinclude template="inc_MainNavigation.cfm" />
	<div class="TabbedPanelsContentGroup">
		<div class="TabbedPanelsContent">
			<div class="formContainer">
				<div id="MarketplaceCategoryForm" class="inputForm">
					<form action="index.cfm?event=Admin.MarketplaceCategory.Submit" method="post" id="MarketplaceCategoryEditForm">
						<cfoutput>
						<input type="hidden" name="IsBackEnd" value="1" />
						<input type="hidden" name="MarketplaceCategoryID" id="MarketplaceCategoryID" value="<cfif Request.MarketplaceCategory.ID GT 0>#Request.MarketplaceCategory.ID#<cfelse>0</cfif>" />
						<input type="hidden" name="ReturnUrl" id="ReturnUrl" value="" />
						<h2 class="sectionTitle">Marketplace Category Information</h2>
						<ul class="form">		
							<li>
								<label for="Title">Title:</label>
								<input type="text" class="textinput" name="Title" value="#Request.MarketplaceCategory.Title#" />
							</li>
							<li>
								<label for="Type">Description:</label>
								<textarea name="Description">#Request.MarketplaceCategory.Description#</textarea>
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
