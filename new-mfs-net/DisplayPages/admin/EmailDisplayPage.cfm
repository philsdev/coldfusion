<cfparam name="URL.Message" default="" />
<cfparam name="URL.Tab" default="0" />
<cfparam name="URL.EmailID" default="0" />


<cfinclude template="inc_Messages.cfm" />

<script type="text/javascript" src="/Javascript/Email.js"></script>

<div class="TabbedPanels" id="TabbedPanels1">
<cfinclude template="Emails/inc_MainNavigation.cfm" />
	<div class="TabbedPanelsContentGroup">
		<div class="TabbedPanelsContent">			
	
			<p class="message" style="display:none"></p>		
			
			<div class="TabbedPanelsContentSubGroup">
				<div class="TabbedPanelsSubContent">		
					<div class="formSubContainer">
						<cfoutput>#request.Content#</cfoutput>
					</div>
				</div>
			</div>
			
		</div>		
	</div>
</div>
