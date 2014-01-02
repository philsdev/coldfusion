<!------------------------------------------------------------------------------------------

	StudyGroupForm.cfm

------------------------------------------------------------------------------------------->

<cfscript>
	
	variables.Title = "Create New Study Group";

</cfscript>

<cfoutput>

<div id="content">
	<div id="breadcrumb">
		<a href="/" title="">Home</a>
		<a href="/study-groups.html" title="">Study Groups</a>
		<span>#variables.Title#</span>
	</div>
	<header class="contentListHeader clearfix">
		<h1>#variables.Title#</h1>
	</header>
	
	<section class="formSection">		
		<form action="/study-group-submit.html" method="post" id="StudyGroupForm">
			<input type="hidden" name="Course" value="#Request.Course.ID#" />
			<div class="formContainer" >
				<cfoutput>
				<span class="required requiredDesignation">Required Fields</span>
				<ul class="form pageForm vvv">
					<li>
						<label>School</label>
						<input type="text" disabled="disabled" name="School" value="#Request.School.Title#" />
					</li>
					<li>
						<label>Course</label>
						<input type="text" disabled="disabled" name="Course" value="#Request.Course.Title#" />
					</li>
					<li class="required">
						<label>Title</label>
						<input type="text" name="Title" value="" />
					</li>
					<li class="required">
						<label>Description</label>
						<textarea name="Description"></textarea>
					</li>
					<!--- <li class="required">
						<ul class="vii" style="">
							<li>
								<input type="checkbox" name="TermsAndConditions" />
								<label>Agree to <a href="#request.root.web#terms-and-conditions.html">Terms and Conditions</a>?</label>
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
		
		$('#StudyGroupForm').validate({
			rules: {
				Title: { required: true, minlength: 2, maxlength: 50 },
				Description: { required: true, minlength: 4 },
				//TermsAndConditions: { required: true }				
			}
		});
		
	});
</script>
