<cfparam name="URL.CommunityCategoryID" default="0" />

<cfinclude template="inc_Messages.cfm" />

<script type="text/javascript" src="/Javascript/CommunityCategories.js"></script>

<div class="TabbedPanels" id="TabbedPanels1">
<cfinclude template="inc_MainNavigation.cfm" />
	<div class="TabbedPanelsContentGroup">
		<div class="TabbedPanelsContent">
			<div class="formContainer">
				<div id="CommunityCategoryForm" class="inputForm">
					<form action="index.cfm?event=Admin.CommunityCategory.Submit" method="post" id="CommunityCategoryEditForm">
						<cfoutput>
						<input type="hidden" name="IsBackEnd" value="1" />
						<input type="hidden" name="CommunityCategoryID" id="CommunityCategoryID" value="<cfif Request.CommunityCategory.ID GT 0>#Request.CommunityCategory.ID#<cfelse>0</cfif>" />
						<input type="hidden" name="ReturnUrl" id="ReturnUrl" value="" />
						<h2 class="sectionTitle">Community Category Information</h2>
						<ul class="form">		
							<li>
								<label for="Title">Title:</label>
								<input type="text" class="textinput" name="Title" value="#Request.CommunityCategory.Title#" />
							</li>
							<li>
								<label for="Type">Description:</label>
								<textarea name="Description">#Request.CommunityCategory.Description#</textarea>
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
