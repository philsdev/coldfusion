<!------------------------------------------------------------------------------------------

	StudyGroupPosts.cfm

------------------------------------------------------------------------------------------->

<cfscript>

	variables.AdminManager = Request.ListenerManager.GetListener( "AdminManager" );
	variables.LinkManager = Request.ListenerManager.GetListener( "LinkManager" );
	variables.StudyGroupLink = variables.LinkManager.GetStudyGroupLink( StudyGroupID:Request.StudyGroup.ID, StudyGroupTitle:Request.StudyGroup.Title );
	variables.CourseLink = variables.LinkManager.GetStudyGroupCourseLink( CourseID:Request.StudyGroup.CourseID, CourseTitle:Request.StudyGroup.Course );
	variables.ReplyLink = "/study-group-#Request.StudyGroup.ID#/post-reply.html";
	variables.Description = variables.AdminManager.GetFormattedDescription( Description:Request.StudyGroup.Description );
	
	Request.Meta.Title = "Study Groups - " & Request.StudyGroup.Course & " - " & Request.StudyGroup.Title;
	Request.Meta.Description = "Study Groups";
	
</cfscript>

<cfoutput>

<div id="content">
	<div id="breadcrumb">
		<a href="/" title="">Home</a>
		<a href="/study-groups.html" title="">Study Groups</a>
		<a href="#variables.CourseLink#" title="">#Request.StudyGroup.Course#</a>
		<span>#Request.StudyGroup.Title#</span>
	</div>
	
	<header class="contentListHeader clearfix">
		<h1>#Request.StudyGroup.Title#</h1>
		<cfif LEN( variables.Description )>
			<p>#variables.description#</p>
		</cfif>
		<div class="headerFunctions">
			<ul class="h-nav fl">
				<li><a href="##" class="button genericButton smallButton forumReply">Post Reply</a></li>
			</ul>	
		</div>
	</header>
	
	<form method="post" action="#variables.ReplyLink#" id="ForumPostReply">
		<input type="hidden" name="DestinationUrl" value="#variables.StudyGroupLink#" />
		<input type="hidden" name="StudyGroupPostID" id="ReplyPostID" value="0" />
	</form>
	
	<cfif Request.StudyGroupPosts.RecordCount>
		<form method="post" action="#variables.StudyGroupLink#" id="ListingsForm">
			<input type="hidden" name="page" id="ListingsTargetPage" value="<cfoutput>#Request.SearchParams.Page#</cfoutput>" />		
		
			<div class="forum">
				<section class="forumSection">
					<h2 class="fl">#request.RowsFoundLabel# in: #Request.StudyGroup.Title#</h2>
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
					<cfloop query="Request.StudyGroupPosts">
						<cfscript>
							variables.ProfileLink = variables.LinkManager.GetProfileLink( UserID:Request.StudyGroupPosts.UserID, Username:Request.StudyGroupPosts.Username );	
							variables.UserThumbnail = variables.AdminManager.GetItemThumbnail( ItemKey:"user", ItemID:Request.StudyGroupPosts.UserID );
							variables.Post = variables.AdminManager.GetFormattedDescription( Request.StudyGroupPosts.Description );
							variables.Signature = variables.AdminManager.GetFormattedDescription( Request.StudyGroupPosts.Signature );
							variables.QuoteDescription = variables.AdminManager.GetFormattedDescription( Request.StudyGroupPosts.QuoteDescription );
						</cfscript>				
						<table cellpadding="0" cellspacing="0" border="0" class="forumTable forumPost" id="post-#Request.StudyGroupPosts.ID#">
							<thead>
								<tr class="dateRow">
									<th class="col1" colspan="2">
										Date Posted: 
										#DateFormat( Request.StudyGroupPosts.DatePosted, "mm/dd/yyyy" )#,
										#TimeFormat( Request.StudyGroupPosts.DatePosted, "long" )#
									</th>
								</tr>
							</thead>
							<tbody>							
								<tr>
									<td valign="top" class="userInfoCol">
										<dl class="forumUserInfo">
											<dd class="userImage"><img src="#variables.UserThumbnail#" /></dd>
											<dt><a href="#variables.ProfileLink#" title="">#Request.StudyGroupPosts.Username#</a></dt>
											<dd>Posts: #NumberFormat(Request.StudyGroupPosts.UserPostCount)#</dd>
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
									<td class="postOptions"><a href="##" class="quoteReply" postId="#Request.StudyGroupPosts.ID#">Quote</a></td>
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
		<p>There are no posts yet for this study group.</p>
	</cfif>	

</cfoutput>
</div>