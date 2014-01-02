<!------------------------------------------------------------------------------------------

	SearchResults.cfm

------------------------------------------------------------------------------------------->

<cfscript>
	
	variables.AdminManager = Request.ListenerManager.GetListener( "AdminManager" );
	variables.PageTitle = "Search Results";
	
	Request.Meta.Title = "Search Results";
	Request.Meta.Description = "Search Results";
	
</cfscript>

<div id="content">

	<div id="breadcrumb">
		<a href="/" title="">Home</a>
		<span><cfoutput>#variables.PageTitle#</cfoutput></span>
	</div>	
	
	<form method="post" action="/search-results.html" id="ListingsForm">
		<input type="hidden" name="page" id="ListingsTargetPage" value="<cfoutput>#Request.SearchParams.Page#</cfoutput>" />
		<!---input type="hidden" name="SearchTerm" value="<cfoutput>#Request.SearchParams.SearchTerm#</cfoutput>" /--->
		<header class="contentListHeader clearfix">
			<h1><cfoutput>#variables.PageTitle#</cfoutput></h1>
			<div class="headerFunctions">				
				<ul class="h-nav clearfix">
					<li>
						<span class="searchContainer">
							<input type="text" name="SearchTerm" value="<cfoutput>#Request.SearchParams.SearchTerm#</cfoutput>" />
						</span>
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
				<cfif Request.SearchResults.RecordCount>
					<li>
						<cfoutput>#Request.SortBox#</cfoutput>			
					</li>
					</li>
					<li class="fr">
						<a class="button smallButton genericButton printBtn">Print Results</a>
					</li>
				</cfif>
			</ul>
		</div>
	</form>
	 
	
	<cfif Request.SearchResults.RecordCount>
		<section class="listSection">
			<ul class="contentList imageList">
			<cfoutput query="Request.SearchResults">
				<cfset Request.CurrentItem = variables.AdminManager.GetQueryRowAsStruct( InputQuery:Request.SearchResults, RowIndex:Request.SearchResults.CurrentRow ) />
				<cfset variables.ViewletName = "Viewlets." & Request.SearchResults.Section />		
				<cfinclude template="#Request.ViewManager.getViewPath(variables.ViewletName)#" />
			</cfoutput>
			</ul>
		</section>
		
		<footer class="contentListFooter">
			<cfoutput>#Request.GridPagination#</cfoutput>
		</footer>
	</cfif>
	
	<cfsetting showdebugoutput="true">
	
</div>

<div id="sidebar">
	<cfinclude template="#Request.ViewManager.getViewPath('Links.AccountDetails')#" />
	<div class="module">
		<div class="moduleContent">
			<cfoutput>#Request.AdPlacementRight#</cfoutput>
		</div>
	</div>
</div>