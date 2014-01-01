<cfscript>
	variables.LinkManager = Request.ListenerManager.GetListener( "LinkManager" );
	variables.NavigationManager = Request.ListenerManager.GetListener( "NavigationManager" );	
	variables.NavigationCategories = variables.NavigationManager.GetNavigationCategories();
</cfscript>

<ul id="fullNav" class="dropdown clearfix2" >
	<cfoutput query="variables.NavigationCategories" group="Category1ID">
		<cfset variables.CategoryName = variables.LinkManager.GetDisplayName( Category1Name ) />
		<cfset variables.CategoryLink = variables.LinkManager.GetCategoryLink( CategoryID:Category1ID, CategoryTitle:variables.CategoryName ) />
		<li>
			<span class="expand"></span><a href="#variables.CategoryLink#">#variables.CategoryName#</a>
			<cfif Level1Count GT 0>
				<cfset variables.NavigationRowIndex = 0 />
				<div class="sub_menu">
					<ul>
					<cfoutput>
						<cfset variables.NavigationRowIndex = IncrementValue( variables.NavigationRowIndex ) />
						<cfif variables.NavigationRowIndex MOD REQUEST.Settings.NavigationColumnLength EQ 0 AND variables.NavigationRowIndex LT Level1Count>
							</ul>
							<ul>
						</cfif>
						<cfset variables.CategoryName = variables.LinkManager.GetDisplayName( Category2Name ) />
						<cfset variables.CategoryLink = variables.LinkManager.GetCategoryLink( CategoryID:Category2ID, CategoryTitle:variables.CategoryName ) />
						<li>
							<a href="#variables.CategoryLink#">#variables.CategoryName#</a>
						</li>
					</cfoutput>
					</ul>								
				</div>
			</cfif>
		</li>
	</cfoutput>				
	<!--- 
		TODO: fix script errors
		<li><a href="/gift-cards.html">Gift Cards</a></li> 
	--->
</ul>