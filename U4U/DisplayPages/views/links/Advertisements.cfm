<cfif Request.UserIsAdvertiser>

	<cfif Request.UserIsLoggedIn>
		<div class="module listModule">
			<div class="moduleContent">
				<h3>Advertisements:</h3>
				<ul>
					<li><a href="/my-advertisements.html" title="">My Advertisements</a></li>
				</ul>
			</div>
		</div>
	</cfif>
	
</cfif>