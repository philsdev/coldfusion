<cfparam name="URL.Message" default="" />
<cfparam name="URL.Tab" default="0" />
<cfparam name="URL.ProductID" default="0" />

<cfscript>

	switch(URL.Message) {	
		case "Product.Updated": {
			variables.Message = "Your product was updated";	
			break;
		}
		case "Product.Added": {
			variables.Message = "Your product was added";	
			break;
		}
		case "Option.Added": {
			variables.Message = "Your option was added";	
			break;
		}
		case "Option.Updated": {
			variables.Message = "Your option was updated";	
			break;
		}
		case "Option.Deleted": {
			variables.Message = "Your option was deleted";	
			break;
		}
		default: {
			variables.Message = "";	
		}	
	}
	
	variables.Tabs = ArrayNew(1);
	
	variables.Tabs[1] = StructNew();	
	variables.Tabs[1].title = "Details";
	variables.Tabs[1].eventList = "Admin.Product.Information";
	
	variables.Tabs[2] = StructNew();
	variables.Tabs[2].title = "Categories";
	variables.Tabs[2].eventList = "Admin.Product.Category.Management";
	
	variables.Tabs[3] = StructNew();
	variables.Tabs[3].title = "Options";
	variables.Tabs[3].eventList = "Admin.Product.Option.Management";
	
	variables.Tabs[4] = StructNew();
	variables.Tabs[4].title = "Images";
	variables.Tabs[4].eventList = "Admin.Product.Image.Management,Admin.Product.Image.Information";
	
	variables.Tabs[5] = StructNew();
	variables.Tabs[5].title = "Descriptions";
	variables.Tabs[5].eventList = "Admin.Product.Description.Information";
	
	variables.Tabs[6] = StructNew();
	variables.Tabs[6].title = "Keywords";
	variables.Tabs[6].eventList = "Admin.Product.Keyword.Information";
	
	variables.Tabs[7] = StructNew();
	variables.Tabs[7].title = "Upsells";
	variables.Tabs[7].eventList = "Admin.Product.Upsell.Information";
		
	variables.Tabs[8] = StructNew();
	variables.Tabs[8].title = "Videos";
	variables.Tabs[8].eventList = "Admin.Product.Video.Management,Admin.Product.Video.Information";
	
	variables.Tabs[9] = StructNew();
	variables.Tabs[9].title = "Reviews";
	variables.Tabs[9].eventList = "Admin.Product.Review.Management,Admin.Product.Review.Information";
	
	variables.TabStates = StructNew();
	variables.TabStates.active = "ui-state-default ui-corner-top ui-tabs-selected ui-state-active";
	variables.TabStates.inactive = "ui-state-default ui-corner-top";
	
</cfscript>

<script type="text/javascript">
	var __ProductID = <cfoutput>#URL.ProductID#</cfoutput>;
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
<cfinclude template="products/inc_MainNavigation.cfm" />
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
								<a href="index.cfm?event=#ListFirst(variables.Tabs[variables.thisTab].eventList)#&ProductID=#URL.ProductID#">#variables.Tabs[variables.thisTab].title#</a>
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
