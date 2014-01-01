<cfparam name="URL.Message" default="" />
<cfparam name="URL.Tab" default="0" />
<cfparam name="URL.DealerID" default="0" />

<cfscript>

	switch(URL.Message) {	
		case "Corporate.Updated": {
			variables.Message = "Your Corporate account was updated";	
			break;
		}
		case "Corporate.Added": {
			variables.Message = "Your Corporate account was added";	
			break;
		}
		case "Billing.Added": {
			variables.Message = "Your Corporate Billing was added";	
			break;
		}
		case "Billing.Updated": {
			variables.Message = "Your Corporate Billing was updated";	
			break;
		}
		case "Shipping.Added": {
			variables.Message = "Your Corporate Shipping was added";	
			break;
		}
		case "Shipping.Updated": {
			variables.Message = "Your Corporate Shipping was updated";	
			break;
		}
	default: {
			variables.Message = "";	
		}	
	}
	
	variables.Tabs = ArrayNew(1);
	
	variables.Tabs[1] = StructNew();	
	variables.Tabs[1].title = "Details";
	variables.Tabs[1].eventList = "Admin.Corporate.Information";
	
	variables.Tabs[2] = StructNew();
	variables.Tabs[2].title = "Billing";
	variables.Tabs[2].eventList = "Admin.Corporate.Billing.Management";
	
	variables.Tabs[3] = StructNew();
	variables.Tabs[3].title = "Shipping";
	variables.Tabs[3].eventList = "Admin.Corporate.Shipping.Management";
	
	variables.TabStates = StructNew();
	variables.TabStates.active = "ui-state-default ui-corner-top ui-tabs-selected ui-state-active";
	variables.TabStates.inactive = "ui-state-default ui-corner-top";
	
</cfscript>

<script type="text/javascript">
	var __DealerID = <cfoutput>#URL.DealerID#</cfoutput>;
	var __ProductImageValidExtensionList = '<cfoutput>#REQUEST.Image.ValidExtensionList#</cfoutput>';
	CurrentTabIndex = 0;
	
	<cfif LEN(variables.Message)>
		$().ready( function() {
			showMessage('<cfoutput>#variables.Message#</cfoutput>');
		});
	</cfif>
</script>
<!---script type="text/javascript" src="/Javascript/Products.js"></script--->

<div class="TabbedPanels" id="TabbedPanels1">
<cfinclude template="Corporate/inc_MainNavigation.cfm" />
	<div class="TabbedPanelsContentGroup">
		<div class="TabbedPanelsContent">			
	
			<p class="message" style="display:none"></p>		
			
			<div id="account-tabs" class="ui-tabs ui-widget ui-widget-content ui-corner-all">
				<ul class="ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-all">
					<cfoutput>
						<cfloop from="1" to="#ArrayLen(variables.Tabs)#" index="variables.thisTab">
							<cfif StructKeyExists( URL, "Event" ) AND ListFindNoCase( variables.Tabs[variables.thisTab].eventList, URL.Event )>
								<cfset variables.TabState = variables.TabStates.active />
							<cfelse>
								<cfset variables.TabState = variables.TabStates.inactive />
							</cfif>
							<li class="#variables.TabState#">
								<a href="index.cfm?event=#ListFirst(variables.Tabs[variables.thisTab].eventList)#&DealerID=#URL.DealerID#">#variables.Tabs[variables.thisTab].title#</a>
							</li>
						</cfloop>
					</cfoutput>
				</ul>
			</div>
			
			<div class="TabbedPanelsContentSubGroup">
				<div class="TabbedPanelsSubContent">		
					<div class="formSubContainer">
						<cfoutput>#request.productContent#</cfoutput>
					</div>
				</div>
			</div>
			
		</div>		
	</div>
</div>
