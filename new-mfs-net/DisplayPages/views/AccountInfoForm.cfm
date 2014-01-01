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

<cfif IsDefined("SESSION.User.LoggedIN") and SESSION.User.LoggedIN eq 1>	
<div id="contentContainer">
	<div id="content" class="contentSection">
		<h1>My Account</h1>
			
	<p>
	<a class="checkoutIcon" href="/">Edit Your Account</a>
	
	<p>
	<a class="checkoutIcon" href="/">Track Your Orders</a>
	
	<p>
	<a class="checkoutIcon" href="/">View Your Order History</a>
	
	<p>
	<a class="checkoutIcon" href="/">View Your Registry/WishList</a>
	
	<p>
	<a class="checkoutIcon" href="/logout.html">Logout of Your Account</a>
			
	</div>
</div>

<cfelse>
	<p>This page is not available to you.  Please login to see you account information.
</cfif>	
