<cfparam name="URL.CommunityID" default="0" />

<cfinclude template="inc_Messages.cfm" />

<script type="text/javascript" src="/Javascript/Communities.js"></script>

<div class="TabbedPanels" id="TabbedPanels1">
<cfinclude template="inc_MainNavigation.cfm" />
	<div class="TabbedPanelsContentGroup">
		<div class="TabbedPanelsContent">
			<div class="formContainer">
				<div id="CommunityForm" class="inputForm">
					<form action="index.cfm?event=Admin.Community.Submit" method="post" id="CommunityEditForm">
						<cfoutput>
						<input type="hidden" name="CommunityID" id="CommunityID" value="<cfif Request.Community.ID GT 0>#Request.Community.ID#<cfelse>0</cfif>" />
						<input type="hidden" name="ReturnUrl" id="ReturnUrl" value="" />
						<h2 class="sectionTitle">Community Information</h2>
						<ul class="form">		
							<li>
								<label for="Title">Title:</label>
								<input type="text" class="textinput" name="Title" value="#Request.Community.Title#" />
							</li>
							<li>
								<label for="Type">Description:</label>
								<textarea name="Description">#Request.Community.Description#</textarea>
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
