<!------------------------------------------------------------------------------------------

	CommunityPostForm.cfm

------------------------------------------------------------------------------------------->

<cfscript>
	
	variables.AdminManager = Request.ListenerManager.GetListener( "AdminManager" );
	variables.LinkManager = Request.ListenerManager.GetListener( "LinkManager" );
	variables.Title = "Post Reply";
	variables.CommunityID = Request.Community.ID;
	variables.CategoryLink = variables.LinkManager.GetCommunityCategoryLink( CategoryID:Request.Community.CategoryID, CategoryTitle:Request.Community.Category );
	variables.CommunityLink = variables.LinkManager.GetCommunityLink( CommunityID:Request.Community.ID, CommunityTitle:Request.Community.Title );
	variables.DestinationUrl = Request.Event.GetArg('DestinationUrl');
	variables.OriginalPost = variables.AdminManager.GetFormattedDescription( Request.CommunityPost.Description );

</cfscript>

<cfoutput>

<div id="content">
	<div id="breadcrumb">
		<a href="/" title="">Home</a>
		<a href="/community.html" title="">Community</a>
		<a href="#variables.CategoryLink#" title="">#Request.Community.Category#</a>
		<a href="#variables.CommunityLink#" title="">#Request.Community.Title#</a>
		<span>#variables.Title#</span>
	</div>
	<header class="contentListHeader clearfix">
		<h1>#variables.Title#</h1>
	</header>
	<section class="formSection">
	
		<cfif Request.CommunityPost.RecordCount>
			<h4>Original post:</h4>
			<blockquote><p class="quoteTitle">"#variables.OriginalPost#"</p></blockquote>
		</cfif>
	
		<form action="/community-reply-submit.html" method="post" enctype="multipart/form-data" id="CommunityReplyForm">
			<input type="hidden" name="CommunityID" value="<cfoutput>#Request.Community.ID#</cfoutput>" />
			<input type="hidden" name="CommunityPostID" value="<cfoutput>#Request.Event.GetArg('CommunityPostID')#</cfoutput>" />
			<input type="hidden" name="DestinationUrl" value="<cfoutput>#variables.DestinationUrl#</cfoutput>" />
			<div class="formContainer" >
				<cfoutput>
				
				<ul class="form pageForm vvv">
					<li>
						<label>Reply:</label>
						<textarea name="Description"></textarea>
					</li>
					<!--- <li class="required">
						<ul class="vii" style="">
							<li>
								<input type="checkbox" name="TermsAndConditions" /> 
								<label>Agree to <a href="/terms-and-conditions.html">Terms and Conditions</a>?</label>
							</li>
						</ul>
					</li>--->
				</ul>
				</cfoutput>
			</div>
			<footer class="actionContainer mt20">
				<input type="submit" class="button actionButton" value="Submit" >
			</footer>  
		</form>
    </section>
</div>

</cfoutput>

<script type="text/javascript">
	$().ready( function() {
		
		$('#CommunityReplyForm').validate({
			rules: {
				Description: { required: true, minlength: 4 },
				//TermsAndConditions: { required: true }				
			}
		});
		
	});
</script>
