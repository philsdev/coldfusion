 <script type="text/javascript" src="/Javascript/Features.js"></script>

<cfinclude template="inc_Messages.cfm" /> 


<div class="TabbedPanels" id="TabbedPanels1">
<cfinclude template="inc_MainNavigation.cfm" />
	<div class="TabbedPanelsContentGroup">
		<div class="TabbedPanelsContent">
			<div id="CategoryForm" class="inputForm">

			<form action="index.cfm?event=Admin.Feature.Submit" method="post" id="FeatureEditForm">
				
				<input type="hidden" name="ReturnUrl" id="ReturnUrl" value="" />
				<ul class="form">
					<li>
						<label>Available Categories:</label>
						<select multiple="multiple" size="10" class="textinput" id="AvailableCategories">
							<cfoutput query="request.AvailableCategories" group="Category1ID">
								<option value="#request.AvailableCategories.Category1ID#">#request.AvailableCategories.Category1Name#</option>
								<cfoutput group="Category2ID">
								<cfif Level1Count GT 0>
									<option value="#request.AvailableCategories.Category2ID#">#request.AvailableCategories.Category2NameIndent#</option>
									<cfif Level2Count GT 0>
										<cfoutput>
										<option value="#request.AvailableCategories.Category3ID#">#request.AvailableCategories.Category3NameIndent#</option>
										</cfoutput>
									</cfif>
								</cfif>
								</cfoutput>
							</cfoutput>
						</select>
					</li>
					<li>
						<label>&nbsp;</label>
						<span class="ButtonLinks">
							<a class="OptionAdd">Add</a>
						</span>
					</li>
					<li>
						<label>Selected Categories:</label>
						<select size="10" class="textinput" name="SelectedProductID" id="SelectedProducts">
							<cfoutput query="request.Features">
								<option value="#request.Features.CategoryID#">#request.Features.CategoryName#</option>
							</cfoutput>
						</select>
					</li>
					<li>
						<label>&nbsp;</label>
						<span class="ButtonLinks">
							<a class="OptionRemove">Remove</a>
							<a class="OptionMoveUp">Move Up</a>
							<a class="OptionMoveDown">Move Down</a>
						</span>
					</li>
				</ul>
				<div class="submitButtonContainer">
					<button type="button" class="cancel">Cancel</button>
					<button type="submit" class="stay">Save and Keep Editing</button>
				</div>
				
			</form>

			</div>
		</div>
	</div>
</div>