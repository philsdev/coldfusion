<!------------------------------------------------------------------------------------------

	CommunityList.cfm

------------------------------------------------------------------------------------------->

<cfscript>

	variables.AdminManager = Request.ListenerManager.GetListener( "AdminManager" );
	variables.LinkManager = Request.ListenerManager.GetListener( "LinkManager" );
	variables.PageTitle = "Community";
	
	Request.Meta.Title = "Community";
	Request.Meta.Description = "Community";
	
</cfscript>

<div id="content">
	<div id="breadcrumb">
		<a href="/" title="">Home</a>
		<span><cfoutput>#variables.PageTitle#</cfoutput></span>
	</div>	
	
	<form method="post" action="/community.html" id="ListingsForm">
		<input type="hidden" name="page" id="ListingsTargetPage" value="<cfoutput>#Request.SearchParams.Page#</cfoutput>" />
		<header class="contentListHeader forumHeader clearfix">
			<h1><cfoutput>#variables.PageTitle#</cfoutput></h1>

			<div class="headerFunctions"> 
				<ul class="h-nav fl">
					<li><cfoutput>#Request.CategoryBox#</cfoutput></li>
					<li><button class="button genericButton smallButton">Go</button></li>
					<li><a href="/community-create.html" class="button genericButton smallButton">Create New Thread</a></li> 
				</ul>
				<!---div class="wp-pagenavi fr" >
					<span class="pages">Page 1 of 25</span><span class="current">1</span><a href="" class="page">2</a><a href="" class="page">3</a><a href="" class="page">4</a><a href="" class="page">5</a><a href="" class="nextpostslink">»</a><a href="" class="larger page">10</a><a href="" class="larger page">20</a><span class="extend">...</span><a href="" class="last">Last »</a> 
				</div--->
			</div>
		
		</header>
		
		<div class="resultFuntions clearfix">
			<ul class="h-nav pageTools">
				<li>
					<cfoutput>#request.RowsFoundLabel#</cfoutput>
				</li>
				<cfif Request.Communities.RecordCount>
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
	
	<cfif Request.Communities.RecordCount>
		<div class="forum">
			<section class="forumSection">
				<table cellpadding="0" cellspacing="0" border="0" class="forumTable">
					<thead>
						<tr>
							<th class="col1">Community</th>
							<th class="col2">Category</th>
							<th class="col3">Last Post</th>
							<th class="col4">Posts</th>
						</tr>
					</thead>
					<tbody>
						<cfoutput query="Request.Communities">
							<cfscript>
								variables.ItemLink = variables.LinkManager.GetCommunityLink( CommunityID:Request.Communities.ID, CommunityTitle:Request.Communities.Title );
								variables.CategoryLink = variables.LinkManager.GetCommunityCategoryLink( CategoryID:Request.Communities.CategoryID, CategoryTitle:Request.Communities.Category );
								
								if (IsNumeric( Request.Communities.RecentPostID )) {
									variables.HasRecentPost = true;
									variables.RecentPostTitle = Request.Communities.RecentPostTitle;
									variables.RecentPostUsername = Request.Communities.RecentPostUsername;
									variables.ProfileLink = variables.LinkManager.GetProfileLink( UserID:Request.Communities.RecentPostUserID, Username:Request.Communities.RecentPostUsername );	
									
								} else {
									variables.HasRecentPost = false;
									variables.RecentPostTitle = "";
								}
							</cfscript>
							<tr>
								<td><a href="#variables.ItemLink#" title="" class="forumTitle">#Request.Communities.Title#</a></td>
								<td><a href="#variables.CategoryLink#">#Request.Communities.Category#</a></td>
								<td class="lastPostInfo">
									<cfif variables.HasRecentPost>
										<div class="lastPostTitle">#variables.RecentPostTitle#</div>
										<div class="lastPostAuthor">by <a href="#variables.ProfileLink#">#variables.RecentPostUsername#</a></div>
										<div class="lastPostDate"></div>
									</cfif>
								</td>
								<td><a href="#variables.ItemLink#">#NumberFormat( Request.Communities.Posts )#</a></td>
							</tr>
						</cfoutput>
					</tbody>
				</table>
			</section>
			
			<footer class="contentListFooter">
				<cfoutput>#Request.GridPagination#</cfoutput>
			</footer>
		</div>
	</cfif>
	
</div>