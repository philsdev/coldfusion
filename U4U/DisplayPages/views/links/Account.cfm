<cfif Request.UserIsLoggedIn>
	<div class="module listModule">
		<h3><a href="/profile-edit.html">My Account:</a></h3>
		<div class="moduleContent">
			<ul>
            	<li><a href="/" title="">Account Homepage</a></li>
				<li><a href="/profile-edit.html" title="">Edit my profile</a></li>
				<li><a href="/password-change.html" title="">Change my password</a></li>
				<li><a href="/logout.html" title="">Log out</a></li>
				<li><a href="/profile-cancel-confirm.html" title="">Cancel Account</a></li>
			</ul>
		</div>
	</div>
</cfif>