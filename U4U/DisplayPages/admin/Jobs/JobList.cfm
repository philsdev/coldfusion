<cfinclude template="inc_Messages.cfm" />

<script type="text/javascript" src="/Javascript/Jobs.js"></script>

<div class="TabbedPanels" id="TabbedPanels1">
<cfinclude template="inc_MainNavigation.cfm" />
	<div class="TabbedPanelsContentGroup">
		<div class="TabbedPanelsContent">
		
			<div id="navigation" >
				<form action="javascript:void(0)" method="post" id="JobSearch">
					<h2 class="sectionTitle">Search Jobs</h2>
					<ul class="form">
						<li>
							<label>Title:</label>
							<input type="text"  name="Title" value=""  />
						</li>
						<li>
							<label>Company Name:</label>
							<input type="text"  name="CompanyName" value=""  />
						</li>
						<li>
							<label>Contact Name:</label>
							<input type="text"  name="ContactName" value=""  />
						</li>
						<li>
							<label>Reply E-mail:</label>
							<input type="text"  name="ReplyEmail" value=""  />
						</li>
						<li>
							<label>Category:</label>
							<cfoutput>#Request.CategoryBox#</cfoutput>
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
				<div class="formContainer"><cfoutput>#Request.JobGrid#</cfoutput></div>
			</div>
			
		</div>
	</div>
</div>