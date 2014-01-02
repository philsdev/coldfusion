<!------------------------------------------------------------------------------------------

	ProfileForm.cfm

------------------------------------------------------------------------------------------->
<cfscript>
	switch(URL.Message) {	
		case "Picture.Updated": {
			variables.Message = "Profile picture has been updated";	
			break;
		}
		default: {
			variables.Message = "";	
		}	
	}
	
	variables.Title = "Change Picture";
	
	if (LEN(request.ItemThumbnailPath)) {
		variables.HasThumbnail = true;
		variables.ImageLabel = "New Image";
		variables.ButtonLabel = "Change Picture";
	} else {
		variables.HasThumbnail = false;
		variables.ImageLabel = "Image";
		variables.ButtonLabel = "Upload Picture";
	}
	
	if (LEN(request.ItemFullSizePath)) {
		variables.ItemFullSizeLink = request.ItemFullsizePath;
	} else {
		variables.ItemFullSizeLink = "javascript:void(0)";
	}
	
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
		<cfif len(variables.Message)>
			<p class="message"><cfoutput>#variables.Message#</cfoutput></p>
		</cfif>
		<cfoutput>
			<form action="/profile-avatar-submit.html" method="post" enctype="multipart/form-data" id="ProfilePictureForm">
				<div class="formContainer" >
					<cfif variables.HasThumbnail>
						<div class="fl mr10">
							<a href="#variables.ItemFullSizeLink#" class="fancy">
								<img src="#request.ItemThumbnailPath#" />
							</a>
							<small><a class="db fancy" href="#variables.ItemFullSizeLink#">[+] full size</a></small>
						</div>
					</cfif>
					<ul class="form pageForm vvv fl">
						<li class="inline">
							<label><strong>#variables.ImageLabel# (JPEG):</strong></label>
							<input type="file" name="Image" value="" />
						</li>
						<li>
							<input type="submit" class="button actionButton" value="#variables.ButtonLabel#" >
						</li>
					</ul>
				</div>
			</form>
		</cfoutput>
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
	
		$('#ProfilePictureForm').validate({
			rules: {
				Image: { required: true, accept: "jpg|jpeg" }
			}
		});
		
	});
</script>
