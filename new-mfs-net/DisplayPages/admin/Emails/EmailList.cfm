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
							<input type="text"  name="Email" value=""  />
						</li>
						<li>
							<label>Name:</label>
							<input type="text"  name="EmailName" value=""  />
						</li>
						<li>
							<label>Source:</label>
							<cfoutput>#Request.SourceBox#</cfoutput>
						</li>
						<li>
							<label>Subscribed:</label>
							<cfoutput>#Request.IsSubscribedBox#</cfoutput>
						</li>
						<li>
							<label>Start Date:</label>
							<cfoutput><input id="StartDate" class="textinput datepicker" type="text" value="#DateFormat(dateAdd('m',  '-1',  now()),'mm/dd/yyyy')#" name="StartDate" style="width: 100px;"></cfoutput>
						</li>
						<li>
							<label>End Date:</label>
							<cfoutput><input id="EndDate" class="textinput datepicker" type="text" value="#DateFormat(now(),'mm/dd/yyyy')#" name="EndDate" style="width: 100px;"></cfoutput>
						</li>
						<li>
							<label>Sort:</label>
							<cfoutput>#Request.SortBox#</cfoutput>
						</li>
						<li>
							<label>Order:</label>
							<cfoutput>#Request.SordBox#</cfoutput>
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