<cfinclude template="inc_Messages.cfm" />

<script type="text/javascript" src="/Javascript/Emails.js"></script>

<div class="TabbedPanels" id="TabbedPanels1">
<cfinclude template="inc_MainNavigation.cfm" />
	<div class="TabbedPanelsContentGroup">
		<div class="TabbedPanelsContent">
		
			<div id="navigation" >
				<form action="javascript:void(0)" method="post" id="EmailSearch">
					<h2 class="sectionTitle">Search E-mails</h2>
					<ul class="form">
						<li>
							<label>E-mail:</label>
							<input type="text"  name="Title" value=""  />
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
				<div class="formContainer"><cfoutput>#Request.EmailGrid#</cfoutput></div>
			</div>
			
		</div>
	</div>
</div>