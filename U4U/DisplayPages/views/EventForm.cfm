<!------------------------------------------------------------------------------------------

	EventForm.cfm

------------------------------------------------------------------------------------------->

<cfscript>
	switch(URL.Message) {	
		case "Event.Added": {
			variables.Message = "Your event was added";	
			break;
		}
		case "Event.Updated": {
			variables.Message = "Your event was updated";	
			break;
		}
		default: {
			variables.Message = "";	
		}	
	}
	
	if (Request.Events.RecordCount) {
		variables.IsNewItem = false;
		variables.Title = "Edit an Event";
		variables.ButtonTitle = "Edit Event";
		variables.EventID = Request.Events.ID;
	} else {
		variables.IsNewItem = true;
		variables.Title = "Post an Event";
		variables.ButtonTitle = "Post Event";
		variables.EventID = "0";
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
		<a href="/events.html">Events</a>
		<span><cfoutput>#variables.Title#</cfoutput></span>
	</div>
	<header class="contentListHeader clearfix">
		<h1><cfoutput>#variables.Title#</cfoutput></h1>
	</header>
	<section class="formSection">
		<cfif len(variables.Message)>
			<p class="message"><cfoutput>#variables.Message#</cfoutput></p>
		</cfif>		
		<form action="/event-submit.html" method="post" enctype="multipart/form-data" id="EventForm">
			<input type="hidden" name="EventID" value="<cfoutput>#variables.EventID#</cfoutput>" />
			<div class="formContainer" >
				<cfoutput>
				<span class="required requiredDesignation">Required Fields</span>
				<ul class="form pageForm vvv">
					<li class="required">
						<label>Title</label>
						<input type="text" name="Title" value="#Request.Events.Title#" />
					</li>
					<li class="required">
						<label>Description</label>
						<textarea name="Description">#Request.Events.Description#</textarea>
					</li>
					<li class="required">
						<label>School:</label>
						#Request.SchoolBox#
					</li>
					<li class="required">
						<label>Category:</label>
						#Request.CategoryBox#
					</li>
					<li>
						<label>Organizer</label>
						<input type="text" name="Organizer" value="#Request.Events.Organizer#" />
					</li>
					<li>
						<label>Start Date:</label>
						<input type="text" class="textinput datepicker" name="StartDate" value="#Request.Events.StartDate#" />
						#request.StartTimeBoxes#
					</li>
					<li>
						<label for="EndDate">End Date:</label>
						<input type="text" class="textinput datepicker" name="EndDate" value="#Request.Events.EndDate#" />
						#request.EndTimeBoxes#
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
					<li class="required">
						<label>Address Title:</label>
						<input type="text" name="AddressTitle" value="#Request.Events.AddressTitle#" />
					</li>
					<li>
						<label>Street 1</label>
						<input type="text" name="Street1" value="#Request.Events.Street1#" />
					</li>
					<li>
						<label>Street 2</label>
						<input type="text" name="Street2" value="#Request.Events.Street2#" />
					</li>
					<li>
						<label>City</label>
						<input type="text" name="City" value="#Request.Events.City#" />
					</li>
					<li>
						<label>State</label>
						#Request.StateBox#
					</li>
					<li>
						<label>ZIP Code</label>
						<input type="text" name="ZipCode" value="#Request.Events.ZipCode#" />
					</li>
					<li>
						<label>Phone Number</label>
						<input type="text" name="PhoneNumber" value="#Request.Events.PhoneNumber#" />
					</li>
					<li>
						<label>URL</label>
						<input type="text" name="URL" value="#Request.Events.URL#" />
					</li>
					<!--- <cfif variables.IsNewItem>
						<li class="required">
							<ul class="vii" style="">
								<li>
									<input type="checkbox" name="TermsAndConditions" />
									<label>Agree to <a href="/terms-and-conditions.html">Terms and Conditions</a>?</label>
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
	<cfinclude template="#Request.ViewManager.getViewPath('Links.Events')#" />	
	<div class="module">
		<div class="moduleContent">
			<cfoutput>#Request.AdPlacementRight#</cfoutput>
		</div>
	</div>	
</div>

<script type="text/javascript">
	$().ready( function() {
		
		$('#EventForm').validate({
			rules: {
				<!--- <cfif variables.IsNewItem>
					TermsAndConditions: { required: true },
				</cfif> --->
				Title: { required: true, minlength: 2, maxlength: 50 },
				Description: { required: true, minlength: 4 },
				School: { required: true },
				Category: { required: true },
				Organizer: { required: false, maxlength: 50 },
				StartDate: { required: false, date: true },
				EndDate: { required: false, date: true },
				Image: { required: false, accept: 'jpeg|jpg' },
				AddressTitle: { required: true, maxlength: 50 },
				Street1: { required: false, maxlength: 50 },
				Street2: { required: false, maxlength: 50 },
				City: { required: false, maxlength: 50 },
				State: { required: false },
				ZipCode: { required: false, zipCode: true },
				PhoneNumber: { required: false, phoneNumber: true },
				URL: { required: false, url: true }		
			}
		});
		
	});
</script>
