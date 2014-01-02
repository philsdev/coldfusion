<cfif Request.UserIsLoggedIn>
	<cfset variables.LinkManager = Request.ListenerManager.GetListener( "LinkManager" ) />
	<cfset variables.MyCommunities = variables.LinkManager.GetCommunityUserLink( UserID:Request.UserID, Username:Request.Username ) />
	<div class="module listModule">
		<h3><a href="/community.html">Community:</a></h3>
		<ul>
        	<li><a href="/community-create.html" title="">Create a Community</a></li>
			<li><a href="<cfoutput>#variables.MyCommunities#</cfoutput>" title="">My Communities</a></li>
		</ul>
	</div>
</cfif>