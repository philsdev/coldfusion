<!------------------------------------------------------------------------------------------

	LatestActivity.cfm

------------------------------------------------------------------------------------------->

<cfscript>
	
	variables.AdminManager = Request.ListenerManager.GetListener( "AdminManager" );
	
	variables.ShowAllButton = true;
	variables.AllButtonDestinationUrl = "/";
	
	switch( Request.Event.GetArg('Section') ) {
		case "deals": {
			variables.AllButtonDestinationUrl = "/deals.html";
			break;
		}
		case "events": {
			variables.AllButtonDestinationUrl = "/events.html";
			break;
		}
		case "jobs": {
			variables.AllButtonDestinationUrl = "/jobs.html";
			break;
		}
		case "marketplace": {
			variables.AllButtonDestinationUrl = "/marketplace.html";
			break;
		}
		/* "ALL" */
		default: {
			variables.ShowAllButton = false;
			break;
		}
	}
	
</cfscript>

<cfif Request.LatestActivity.RecordCount>
	
	<!--- HACK: since fancy box does not work with .live(), and this is page loaded via ajax, fancy box code needs to be here --->
	<script type="text/javascript">
		$().ready( function() {
			$(".fancyPopup").fancybox({
				'width':600,
				'height':'75%',
				'autoScale':false,
				'transitionIn':'none',
				'transitionOut':'none',
				'type':'iframe',
				'padding':0
			});
		});
	</script>
	
	<ul class="contentList imageList">
	<cfoutput query="Request.LatestActivity">
		<cfset Request.CurrentItem = variables.AdminManager.GetQueryRowAsStruct( InputQuery:Request.LatestActivity, RowIndex:Request.LatestActivity.CurrentRow ) />
		<cfset variables.ViewletName = "Viewlets." & Request.LatestActivity.Section />		
		<cfinclude template="#Request.ViewManager.getViewPath(variables.ViewletName)#" />
	</cfoutput>
	</ul>
	
	<footer class="contentListFooter">
		<cfif Request.GridTotals.Page LT Request.GridTotals.Total>
			<button class="button genericButton latestMore" nextPage="<cfoutput>#INT( Request.GridTotals.Page + 1 )#</cfoutput>">More...</button>
		</cfif>
		<cfif variables.ShowAllButton>
			<button class="button genericButton latestViewAll" destinationUrl="<cfoutput>#variables.AllButtonDestinationUrl#</cfoutput>">View All</button>
		</cfif>
	</footer>
<cfelse>
	<p>There is no latest activity.</p>
</cfif>

<cfsetting showdebugoutput="false" />