<!------------------------------------------------------------------------------------------

	StudyGroupPostForm.cfm

------------------------------------------------------------------------------------------->

<cfscript>
	
	variables.AdminManager = Request.ListenerManager.GetListener( "AdminManager" );
	variables.LinkManager = Request.ListenerManager.GetListener( "LinkManager" );
	variables.Title = "Post Reply";
	variables.StudyGroupID = Request.StudyGroup.ID;
	variables.StudyGroupLink = variables.LinkManager.GetStudyGroupLink( StudyGroupID:Request.StudyGroup.ID, StudyGroupTitle:Request.StudyGroup.Title );
	variables.CourseLink = variables.LinkManager.GetStudyGroupCourseLink( CourseID:Request.StudyGroup.CourseID, CourseTitle:Request.StudyGroup.Course );
	variables.DestinationUrl = Request.Event.GetArg('DestinationUrl');
	variables.OriginalPost = variables.AdminManager.GetFormattedDescription( Request.StudyGroupPost.Description );

</cfscript>

<cfoutput>

<div id="content">
	<div id="breadcrumb">
		<a href="/" title="">Home</a>
		<a href="/study-groups.html" title="">Study Groups</a>
		<a href="#variables.CourseLink#" title="">#Request.StudyGroup.Course#</a>
		<a href="#variables.StudyGroupLink#" title="">#Request.StudyGroup.Title#</a>
		<span>#variables.Title#</span>
	</div>
	<header class="contentListHeader clearfix">
		<h1>#variables.Title#</h1>
	</header>
	<section class="formSection">
	
		<cfif Request.StudyGroupPost.RecordCount>
			<h4>Original post:</h4>
			<blockquote><p class="quoteTitle">"#variables.OriginalPost#"</p></blockquote>
		</cfif>
	
		<form action="/study-group-reply-submit.html" method="post" enctype="multipart/form-data" id="StudyGroupReplyForm">
			<input type="hidden" name="StudyGroupID" value="<cfoutput>#Request.StudyGroup.ID#</cfoutput>" />
			<input type="hidden" name="StudyGroupPostID" value="<cfoutput>#Request.Event.GetArg('StudyGroupPostID')#</cfoutput>" />
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
								<label>Agree to Terms and Conditions?</label>
							</li>
						</ul>
					</li> --->	
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
		
		$('#StudyGroupReplyForm').validate({
			rules: {
				Description: { required: true, minlength: 4 },
				//TermsAndConditions: { required: true }				
			}
		});
		
	});
</script>
