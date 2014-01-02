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

<div id="content">
	<div id="breadcrumb">
		<a href="/" title="">Home</a>
		<span><cfoutput>#Request.PageDetails.PageTitle#</cfoutput></span>
	</div>
	
	<header class="contentListHeader clearfix">
		<h1><cfoutput>#Request.PageDetails.PageTitle#</cfoutput></h1>
	</header>
	<section class="formSection">
		<cfoutput>#Request.PageDetails.PageBody#</cfoutput>
    </section>
</div>

<div id="sidebar">
	<cfinclude template="#Request.ViewManager.getViewPath('Links.AccountDetails')#" />
	<div class="module">
		<div class="moduleContent">
			<cfoutput>#Request.AdPlacementRight#</cfoutput>
		</div>
	</div>
</div>