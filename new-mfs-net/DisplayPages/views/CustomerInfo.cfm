<cfscript>
	variables.LinkManager = Request.ListenerManager.GetListener( "LinkManager" );
</cfscript>
<!------------------------------------------------------------------------------------------

	CustomerInfo.cfm
	my-account.html

------------------------------------------------------------------------------------------->


<div id="breadcrumb">
	<a href="/" title="">Home</a>
	<span><cfif SESSION.User.UserType eq 1>
						Customer Account
					<cfelseif SESSION.User.UserType eq 2>
						Corporate Account
					</cfif></span>
</div>
	
<!-- contentContainer nessesary for liquid layouts with static and percentage columns -->
<aside id="sidebar">
	<div class="sideModule navModule module">
		<h3>Module Title</h3>
		<div class="moduleContent">
			<p>Put sidebar content here.</p>
		</div>
	</div>	
</aside>

<cfif IsDefined("SESSION.User.LoggedIN") and SESSION.User.LoggedIN eq 1>

<div id="contentContainer">
	<div id="content" class="contentSection">
		<h1>My Account</h1>
			
	<p>
	<a class="checkoutIcon" href="/view-account-info.html">Edit Your Account</a>
	<br>Change your personal information including:
	<ul>
  		<li>Username and Password</li>
  		<li>Shipping Information</li>
  		<li>Billing Information</li>
  		<li>Payment Information</li>
	</ul>

	<p>
	<a class="checkoutIcon" href="/track-orders.html">Track Your Orders</a>
	<br>View your current orders and check order status.

	<p>
	<a class="checkoutIcon" href="/view-orders.html">View Your Order History</a>
	<br>View all orders placed with your account. In this section you can copy an old order and place it again.
	
	<p>
	<a class="checkoutIcon" href="/view-registry.html">View Your Registry/Wishlist</a>
	<br>View your gift registry/wishlist.
	
	<!--- <p>
	<a class="checkoutIcon" href="/view-wishlist.html">View Your Wishlist</a>
	<br>View your current wishlist. --->
	
	<p>
	<a class="checkoutIcon" href="/logout.html">Logout of Your Account</a>
			
	</div>
	
<cfelse>
	<p>This page is not available to you.  Please login to see you account information.
</cfif>	
</div>

