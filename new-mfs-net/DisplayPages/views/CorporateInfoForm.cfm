<cfscript>
	variables.LinkManager = Request.ListenerManager.GetListener( "LinkManager" );
</cfscript>
<!------------------------------------------------------------------------------------------

	LoginForm.cfm
	login.html

------------------------------------------------------------------------------------------->


<div id="breadcrumb">
	<a href="/" title="">Home</a>
	<span>Login</span>
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

	
<div id="contentContainer">
	<div id="content" class="contentSection">
		<h1>Corporate Account</h1>
			
	<p>
	<a class="checkoutIcon" href="/view-account-info.html">Edit Your Account</a>
	
	<p>
	<a class="checkoutIcon" href="/track-orders.html">Track Your Orders</a>
	
	<p>
	<a class="checkoutIcon" href="/view-orders.html">View Your Order History</a>
	
	<p>
	<a class="checkoutIcon" href="/view-registry.html">View Your Registry</a>
	
	<p>
	<a class="checkoutIcon" href="/view-wishlist.html">View Your Wishlist</a>
	
	<p>
	<a class="checkoutIcon" href="/logout.html">Logout of Your Account</a>
			
	</div>
</div>

