<!------------------------------------------------------------------------------------------

	PageDetails.cfm

------------------------------------------------------------------------------------------->

<cfscript>
	if (Request.PageDetails.RecordCount EQ 0) {
		QueryAddRow( Request.PageDetails, 1 );
		QuerySetCell( Request.PageDetails, "PageTitle", "Page Not Found", 1 );
		QuerySetCell( Request.PageDetails, "PageBody", "The page you requested was not found.", 1 );
	}
</cfscript>

<div id="breadcrumb">
	<a href="/" title="">Home</a>
	<span><cfoutput>#Request.PageDetails.PageTitle#</cfoutput></span>
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
		<div class="post">
			<article class="entry-content ">
				<header class="articleHeader">
					<h1><cfoutput>#Request.PageDetails.PageTitle#</cfoutput></h1>
				</header>
				<cfoutput>#Request.PageDetails.PageBody#</cfoutput>
			</article>
		</div>
	</div>
</div>