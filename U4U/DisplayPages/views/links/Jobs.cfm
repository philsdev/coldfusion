<!--- TODO: determine strategy for user access (right now only U4U will post jobs) 
	<cfif Request.UserIsLoggedIn>
		<cfset variables.LinkManager = Request.ListenerManager.GetListener( "LinkManager" ) />
		<cfset variables.MyJobs = variables.LinkManager.GetJobUserLink( UserID:Request.UserID, Username:Request.Username ) />

		<div class="module listModule">
			<h3><a href="/jobs.html">Jobs:</a></h3>
			<ul>
				<li><a href="/job-post.html" title="">Post a Job</a></li>
				<li><a href="<cfoutput>#variables.MyJobs#</cfoutput>" title="">My Jobs</a></li>
			</ul>
		</div>
	<cfelse>
		<div class="module coloredModule shadowed">
		  <div class="moduleContent ">
		  <h3 class="tac">Looking to hire?</h3><p>Get your employment opportunities in front well qualified Boston area college students! <a href="contact-us.html">Contact us</a> for more information</a></p>
		  <div class="tac"><a href="/job-post.html" class="button accout actionButton db ">Contact Us</a></div>
		  </div>
	  </div>
	</cfif>
--->