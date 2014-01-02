<!------------------------------------------------------------------------------------------

	CommunityPosts.cfm

------------------------------------------------------------------------------------------->

<cfscript>

	variables.AdminManager = Request.ListenerManager.GetListener( "AdminManager" );
	variables.LinkManager = Request.ListenerManager.GetListener( "LinkManager" );
	variables.Description = variables.AdminManager.GetFormattedDescription( Request.Community.Description );
	variables.CategoryLink = variables.LinkManager.GetCommunityCategoryLink( CategoryID:Request.Community.CategoryID, CategoryTitle:Request.Community.Category );
	variables.CommunityLink = variables.LinkManager.GetCommunityLink( CommunityID:Request.Community.ID, CommunityTitle:Request.Community.Title );
	variables.ReplyLink = "/community-#Request.Community.ID#/post-reply.html";
	
	Request.Meta.Title = "Community - " & Request.Community.Category & " - " & Request.Community.Title;
	Request.Meta.Description = variables.Description;
	
</cfscript>

<cfoutput>

<div id="content">
	<div id="breadcrumb">
		<a href="/" title="">Home</a>
		<a href="/community.html" title="">Community</a>
		<a href="#variables.CategoryLink#" title="">#Request.Community.Category#</a>
		<span>#Request.Community.Title#</span>
	</div>
	
	<header class="contentListHeader clearfix">
		<h1>#Request.Community.Title#</h1>
		
		<cfif LEN( variables.Description )>
			<p>#variables.Description#</p>
		</cfif>
		
		<div class="headerFunctions">
			<ul class="h-nav fl">
				<li><a href="##" class="button genericButton smallButton forumReply">Post Reply</a></li>
			</ul>	
		</div>
	</header>
	
	<form method="post" action="#variables.ReplyLink#" id="ForumPostReply">
		<input type="hidden" name="DestinationUrl" value="#variables.CommunityLink#" />
		<input type="hidden" name="CommunityPostID" id="ReplyPostID" value="0" />
	</form>
	
	<cfif Request.CommunityPosts.RecordCount>
		<form method="post" action="#variables.CommunityLink#" id="ListingsForm">
			<input type="hidden" name="page" id="ListingsTargetPage" value="<cfoutput>#Request.SearchParams.Page#</cfoutput>" />		
		
			<div class="forum">
				<section class="forumSection">
					<h2 class="fl">#request.RowsFoundLabel# in: #Request.Community.Title#</h2>
					<!---
						<ul class="h-nav pageTools fr">
							<li>
								<div class="form hii forumSearch" id="forumSearch">
									<label>Search:</label>
									<input type="text" />
									<input type="submit" class="button genericButton smallButton" value="GO" />
								</div>
							</li>
						</ul>
					--->
					<cfloop query="Request.CommunityPosts">
						<cfscript>
							variables.ProfileLink = variables.LinkManager.GetProfileLink( UserID:Request.CommunityPosts.UserID, Username:Request.CommunityPosts.Username );	
							variables.UserThumbnail = variables.AdminManager.GetItemThumbnail( ItemKey:"user", ItemID:Request.CommunityPosts.UserID );
							variables.Post = variables.AdminManager.GetFormattedDescription( Request.CommunityPosts.Description );
							variables.Signature = variables.AdminManager.GetFormattedDescription( Request.CommunityPosts.Signature );
							variables.QuoteDescription = variables.AdminManager.GetFormattedDescription( Request.CommunityPosts.QuoteDescription );
						</cfscript>				
						<table cellpadding="0" cellspacing="0" border="0" class="forumTable forumPost" id="post-#Request.CommunityPosts.ID#">
							<thead>
								<tr class="dateRow">
									<th class="col1" colspan="2">
										Date Posted: 
										#DateFormat( Request.CommunityPosts.DatePosted, "mm/dd/yyyy" )#,
										#TimeFormat( Request.CommunityPosts.DatePosted, "long" )#
									</th>
								</tr>
							</thead>
							<tbody>							
								<tr>
									<td valign="top" class="userInfoCol">
										<dl class="forumUserInfo">
											<dd class="userImage"><img src="#variables.UserThumbnail#" /></dd>
											<dt><a href="#variables.ProfileLink#" title="">#Request.CommunityPosts.Username#</a></dt>
											<dd>Posts: #NumberFormat(Request.CommunityPosts.UserPostCount)#</dd>
										</dl>
									</td>
									<td class="postContent">
										
										<cfif LEN( variables.QuoteDescription )>
											<div class="quote">
												<span>Quote:</span>
												<blockquote class="quoteContent">
													<p>#variables.QuoteDescription#</p>
												</blockquote>
											</div>
										</cfif>										
										
										<p>#variables.Post#</p>
										<div class="postSignature">
											#variables.Signature#
										</div>
									</td>
								</tr>
								<tr class="postFooter">
									<td class="userInfoCol"></td>
									<td class="postOptions"><a href="##" class="quoteReply" postId="#Request.CommunityPosts.ID#">Quote</a></td>
								</tr>						
							</tbody>
						</table>
					</cfloop>
				</section>
				
				<footer class="contentListFooter">
					<cfoutput>#Request.GridPagination#</cfoutput>
				</footer>
			</div>
		</form>
	<cfelse>
		<p>There are no posts yet for this community.</p>
	</cfif>	

</cfoutput>
</div>