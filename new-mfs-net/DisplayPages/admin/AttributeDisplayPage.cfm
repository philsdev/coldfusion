<cfparam name="URL.Message" default="" />
<cfparam name="URL.Tab" default="0" />
<cfparam name="URL.ProductAttributeID" default="0" />

<cfscript>

	switch(URL.Message) {	
		case "Attribute.Updated": {
			variables.Message = "Your attribute was updated";	
			break;
		}
		case "Attribute.Added": {
			variables.Message = "Your attribute was added";	
			break;
		}
		default: {
			variables.Message = "";	
		}	
	}
	
</cfscript>

<cfinclude template="inc_Messages.cfm" />

<script type="text/javascript" src="/Javascript/Attributes.js"></script>

<div class="TabbedPanels" id="TabbedPanels1">
<cfinclude template="Attributes/inc_MainNavigation.cfm" />
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
