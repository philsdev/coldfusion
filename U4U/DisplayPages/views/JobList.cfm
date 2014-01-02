<!------------------------------------------------------------------------------------------

	JobList.cfm

------------------------------------------------------------------------------------------->

<cfscript>
	variables.AdminManager = Request.ListenerManager.GetListener( "AdminManager" );
	
	variables.PageTitle = "Jobs";
	
	if (Request.UserIsLoggedIn AND (Request.SearchParams.User EQ Request.UserID)) {
		variables.PageTitle = "My Jobs";
	}
	
	Request.Meta.Title = "Jobs";
	Request.Meta.Description = "Jobs";
	
</cfscript>

<div id="content">
	<div id="breadcrumb">
		<a href="/" title="">Home</a>
		<span><cfoutput>#variables.PageTitle#</cfoutput></span>
	</div>
	
	<form method="post" action="/jobs.html" id="ListingsForm">
		<input type="hidden" name="page" id="ListingsTargetPage" value="<cfoutput>#Request.SearchParams.Page#</cfoutput>" />
		<header class="contentListHeader clearfix">
			<h1><cfoutput>#variables.PageTitle#</cfoutput></h1>
			<div class="headerFunctions " >				
				<ul class="h-nav clearfix">
					<li>
						<span class="searchContainer">
							<input type="text" name="SearchTerm" value="<cfoutput>#Request.SearchParams.SearchTerm#</cfoutput>" />
						</span>
					</li>
					<li>
						<cfoutput>#Request.CategoryBox#</cfoutput>
					</li>
					<li>
						<input type="submit" value="go" class="button smallButton genericButton" id="ListingsSubmitButton" />
					</li>
				</ul>
			</div>
		</header>
	
		<div class="resultFuntions clearfix">
			<ul class="h-nav pageTools">
				<li>
					<cfoutput>#request.RowsFoundLabel#</cfoutput>
				</li>
				<cfif Request.Jobs.RecordCount>
					<li>
						<cfoutput>#Request.SortBox#</cfoutput>			
					</li>
					</li>
					<li class="fr">
						<a href="#" class="button smallButton genericButton printBtn">Print Results</a>
					</li>
				</cfif>
			</ul>
		</div>
	</form>
	
	<cfif Request.Jobs.RecordCount>
		<section class="listSection">
			<ul class="contentList imageList">
				<cfoutput query="Request.Jobs">
					<cfset Request.CurrentItem = variables.AdminManager.GetQueryRowAsStruct( InputQuery:Request.Jobs, RowIndex:Request.Jobs.CurrentRow ) />
					<cfinclude template="#Request.ViewManager.getViewPath('Viewlets.Job')#" />
				</cfoutput>
			</ul>
		</section>
		
		<footer class="contentListFooter">
			<cfoutput>#Request.GridPagination#</cfoutput>
		</footer>
	</cfif>
		
</div>

<div id="sidebar">
	<cfinclude template="#Request.ViewManager.getViewPath('Links.AccountDetails')#" />
	<cfinclude template="#Request.ViewManager.getViewPath('Links.Jobs')#" />	
	<div class="module">
		<div class="moduleContent">
			<cfoutput>#Request.AdPlacementRight#</cfoutput>
		</div>
	</div>
</div>