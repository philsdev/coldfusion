<cfif Request.UserIsLoggedIn>
	<cfset variables.LinkManager = Request.ListenerManager.GetListener( "LinkManager" ) />
	<cfset variables.MyEvents = variables.LinkManager.GetEventUserLink( UserID:Request.UserID, Username:Request.Username ) />

	<div class="module listModule">
		<h3><a href="/events.html">Events:</a></h3>
		<ul>
			<li><a href="/event-post.html" title="">Post an Event</a></li>
			<li><a href="<cfoutput>#variables.MyEvents#</cfoutput>" title="">My Events</a></li>
		</ul>
	</div>
<cfelse>
	<div class="module coloredModule shadowed ">
		<div class="moduleContent ">
			<h3 class="tac">Hosting an Event?</h3>
			<p>Big or small, <strong>let U4U spread the word about your next gathering</strong>.
			<a href="login.html">log in</a> or <a href="#request.root.web#">Sign up</a> and let your fellow students know where to go!
			</p>
			<div class="tac">
				<a href="/event-post.html" class="button accout actionButton db " class="db tac ">Post an Event!</a>
			</div>
		</div>
	</div>
</cfif>