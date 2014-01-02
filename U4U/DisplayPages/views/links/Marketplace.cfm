<cfif Request.UserIsLoggedIn>
	<cfset variables.LinkManager = Request.ListenerManager.GetListener( "LinkManager" ) />
	<cfset variables.MyMarketplaceItems = variables.LinkManager.GetMarketplaceUserLink( UserID:Request.UserID, Username:Request.Username ) />

	<div class="module listModule">
		<h3><a href="/marketplace.html">Marketplace:</a></h3>
		<ul>
			<li><a href="/marketplace-post.html" title="">Post an item in the marketplace</a></li>
			<li><a href="<cfoutput>#variables.MyMarketplaceItems#</cfoutput>" title="">My marketplace items</a></li>
		</ul>
	</div>
<cfelse>
	 <div class="module coloredModule shadowed calltoActionMod ">
          <div class="moduleContent">
          <h3 class="tac">Looking to Sell?</h3>
          <p>U4U offers a marketplace with thousands of students seeking the best prices on goods and services.</p>
          <div class="tac"><a href="/marketplace-post.html" class="button accout actionButton db ">Post an Item</a></div>
          </div>
  	</div>
</cfif>