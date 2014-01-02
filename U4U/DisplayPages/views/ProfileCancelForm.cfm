<!------------------------------------------------------------------------------------------

	ProfileCancelForm.cfm

------------------------------------------------------------------------------------------->

<cfscript>
	
	variables.Title = "Cancel Account";
	
</cfscript>

<div id="content">
	<div id="breadcrumb">
		<a href="/" title="">Home</a>
		<a href="/profile-edit.html">Edit Profile</a>
		<span><cfoutput>#variables.Title#</cfoutput></span>
	</div>
	<header class="contentListHeader clearfix">
		<h1><cfoutput>#variables.Title#</cfoutput></h1>
	</header>
	<section class="formSection">
			<form action="/profile-cancel.html" method="post" id="ProfileCancelForm"></form>
			<div class="formContainer" >
				<p>Are you sure you want to cancel your account?</p>
				<p>
					<button class="button actionButton" id="cancel-yes">Yes</button>
					<button class="button actionButton" id="cancel-no">No</button>
				</p>
			</div>
		</form>
    </section>
</div>

<div id="sidebar">
	<cfinclude template="#Request.ViewManager.getViewPath('Links.AccountDetails')#" />
	<cfinclude template="#Request.ViewManager.getViewPath('Links.Account')#" />	
	<div class="module">
		<div class="moduleContent">
			<cfoutput>#Request.AdPlacementRight#</cfoutput>
		</div>
	</div>
</div>

<script type="text/javascript">
	$().ready( function() {
	
		$('#cancel-yes').click( function() {
			self.location.href = "/profile-cancel.html";
		});

		$('#cancel-no').click( function() {
			self.location.href = "/";
		});
		
	});
</script>