<cfparam name="URL.CourseID" default="0" />

<cfinclude template="inc_Messages.cfm" />

<script type="text/javascript" src="/Javascript/Courses.js"></script>

<div class="TabbedPanels" id="TabbedPanels1">
<cfinclude template="inc_MainNavigation.cfm" />
	<div class="TabbedPanelsContentGroup">
		<div class="TabbedPanelsContent">
			<div class="formContainer">
				<div id="CourseForm" class="inputForm">
					<form action="index.cfm?event=Admin.Course.Submit" method="post" id="CourseEditForm">
						<cfoutput>
						<input type="hidden" name="IsBackEnd" value="1" />
						<input type="hidden" name="CourseID" id="CourseID" value="<cfif Request.Course.ID GT 0>#Request.Course.ID#<cfelse>0</cfif>" />
						<input type="hidden" name="ReturnUrl" id="ReturnUrl" value="" />
						<h2 class="sectionTitle">Course Information</h2>
						<ul class="form">							
							<li>
								<label for="Type">School:</label>
								#Request.SchoolBox#
							</li>
							<li>
								<label for="Title">Title:</label>
								<input type="text" class="textinput" name="Title" value="#Request.Course.Title#" />
							</li>
							<li>
								<label for="Description">Description:</label>
								<textarea name="Description">#Request.Course.Description#</textarea>
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
