<cfif Request.UserIsLoggedIn>
	<cfscript>
		variables.AdminManager = Request.ListenerManager.GetListener( "AdminManager" );
		variables.ItemThumbnailPath = variables.AdminManager.GetItemThumbnail( ItemKey:"user", ItemID:Request.UserID );
		variables.ItemFullSizePath = variables.AdminManager.GetItemFullSize( ItemKey:"user", ItemID:Request.UserID );
	</cfscript>
	<div class="module" id="module-userInfo">
		<div class="moduleContent">
			<ul class="contentList imageList userInfo clearfix" >
				<li>
					<a href="<cfoutput>#variables.ItemFullSizePath#</cfoutput>" class="fancy"><img src="<cfoutput>#variables.ItemThumbnailPath#</cfoutput>" class="itemImage" /></a>
					<dl class="meta">
						<dd class="welcome">Welcome, <cfoutput>#Request.Username#</cfoutput></dd>
						<dd class="college">College: <cfoutput>#Request.SchoolName#</cfoutput></dd>
						<dd class="accountLinks"><a href="/profile-edit.html">Edit Profile</a> | <a href="/profile-avatar.html">Change Picture</a></dd>
					</dl>
				</li>
			</ul>
		</div>
	</div>
</cfif>