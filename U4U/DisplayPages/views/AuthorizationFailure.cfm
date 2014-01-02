<!------------------------------------------------------------------------------------------

	AuthorizationFailure.cfm

------------------------------------------------------------------------------------------->

<cfoutput>

<div id="content">
	<div id="breadcrumb">
		<a href="/" title="">Home</a>
		<span>Authorization Failure</span>
	</div>
	
	<header class="contentListHeader clearfix">
		<h1>Authorization Failure!</h1>
	</header>
	
	<section class="listSection">
		<p>Sorry, your input did not pass our validation check.</p>
		<p><a class="button actionButton retry"><strong>Go Back</strong></a></p>
	</section>

</div>

<div id="sidebar">
	<div class="module">
		<div class="moduleContent">
			#Request.AdPlacementRight#
		</div>
	</div>
</div>

</cfoutput>