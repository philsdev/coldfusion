<cfscript>
	variables.LinkManager = Request.ListenerManager.GetListener( "LinkManager" );
	variables.NavigationManager = Request.ListenerManager.GetListener( "NavigationManager" );
	variables.NavigationParents = variables.NavigationManager.GetNavigationParents();
</cfscript>

<ul class="moduleCol1">
	<cfoutput query="variables.NavigationParents">
		<cfset variables.CategoryName = variables.LinkManager.GetDisplayName( CategoryName ) />
		<cfset variables.CategoryLink = variables.LinkManager.GetCategoryLink( CategoryID:CategoryID, CategoryTitle:variables.CategoryName ) />
		<li><a href="#variables.CategoryLink#" title="#variables.CategoryName#">#variables.CategoryName#</a></li>
	</cfoutput>
</ul>