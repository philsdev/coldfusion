<!------------------------------------------------------------------------------------------

	EventList.cfm

------------------------------------------------------------------------------------------->

<cfscript>
	
	variables.AdminManager = Request.ListenerManager.GetListener( "AdminManager" );
	
	variables.PageTitle = "Events";
	
	if (Request.UserIsLoggedIn) {		
		if (Request.SearchParams.User EQ Request.UserID) {
			variables.PageTitle = "My Events";
		}
	}
	
	Request.Meta.Title = "Events";
	Request.Meta.Description = "Events";
	
</cfscript>

<div id="content">
	<div id="breadcrumb">
		<a href="/" title="">Home</a>
		<span><cfoutput>#variables.PageTitle#</cfoutput></span>
	</div>

	<form method="post" action="/events.html" id="ListingsForm">
		<input type="hidden" name="page" id="ListingsTargetPage" value="<cfoutput>#Request.SearchParams.Page#</cfoutput>" />
		<header class="contentListHeader clearfix">
			<h1><cfoutput>#variables.PageTitle#</cfoutput></h1>
			<div class="headerFunctions " >				
				<ul class="h-nav clearfix">
					<li>
						<span class="searchContainer"> 
							<input type="text" name="SearchTerm" id="eventSearch" value="<cfoutput>#Request.SearchParams.SearchTerm#</cfoutput>" />
						</span>
					</li>
					<li>
						<cfoutput>#Request.CategoryBox#</cfoutput>
					</li>
					<li>
						<cfoutput>#Request.SchoolBox#</cfoutput>
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
				<cfif Request.Events.RecordCount>
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
	
	<cfif Request.Events.RecordCount>
		<section class="listSection">
			<ul class="contentList imageList">
				<cfoutput query="Request.Events">
					<cfset Request.CurrentItem = variables.AdminManager.GetQueryRowAsStruct( InputQuery:Request.Events, RowIndex:Request.Events.CurrentRow ) />
					<cfinclude template="#Request.ViewManager.getViewPath('Viewlets.Event')#" />
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
	<cfinclude template="#Request.ViewManager.getViewPath('Links.Events')#" />	
	
	<div class="module">
		<div class="moduleContent">
			<cfoutput>#Request.AdPlacementRight#</cfoutput>
		</div>
	</div>
	
</div>