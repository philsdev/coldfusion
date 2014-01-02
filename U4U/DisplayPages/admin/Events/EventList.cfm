<cfinclude template="inc_Messages.cfm" />

<script type="text/javascript" src="/Javascript/Events.js"></script>

<div class="TabbedPanels" id="TabbedPanels1">
<cfinclude template="inc_MainNavigation.cfm" />
	<div class="TabbedPanelsContentGroup">
		<div class="TabbedPanelsContent">
		
			<div id="navigation" >
				<form action="javascript:void(0)" method="post" id="EventSearch">
					<h2 class="sectionTitle">Search Events</h2>
					<ul class="form">
						<li>
							<label>Title:</label>
							<input type="text" name="Title" value=""  />
						</li>
						<li>
							<label>School:</label>
							<cfoutput>#Request.SchoolBox#</cfoutput>
						</li>
						<li>
							<label>Category:</label>
							<cfoutput>#Request.CategoryBox#</cfoutput>
						</li>
						<li>
							<label>Organizer:</label>
							<input type="text" name="Organizer" value=""  />
						</li>
						<li>
							<label>City:</label>
							<input type="text" name="City" value=""  />
						</li>
						<li>
							<label>State:</label>
							<cfoutput>#Request.StateBox#</cfoutput>
						</li>
						<li>
							<label>Start Date:</label>
							<input type="text" name="StartDate" value="" class="datepicker"  />
						</li>
						<li>
							<label>End Date:</label>
							<input type="text" name="EndDate" value="" class="datepicker"  />
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
				<div class="formContainer"><cfoutput>#Request.EventGrid#</cfoutput></div>
			</div>
			
		</div>
	</div>
</div>