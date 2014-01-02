<cfparam name="URL.StudyGroupPostID" default="0" />

<!--- creating posts form the admin is now allowed, therefore form is only relevant for editing posts --->
<cfif URL.StudyGroupPostID EQ 0>
	<cflocation url="index.cfm?event=Admin.StudyGroupPost.Management" />
</cfif>


<cfinclude template="inc_Messages.cfm" />

<script type="text/javascript" src="/Javascript/StudyGroupPosts.js"></script>

<div class="TabbedPanels" id="TabbedPanels1">
<cfinclude template="inc_MainNavigation.cfm" />
	<div class="TabbedPanelsContentGroup">
		<div class="TabbedPanelsContent">
			<div class="formContainer">
				<div id="StudyGroupPostForm" class="inputForm">
					<form action="index.cfm?event=Admin.StudyGroupPost.Submit" method="post" id="StudyGroupPostEditForm">
						<cfoutput>
						<input type="hidden" name="StudyGroupPostID" id="StudyGroupPostID" value="<cfif Request.StudyGroupPost.ID GT 0>#Request.StudyGroupPost.ID#<cfelse>0</cfif>" />
						<input type="hidden" name="ReturnUrl" id="ReturnUrl" value="" />
						<h2 class="sectionTitle">Study Group Information</h2>
						<ul class="form">	
							<li>
								<label>User:</label>
								<span>#Request.StudyGroupPost.Username#</span>
							</li>
							<li>
								<label for="Type">Description:</label>
								<textarea name="Description">#Request.StudyGroupPost.Description#</textarea>
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
