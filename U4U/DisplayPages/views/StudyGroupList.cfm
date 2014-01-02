<!------------------------------------------------------------------------------------------

	StudyGroupList.cfm

------------------------------------------------------------------------------------------->

<cfscript>

	variables.AdminManager = Request.ListenerManager.GetListener( "AdminManager" );
	variables.LinkManager = Request.ListenerManager.GetListener( "LinkManager" );
	variables.PageTitle = "Study Groups";
	
	if ( LEN(Request.Event.GetArg('Course')) ) {
		variables.IsSearch = true;
	} else {
		variables.IsSearch = false;
	}
	
	Request.Meta.Title = "Study Groups";
	Request.Meta.Description = "Study Groups";
	
</cfscript>

<script type="text/javascript">

	$().ready( function() {
	
		$('#StudyGroupSchoolOptions').change( function() {
			toggleStudyGroupNewButton();
			
			var SelectedSchool = $('#StudyGroupSchoolOptions').val();
			
			if (SelectedSchool > 0) {
			
				$('#StudyGroupCourseOptionContainer').html( Html.Loading );			
				
				var CourseOptionParams = { school:SelectedSchool };
				
				$.post( 
					'/course-options.html', 
					CourseOptionParams, 
					function(data) {
						$('#StudyGroupCourseOptionContainer').html(data);
					}
				);
			
			} else {
				$('#StudyGroupCourseOptionContainer').html('');		
			}
		});
		
		$('#StudyGroupSchoolOptions').change( function() {			
			toggleStudyGroupGoButton();
			toggleStudyGroupNewButton();
		});
		
		$('#StudyGroupCourseOptions').live( 'change', function() {
			toggleStudyGroupGoButton();
			toggleStudyGroupNewButton();
		});
		
		$('#StudyGroupNewButtonContainer').children('a').click( function() {
			var SelectedCourse = $('#StudyGroupCourseOptions').val();
			
			if ( SelectedCourse > 0 ) {
				$('#StudyGroupNewForm').submit();
			}
		});
		
		toggleStudyGroupGoButton();
	
	});
	
	function toggleStudyGroupGoButton() {
		var SelectedCourse = $('#StudyGroupCourseOptions').val();
		
		if ( SelectedCourse > 0 ) {
			$('#StudyGroupButtonContainer').show();
		} else {
			$('#StudyGroupButtonContainer').hide();
		}
	}

	function toggleStudyGroupNewButton() {
		$('#StudyGroupNewButtonContainer').html('');
	}
</script>

<div id="content">
	<div id="breadcrumb">
		<a href="/" title="">Home</a>
		<span><cfoutput>#variables.PageTitle#</cfoutput></span>
	</div>	

	<form method="post" action="/study-groups.html" id="ListingsForm">
		<input type="hidden" name="page" id="ListingsTargetPage" value="<cfoutput>#Request.SearchParams.Page#</cfoutput>" />
		<header class="contentListHeader forumHeader clearfix">
			<h1><cfoutput>#variables.PageTitle#</cfoutput></h1>

			<div class="headerFunctions"> 
				<ul class="h-nav fl">
					<li><cfoutput>#Request.SchoolBox#</cfoutput></li>
					<li id="StudyGroupCourseOptionContainer"><cfoutput>#Request.CourseBox#</cfoutput></li>
					<li id="StudyGroupGoButtonContainer"><button class="button genericButton smallButton">Go</button></li>
                   	<li id="StudyGroupNewButtonContainer"> 
						<cfif variables.IsSearch>
							<a class="button genericButton smallButton">Create New Study Group</a>
						</cfif>
					</li> 
                    <li class="courseAdd">Don't see a course you're in?  <a href="contact-us.html" style="float:none; font-weight:bold;">Contact us.</a></li>
				</ul>
			</div>
		
		</header>
		
		<cfif variables.IsSearch>
			<div class="resultFuntions clearfix">
				<ul class="h-nav pageTools">
					<li>
						<cfoutput>#request.RowsFoundLabel#</cfoutput>
					</li>
					<cfif Request.StudyGroups.RecordCount>
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
		</cfif>
	</form>
	
	<cfif variables.IsSearch>
	
		<div style="display:none">
			<form action="/study-group-create.html" method="post" id="StudyGroupNewForm">
				<input type="hidden" name="CourseID" value="<cfoutput>#Request.Event.GetArg('Course')#</cfoutput>" />
			</form>
		</div>
	
		<cfif Request.StudyGroups.RecordCount>
	
			<div class="forum">
				<section class="forumSection">
					<table cellpadding="0" cellspacing="0" border="0" class="forumTable">
						<thead>
							<tr>
								<th class="col1">Study Groups</th>
								<th class="col2">Course</th>
								<th class="col3">Last Post</th>
								<th class="col4">Posts</th>
							</tr>
						</thead>
						<tbody>
							<cfoutput query="Request.StudyGroups">
								<cfscript>
									variables.ItemLink = variables.LinkManager.GetStudyGroupLink( StudyGroupID:Request.StudyGroups.ID, StudyGroupTitle:Request.StudyGroups.Title );
									variables.CourseLink = variables.LinkManager.GetStudyGroupCourseLink( CourseID:Request.StudyGroups.CourseID, CourseTitle:Request.StudyGroups.Course );
									
									if (IsNumeric( Request.StudyGroups.RecentPostID )) {
										variables.HasRecentPost = true;
										variables.RecentPostTitle = Request.StudyGroups.RecentPostTitle;
										variables.RecentPostUsername = Request.StudyGroups.RecentPostUsername;
										variables.ProfileLink = variables.LinkManager.GetProfileLink( UserID:Request.StudyGroups.RecentPostUserID, Username:Request.StudyGroups.RecentPostUsername );	
										
									} else {
										variables.HasRecentPost = false;
										variables.RecentPostTitle = "";
									}
								</cfscript>
								<tr>
									<td><a href="#variables.ItemLink#" title="" class="forumTitle">#Request.StudyGroups.Title#</a></td>
									<td><a href="#variables.CourseLink#">#Request.StudyGroups.Course#</a></td>
									<td class="lastPostInfo">
										<cfif variables.HasRecentPost>
											<div class="lastPostTitle">#variables.RecentPostTitle#</div>
											<div class="lastPostAuthor">by <a href="#variables.ProfileLink#">#variables.RecentPostUsername#</a></div>
											<div class="lastPostDate"></div>
										</cfif>
									</td>
									<td><a href="#variables.ItemLink#">#NumberFormat( Request.StudyGroups.Posts )#</a></td>
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
		<cfelse>
        
       <p>Please select a school and course above.</p>
	</cfif>
	
</div>