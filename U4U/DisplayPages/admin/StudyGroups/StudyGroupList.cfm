<cfinclude template="inc_Messages.cfm" />

<script type="text/javascript" src="/Javascript/StudyGroups.js"></script>

<div class="TabbedPanels" id="TabbedPanels1">
<cfinclude template="inc_MainNavigation.cfm" />
	<div class="TabbedPanelsContentGroup">
		<div class="TabbedPanelsContent">
		
			<div id="navigation" >
				<form action="javascript:void(0)" method="post" id="StudyGroupSearch">
					<h2 class="sectionTitle">Search Study Groups</h2>
					<ul class="form">
						<li>
							<label>Title:</label>
							<input type="text" name="Title" value=""  />
						</li>
						<li>
							<label>School:</label>
							<cfoutput>#Request.SchoolBox#</cfoutput>
						</li>
						<li id="CourseNode" style="display:none">
							<label>Course:</label>
							<span id="CourseOptionsContainer"></span>
						</li>
						<li id="UsernameNode" style="display:none">
							<label>Username:</label>
							<span id="UsernameOptionsContainer"></span>
						</li>
						<li>
							<label>Status:</label>
							<cfoutput>#Request.StatusBox#</cfoutput>
						</li>
						<li>
							<label>Sort:</label>
							<cfoutput>#Request.SortBox#</cfoutput>
						</li>
					</ul>
					<div class="submitButtonContainer mb10">
						<button>Submit</button>
					</div>
				</form>
			</div>
			
			<div id="content">
				<div class="formContainer"><cfoutput>#Request.StudyGroupGrid#</cfoutput></div>
			</div>
			
		</div>
	</div>
</div>