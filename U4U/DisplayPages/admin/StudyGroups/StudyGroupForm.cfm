<cfparam name="URL.StudyGroupID" default="0" />

<cfinclude template="inc_Messages.cfm" />

<script type="text/javascript" src="/Javascript/StudyGroups.js"></script>

<div class="TabbedPanels" id="TabbedPanels1">
<cfinclude template="inc_MainNavigation.cfm" />
	<div class="TabbedPanelsContentGroup">
		<div class="TabbedPanelsContent">
			<div class="formContainer">
				<div id="StudyGroupForm" class="inputForm">
					<form action="index.cfm?event=Admin.StudyGroup.Submit" method="post" id="StudyGroupEditForm">
						<cfoutput>
						<input type="hidden" name="IsBackEnd" value="1" />
						<input type="hidden" name="StudyGroupID" id="StudyGroupID" value="<cfif Request.StudyGroup.ID GT 0>#Request.StudyGroup.ID#<cfelse>0</cfif>" />
						<input type="hidden" name="ReturnUrl" id="ReturnUrl" value="" />
						<h2 class="sectionTitle">Study Group Information</h2>
						<ul class="form">		
							<li>
								<label for="Title">Title:</label>
								<input type="text" class="textinput" name="Title" value="#Request.StudyGroup.Title#" />
							</li>
							<li>
								<label for="Type">Description:</label>
								<textarea name="Description">#Request.StudyGroup.Description#</textarea>
							</li>
							<li>
								<label>School:</label>
								#Request.SchoolBox#
							</li>
							<li id="CourseNode">
								<label>Course:</label>
								<span id="CourseOptionsContainer">#Request.CourseBox#</span>
							</li>
							<li>
								<label>User:</label>
								#Request.UserBox#
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
