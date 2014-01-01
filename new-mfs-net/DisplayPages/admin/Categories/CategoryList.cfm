<cfinclude template="inc_Messages.cfm" />

<script type="text/javascript" src="/Javascript/Categories.js"></script>

<div class="TabbedPanels" id="TabbedPanels1">
<cfinclude template="inc_MainNavigation.cfm" />
	<div class="TabbedPanelsContentGroup">
		<div class="TabbedPanelsContent">
		
			<div id="navigation" >
				<form action="javascript:void(0)" method="post" id="CategorySearch">
					<h2 class="sectionTitle">Search Categories</h2>
					<ul class="form">
						<li>
							<label>Status:</label>
							<cfoutput>#request.StatusBox#</cfoutput>
						</li>
					</ul>
					<div class="submitButtonContainer mb10">
						<button>Submit</button>
					</div>
				</form>
			</div>
			
			<div id="content">
				<div class="formContainer"><cfoutput>#request.CategoryGrid#</cfoutput></div>
			</div>
			
		</div>
	</div>
</div>