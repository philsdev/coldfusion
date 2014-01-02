<cfif Request.UserIsLoggedIn>
	<cfset variables.LinkManager = Request.ListenerManager.GetListener( "LinkManager" ) />
	<cfset variables.UserManager = Request.ListenerManager.GetListener( "UserManager" ) />
	<cfset variables.IsSchoolUser = variables.UserManager.IsSchoolUser() />
	
	<cfif variables.IsSchoolUser>
		<cfset variables.MyStudyGroups = variables.LinkManager.GetStudyGroupUserLink( UserID:Request.UserID, Username:Request.Username ) />
		
		<div class="module listModule">
			<h3><a href="/study-groups.html">Study Groups</a></h3>
			<ul>
				<li><a href="<cfoutput>#variables.MyStudyGroups#</cfoutput>" title="">My Study Groups</a></li>
			</ul>
		</div>
	</cfif>
	
</cfif>