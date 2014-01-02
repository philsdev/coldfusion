<cfinclude template="inc_Messages.cfm" />

<script type="text/javascript" src="/Javascript/Pages.js"></script>

<div class="TabbedPanels" id="TabbedPanels1">
<cfinclude template="inc_MainNavigation.cfm" />
	<div class="TabbedPanelsContentGroup">
		<div class="TabbedPanelsContent">
		
			<div id="navigation" >
				<form action="javascript:void(0)" method="post" id="PageSearch">
					<h2 class="sectionTitle">Search Pages</h2>
					<ul class="form">
						<li>
							<label>Page Title:</label>
							<input type="text" name="PageTitle" value=""  />
						</li>
						<li>
							<label>Search Title:</label>
							<input type="text" name="SearchTitle" value=""  />
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
				<div class="formContainer"><cfoutput>#Request.PageGrid#</cfoutput></div>
			</div>
			
		</div>
	</div>
</div>