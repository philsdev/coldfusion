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
	<p>
	You are now signed out of your account.
	<p>
	Thank you for visiting MatthewFSheehan.com
		
	<p>
	<a class="checkoutIcon" href="/">Return to Homepage</a>
	
	<p>
	<a class="checkoutIcon" href="/login.html">Login</a>
			
	</div>
</div>

