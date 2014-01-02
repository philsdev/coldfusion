<cfif Request.UserIsDealer>
	
	<cfif Request.UserIsLoggedIn>
		<cfset variables.LinkManager = Request.ListenerManager.GetListener( "LinkManager" ) />
		<cfset variables.MyDeals = variables.LinkManager.GetDealUserLink( UserID:Request.UserID, Username:Request.Username ) />

		<div class="module listModule">
			<div class="moduleContent">
				<h3><a href="/deals.html">Deals:</a></h3>
				<ul>
					<li><a href="/deal-post.html" title="">Post a Deal</a></li>
					<li><a href="<cfoutput>#variables.MyDeals#</cfoutput>" title="">My Deals</a></li>
				</ul>
			</div>
		</div>		
	<cfelse>
		<div class="module coloredModule shadowed ">
			<div class="moduleContent ">
				<h3 class="tac">Post a Deal</h3>
				<p>Everyone's looking for a great! Epecially college students. 
				If your company has a special offer running, this is place to post it to get people in the door. 
				<a href="contact-us.html">Contact us for more information</a></p>
				<div class="tac">
					<a href="/deal-post.html" class="button accout actionButton db tac">Post a Deal!</a>
				</div>
			</div>
		</div>
	</cfif>

<cfelse>

	<div class="module coloredModule shadowed ">
		<div class="moduleContent ">
			<h3 class="tac">Post a Deal</h3>
			<p>Everyone's looking for a great deal! Epecially college students. 
			If your company has a special offer running, this is place to post it to get people in the door. 
			<a href="contact-us.html">Contact us for more information.</a></p>
			<div class="tac">
				<a href="/advertise-with-us.html" class="button accout actionButton db tac" >Find Out More!</a>
			</div>
		</div>
	</div>
      
</cfif>