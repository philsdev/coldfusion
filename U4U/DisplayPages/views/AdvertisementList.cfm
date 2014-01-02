<!------------------------------------------------------------------------------------------

	AdvertisementList.cfm

------------------------------------------------------------------------------------------->

<cfscript>

	variables.PageTitle = "My Advertisements";
	
</cfscript>

<div id="content">
	<div id="breadcrumb">
		<a href="/" title="">Home</a>
		<span><cfoutput>#variables.PageTitle#</cfoutput></span>
	</div>
	
	<form method="post" action="/my-advertisements.html" id="ListingsForm">
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
				<cfif Request.Advertisements.RecordCount>
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
	
	<cfif Request.Advertisements.RecordCount>
		<section class="listSection">
			<ul class="contentList imageList">
				<cfoutput query="Request.Advertisements">
					<cfswitch expression="#Request.Advertisements.MonetizationModelID#">
						<cfcase value="2">
							<cfset variables.CostPerAction = DollarFormat(Request.Advertisements.CostPerClick) & "/ea." />
						</cfcase>
						<cfdefaultcase>
							<cfset variables.CostPerAction = DollarFormat(Request.Advertisements.CostPerThousandImpressions) & "/1,000" />
						</cfdefaultcase>
					</cfswitch>
					<li class="noImage">
						<h3>#Request.Advertisements.Title#</h3>
						<table class="forumTable">
							<thead>
								<tr>
									<th>Payment Model</th>
									<th>Rate</th>
									<th>Budget</th>
									<th>Budget Used</th>
									<th>Status</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>#Request.Advertisements.MonetizationModel#</td>
									<td>#variables.CostPerAction#</td>
									<td>#DollarFormat(Request.Advertisements.Budget)#</td>
									<td>#DollarFormat(Request.Advertisements.BudgetUsed)#</td>
									<td>#Request.Advertisements.Status#</td>
								</tr>
							</tbody>
						</table>
					</li>
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
	<cfinclude template="#Request.ViewManager.getViewPath('Links.Advertisements')#" />	
	<div class="module">
		<div class="moduleContent">
			<cfoutput>#Request.AdPlacementRight#</cfoutput>
		</div>
	</div>
</div>