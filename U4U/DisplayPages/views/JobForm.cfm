<!------------------------------------------------------------------------------------------

	JobForm.cfm

------------------------------------------------------------------------------------------->

<cfscript>
	switch(URL.Message) {	
		case "Job.Added": {
			variables.Message = "Your job was added";	
			break;
		}
		case "Job.Updated": {
			variables.Message = "Your job was updated";	
			break;
		}
		default: {
			variables.Message = "";	
		}	
	}
	
	if (Request.Job.RecordCount) {
		variables.IsNewItem = false;
		variables.Title = "Edit a Job";
		variables.ButtonTitle = "Edit Job";
		variables.JobID = Request.Job.ID;
		variables.LinkManager = Request.ListenerManager.GetListener( "LinkManager" );
		variables.ItemLink = variables.LinkManager.GetJobLink( JobID:variables.JobID, JobTitle:Request.Job.Title );
	} else {
		variables.IsNewItem = true;
		variables.Title = "Post a Job";
		variables.ButtonTitle = "Post Job";
		variables.JobID = "0";
	}
	
	if (LEN(request.ItemThumbnailPath)) {
		variables.HasThumbnail = true;
		variables.ImageLabel = "New Image";
		variables.ThumbnailLink = request.ItemThumbnailPath;
	} else {
		variables.HasThumbnail = false;
		variables.ImageLabel = "Image";
		variables.ThumbnailLink = "javascript:void(0)";
	}
	
	if (LEN(request.ItemFullSizePath)) {
		variables.HasFullSize = true;
		variables.FullSizeLink = request.ItemFullSizePath;
	} else {
		variables.HasFullSize = false;
		variables.FullSizeLink = "javascript:void(0)";
	}
	
</cfscript>

<div id="content">
	<div id="breadcrumb">
		<a href="/" title="">Home</a>
		<a href="/jobs.html">Jobs</a>
		<span><cfoutput>#variables.Title#</cfoutput></span>
	</div>
	<header class="contentListHeader clearfix">
		<h1><cfoutput>#variables.Title#</cfoutput></h1>
	</header>
	<section class="formSection">
		<cfif len(variables.Message)>
			<p class="message"><cfoutput>#variables.Message#</cfoutput></p>
		</cfif>
		<!---cfif NOT variables.IsNewItem>
			<p><a href="<cfoutput>#variables.ItemLink#</cfoutput>">View Listing</a></p>
		</cfif--->
		<form action="/job-submit.html" method="post" enctype="multipart/form-data" id="JobForm">
			<input type="hidden" name="JobID" value="<cfoutput>#variables.JobID#</cfoutput>" />
			<div class="formContainer" >
				<cfoutput>
				<span class="required requiredDesignation">Required Fields</span>
				<ul class="form pageForm vvv">
					<li class="required">
						<label>Title</label>
						<input type="text" name="Title" value="#Request.Job.Title#" />
					</li>
					<li class="required">
						<label>Description</label>
						<textarea name="Description">#Request.Job.Description#</textarea>
					</li>
					<li class="required">
						<label for="Type">Category:</label>
						#Request.CategoryBox#
					</li>
					<li class="required">
						<label>Company Name</label>
						<input type="text" name="CompanyName" value="#Request.Job.CompanyName#" />
					</li>
					<li class="required">
						<label>Contact Name</label>
						<input type="text" name="ContactName" value="#Request.Job.ContactName#" />
					</li>
					<li class="required">
						<label>Reply E-mail</label>
						<input type="text" name="ReplyEmail" value="#Request.Job.ReplyEmail#" />
					</li>
					<li>
						<label>#variables.ImageLabel#</label>
						<input type="file" name="Image" style="margin-right:20px" />
						<cfif variables.HasThumbnail>
							<a href="#variables.ThumbnailLink#" class="fancy">[+] thumbnail</a>
						</cfif>
						<cfif variables.HasFullSize>
							<a href="#variables.FullSizeLink#" class="fancy">[+] full size</a>
						</cfif>
					</li>
					<!--- ADDRESS --->
					<li>
						<label>Address Title:</label>
						<input type="text" name="AddressTitle" value="#Request.Job.AddressTitle#" />
					</li>
					<li class="required">
						<label>Street 1</label>
						<input type="text" name="Street1" value="#Request.Job.Street1#" />
					</li>
					<li>
						<label>Street 2</label>
						<input type="text" name="Street2" value="#Request.Job.Street2#" />
					</li>
					<li class="required">
						<label>City</label>
						<input type="text" name="City" value="#Request.Job.City#" />
					</li>
					<li class="required">
						<label>State</label>
						#Request.StateBox#
					</li>
					<li>
						<label>ZIP Code</label>
						<input type="text" name="ZipCode" value="#Request.Job.ZipCode#" />
					</li>
					<li class="required">
						<label>Phone Number</label>
						<input type="text" name="PhoneNumber" value="#Request.Job.PhoneNumber#" />
					</li>
					<li>
						<label>URL</label>
						<input type="text" name="URL" value="#Request.Job.URL#" />
					</li>
					<!--- <cfif variables.IsNewItem>
						<li class="required">
							<ul class="vii" style="">
								<li>
									<input type="checkbox" name="TermsAndConditions" />
									<label>Agree to Terms and Conditions?</label>
								</li>
							</ul>
						</li>	
					</cfif> --->
				</ul>
				</cfoutput>
			</div>
			<footer class="actionContainer mt20">
				<input type="submit" class="button actionButton" value="<cfoutput>#variables.ButtonTitle#</cfoutput>" >
			</footer>  
		</form>
    </section>
</div>

<div id="sidebar">
	<cfinclude template="#Request.ViewManager.getViewPath('Links.AccountDetails')#" />
	<cfinclude template="#Request.ViewManager.getViewPath('Links.Jobs')#" />	
	<div class="module">
		<div class="moduleContent">
			<cfoutput>#Request.AdPlacementRight#</cfoutput>
		</div>
	</div>	
</div>

<script type="text/javascript">
	$().ready( function() {
		
		$('#JobForm').validate({
			rules: {
				<!--- <cfif variables.IsNewItem>
					TermsAndConditions: { required: true },
				</cfif> --->
				Title: { required: true, minlength: 2, maxlength: 50 },
				Description: { required: true, minlength: 4 },
				Category: { required: true },
				CompanyName: { required: true, minlength: 2, maxlength: 50 },
				ContactName: { required: true, minlength: 2, maxlength: 50 },
				ReplyEmail: { required: true, email:true, maxlength: 100 },
				Image: { required: false, accept: 'jpeg|jpg' },
				AddressTitle: { required: false, maxlength: 50 },
				Street1: { required: true, maxlength: 50 },
				Street2: { required: false, maxlength: 50 },
				City: { required: true, maxlength: 50 },
				State: { required: true },
				ZipCode: { required: false, zipCode: true },
				PhoneNumber: { required: false, phoneNumber: true },
				URL: { required: false, url: true }			
			}
		});
		
	});
</script>
