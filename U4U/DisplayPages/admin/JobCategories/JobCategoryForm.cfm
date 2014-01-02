<cfparam name="URL.JobCategoryID" default="0" />

<cfinclude template="inc_Messages.cfm" />

<script type="text/javascript" src="/Javascript/JobCategories.js"></script>

<div class="TabbedPanels" id="TabbedPanels1">
<cfinclude template="inc_MainNavigation.cfm" />
	<div class="TabbedPanelsContentGroup">
		<div class="TabbedPanelsContent">
			<div class="formContainer">
				<div id="JobCategoryForm" class="inputForm">
					<form action="index.cfm?event=Admin.JobCategory.Submit" method="post" id="JobCategoryEditForm">
						<cfoutput>
						<input type="hidden" name="IsBackEnd" value="1" />
						<input type="hidden" name="JobCategoryID" id="JobCategoryID" value="<cfif Request.JobCategory.ID GT 0>#Request.JobCategory.ID#<cfelse>0</cfif>" />
						<input type="hidden" name="ReturnUrl" id="ReturnUrl" value="" />
						<h2 class="sectionTitle">Party Information</h2>
						<ul class="form">		
							<li>
								<label for="Title">Title:</label>
								<input type="text" class="textinput" name="Title" value="#Request.JobCategory.Title#" />
							</li>
							<li>
								<label for="Type">Description:</label>
								<textarea name="Description">#Request.JobCategory.Description#</textarea>
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
