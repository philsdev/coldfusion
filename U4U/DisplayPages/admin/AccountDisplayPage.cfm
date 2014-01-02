<cfparam name="URL.Message" default="" />
<cfparam name="URL.Tab" default="0" />
<cfparam name="URL.AccountID" default="0" />

<cfscript>

	switch(URL.Message) {	
		case "Account.Updated": {
			variables.Message = "Your account was updated";	
			break;
		}
		case "Account.Card.Updated": {
			variables.Message = "Your card was updated";	
			break;
		}
		case "Account.Card.Error": {
			variables.Message = "ERROR: Your card was not accepted!";	
			break;
		}
		case "Account.Location.Updated": {
			variables.Message = "Your location was updated";	
			break;
		}
		case "Account.Offer.Updated": {
			variables.Message = "Your offer was updated";	
			break;
		}
		default: {
			variables.Message = "";	
		}	
	}
	
	variables.Tabs = ArrayNew(1);
	
	variables.Tabs[1] = StructNew();	
	variables.Tabs[1].title = "Account Information";
	variables.Tabs[1].eventList = "Account.Information";
	
	variables.Tabs[2] = StructNew();
	variables.Tabs[2].title = "Locations";
	variables.Tabs[2].eventList = "Account.Locations,Account.Location.Form";
	
	variables.Tabs[3] = StructNew();
	variables.Tabs[3].title = "Offers";
	variables.Tabs[3].eventList = "Account.Offers,Account.Offer.Form";
	
	variables.Tabs[4] = StructNew();
	variables.Tabs[4].title = "Credit Cards";
	variables.Tabs[4].eventList = "Account.Cards,Account.Card.Form.Add,Account.Card.Form.Edit";
	
	variables.Tabs[5] = StructNew();
	variables.Tabs[5].title = "Report";
	variables.Tabs[5].eventList = "Account.Reports.CompanyName,Account.Reports.OfferName";
	
	variables.TabStates = StructNew();
	variables.TabStates.active = "ui-state-default ui-corner-top ui-tabs-selected ui-state-active";
	variables.TabStates.inactive = "ui-state-default ui-corner-top";
</cfscript>

<script type="text/javascript">
	var __AccountID = <CFOUTPUT>#URL.AccountID#</CFOUTPUT>;
	CurrentTabIndex = 0;
	
	<cfif LEN(variables.Message)>
		$().ready( function() {
			showMessage('<cfoutput>#variables.Message#</cfoutput>');
		});
	</cfif>
</script>
<script type="text/javascript" src="/Javascript/Accounts.js"></script>

<div class="TabbedPanels" id="TabbedPanels1">
<cfinclude template="accounts/inc_MainNavigation.cfm" />
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
								<a href="index.cfm?event=#ListFirst(variables.Tabs[variables.thisTab].eventList)#&AccountID=#URL.AccountID#">#variables.Tabs[variables.thisTab].title#</a>
							</li>
						</cfloop>
					</cfoutput>
				</ul>
			</div>
			
			<div class="TabbedPanelsContentSubGroup">
				<div class="TabbedPanelsSubContent">		
					<div class="formSubContainer">
						<cfoutput>#request.accountContent#</cfoutput>
					</div>
				</div>
			</div>
			
		</div>		
	</div>
</div>


<!--- cfdump var="#request#" --->