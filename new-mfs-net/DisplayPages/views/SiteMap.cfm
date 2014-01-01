<cfscript>
	variables.LinkManager = Request.ListenerManager.GetListener( "LinkManager" );
	
	variables.PageManager = Request.ListenerManager.GetListener( "PageManager" );
	variables.PageList = variables.PageManager.GetDisplayPages();
	
	variables.CategoryManager = Request.ListenerManager.GetListener( "CategoryManager" );
	variables.CategoryList = variables.CategoryManager.GetCategories(Status: 1);
	
	

</cfscript>
<!------------------------------------------------------------------------------------------

	SiteMap.cfm

------------------------------------------------------------------------------------------->

<div id="breadcrumb">
	<a href="/" title="">Home</a>
	<span>Sitemap</span>
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
            <article class="entry-content">
                <header class="articleHeader">
                <h1>Sitemap</h1>
                </header>
        <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
        <div class="siteMapCol">
        <h2>Pages</h2>
            <ul class="siteMapList">
            <cfoutput query="variables.PageList">
            <cfset PageLink = replacenocase(variables.PageList.PageTitle,  " ",  "-" ,  "ALL" )>
            <li><a href="/#PageLink#.html">#variables.PageList.PageTitle#</a>	</li>	
            </cfoutput>
            </ul>
        </div>
        
        <div class="siteMapCol siteMapColR">
		<h2>Product Categories</h2>
		<!--- <cfloop query="variables.CategoryList">
		#variables.CategoryList.Category1Name#<br>			
		</cfloop> --->
		<ul class="siteMapList">
		<cfoutput query="variables.CategoryList" group="Category1ID">
		<cfset variables.CategoryName = variables.LinkManager.GetDisplayName(
			variables.CategoryList.Category1Name ) />
		<cfset variables.CategoryLink = variables.LinkManager.GetCategoryLink(
			CategoryID:variables.CategoryList.Category1ID,
			CategoryTitle:variables.CategoryList.Category1Name ) />
            
			<li rowid="#Category1ID#" class="tree" level="1">
				<h4><a href="#variables.CategoryLink#">#variables.CategoryName#</a></h4>
             <cfif Level1Count GT 0>
           		<ul>
				<cfoutput group="Category2ID">
                    <cfset variables.CategoryName = variables.LinkManager.GetDisplayName( variables.CategoryList.Category2Name ) />
                    <cfset variables.CategoryLink = variables.LinkManager.GetCategoryLink(
                    CategoryID:variables.CategoryList.Category2ID, 					
                    CategoryTitle:variables.CategoryList.Category2Name ) />
                        <cfif Level1Count GT 0> 
                              <li rowid="#Category2ID#" level="2" parent="#Category2Parent#">
                              <a href="#variables.CategoryLink#">#variables.CategoryName#</a>
                                    <cfif Level2Count GT 0>
                                        <ul>
                                        <cfoutput>
                                        <cfset variables.CategoryName = variables.LinkManager.GetDisplayName( variables.CategoryList.Category3Name ) />
                                        <cfset variables.CategoryLink = variables.LinkManager.GetCategoryLink(
                                                CategoryID:variables.CategoryList.Category3ID, 					
                                                CategoryTitle:variables.CategoryList.Category3Name ) />
                                            <li rowid="#Category3ID#" level="3" parent="#Category3Parent#" grandparent="#Category2Parent#">
                                                <a href="#variables.CategoryLink#">#variables.CategoryName#</a>
                                            </li>			
                                        </cfoutput>
                                        </ul>
                                      <cfelse>
                                      </li>
                                </cfif>
                        <cfelse>
                            </li>
                        </cfif>
                        
                </cfoutput>
                </ul>
                <cfelse>
                </li>
            
            </cfif>
            
            
		</cfoutput>
        </li>
	</ul>
    	</div>
        </article>
        
		</div>
       </div>
</div>
