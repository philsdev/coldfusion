<!------------------------------------------------------------------------------------------

	UserRecentActivity.cfm

------------------------------------------------------------------------------------------->

<cfscript>
	
	variables.AdminManager = Request.ListenerManager.GetListener( "AdminManager" );
	variables.LinkManager = Request.ListenerManager.GetListener( "LinkManager" );
	
</cfscript>

<div id="recentActvity" class="listing mb40">
	<header class="contentListHeader clearfix">
		<h2>Recent Activity</h2>
	</header>
	<section>
		<cfif Request.RecentActivity.RecordCount>
			<ul>
				<cfoutput query="Request.RecentActivity">
					<cfscript>
						switch(Request.RecentActivity.Section) {
							case "community": {
								variables.Action = "You posted in a community";
								variables.ItemLink = variables.LinkManager.GetCommunityLink( CommunityID:Request.RecentActivity.ID, CommunityTitle:Request.RecentActivity.Title );
								break;
							}
							case "deals": {
								variables.Action = "You posted a deal";
								variables.ItemLink = variables.LinkManager.GetDealLink( DealID:Request.RecentActivity.ID, DealTitle:Request.RecentActivity.Title );
								break;
							}
							case "events": {
								variables.Action = "You posted an event";
								variables.ItemLink = variables.LinkManager.GetEventLink( EventID:Request.RecentActivity.ID, EventTitle:Request.RecentActivity.Title );
								break;
							}
							case "jobs": {
								variables.Action = "You posted a job";
								variables.ItemLink = variables.LinkManager.GetJobLink( JobID:Request.RecentActivity.ID, JobTitle:Request.RecentActivity.Title );
								break;
							}
							case "marketplace": {
								variables.Action = "You posted an item in the marketplace";
								variables.ItemLink = variables.LinkManager.GetMarketplaceLink( MarketplaceID:Request.RecentActivity.ID, MarketplaceTitle:Request.RecentActivity.Title );
								break;
							}
							case "studygroup": {
								variables.Action = "You posted in a study group";
								variables.ItemLink = variables.LinkManager.GetStudyGroupLink( StudyGroupID:Request.RecentActivity.ID, StudyGroupTitle:Request.RecentActivity.Title );
								break;
							}
						}
					</cfscript>
					<li>
						<span class="activityDate">#Request.RecentActivity.ActionDate#:</span> 
						#variables.Action#:   
						<a href="#variables.ItemLink#" title="">"#Request.RecentActivity.Title#"</a>
					</li>
				</cfoutput>
			</ul>
		<cfelse>
			<p>You do not have any recent activity.</p>
		</cfif>
	</section>
</div>