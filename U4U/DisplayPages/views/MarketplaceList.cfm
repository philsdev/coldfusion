<!------------------------------------------------------------------------------------------

	MarketplaceList.cfm

------------------------------------------------------------------------------------------->

<cfscript>

	variables.AdminManager = Request.ListenerManager.GetListener( "AdminManager" );
	
	variables.PageTitle = "Marketplace";
	
	if (Request.UserIsLoggedIn AND (Request.SearchParams.User EQ Request.UserID)) {
		variables.PageTitle = "My Marketplace Items";
	}
	
	Request.Meta.Title = "Marketplace";
	Request.Meta.Description = "Marketplace";
	
</cfscript>

<div id="content">
	<div id="breadcrumb">
		<a href="/" title="">Home</a>
		<span><cfoutput>#variables.PageTitle#</cfoutput></span>
	</div>
	
	<form method="post" action="/marketplace.html" id="ListingsForm">
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
				<li>
					<cfoutput>#Request.SortBox#</cfoutput>			
				</li>
				</li>
				<li class="fr">
					<a class="button smallButton genericButton printBtn">Print Results</a>
				</li>
			</ul>
		</div>
	</form>
	
	<section class="listSection">
		<ul class="contentList imageList">
			<cfoutput query="Request.Marketplace">
				<cfset Request.CurrentItem = variables.AdminManager.GetQueryRowAsStruct( InputQuery:Request.Marketplace, RowIndex:Request.Marketplace.CurrentRow ) />
				<cfinclude template="#Request.ViewManager.getViewPath('Viewlets.Marketplace')#" />
			</cfoutput>
		</ul>
	</section>
	
	<footer class="contentListFooter">
		<cfoutput>#Request.GridPagination#</cfoutput>
	</footer>

</div>

<div id="sidebar">
	<cfinclude template="#Request.ViewManager.getViewPath('Links.AccountDetails')#" />
	<cfinclude template="#Request.ViewManager.getViewPath('Links.Marketplace')#" />	
	<div class="module">
		<div class="moduleContent">
			<cfoutput>#Request.AdPlacementRight#</cfoutput>
		</div>
	</div>
</div>