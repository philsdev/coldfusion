<!------------------------------------------------------------------------------------------

	CommunityForm.cfm

------------------------------------------------------------------------------------------->

<cfscript>
	
	variables.AdminManager = Request.ListenerManager.GetListener( "AdminManager" );
	variables.LinkManager = Request.ListenerManager.GetListener( "LinkManager" );
	variables.Title = "Create New Thread";

</cfscript>

<cfoutput>

<div id="content">
	<div id="breadcrumb">
		<a href="/" title="">Home</a>
		<a href="/community.html" title="">Community</a>
		<span>#variables.Title#</span>
	</div>
	<header class="contentListHeader clearfix">
		<h1>#variables.Title#</h1>
	</header>
	
	<section class="formSection">		
		<form action="/community-submit.html" method="post" id="CommunityForm">
			<div class="formContainer" >
				<cfoutput>
				<span class="required requiredDesignation">Required Fields</span>
				<ul class="form pageForm vvv">
					<li class="required">
						<label>Category</label>
						#Request.CategoryBox#
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
								<label>Agree to <a href="/terms-and-conditions.html">Terms and Conditions</a>?</label>
							</li>
						</ul>
					</li>	 --->
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
		
		$('#CommunityForm').validate({
			rules: {
				Category: { required: true },
				Title: { required: true, minlength: 2, maxlength: 50 },
				Description: { required: true, minlength: 4 },
				//TermsAndConditions: { required: true }				
			}
		});
		
	});
</script>
