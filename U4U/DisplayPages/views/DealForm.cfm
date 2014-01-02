<!------------------------------------------------------------------------------------------

	DealForm.cfm

------------------------------------------------------------------------------------------->

<cfscript>
	
	switch(URL.Message) {	
		case "Deal.Added": {
			variables.Message = "Your deal was added, and is pending approval";	
			break;
		}
		case "Deal.Updated": {
			variables.Message = "Your deal was updated";	
			break;
		}	
		default: {
			variables.Message = "";	
			break;
		}		
	}
	
	if (Request.Deal.RecordCount) {
		variables.IsNewItem = false;
		variables.Title = "Edit a Deal";
		variables.ButtonTitle = "Edit Deal";
		variables.DealID = Request.Deal.ID;
	} else {
		variables.IsNewItem = true;
		variables.Title = "Post a Deal";
		variables.ButtonTitle = "Post Deal";
		variables.DealID = "0";
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
		<a href="/deals.html">Deals</a>
		<span><cfoutput>#variables.Title#</cfoutput></span>
	</div>
	<header class="contentListHeader clearfix">
		<h1><cfoutput>#variables.Title#</cfoutput></h1>
	</header>
	<section class="formSection">
		<cfif len(variables.Message)>
			<p class="message"><cfoutput>#variables.Message#</cfoutput></p>
		</cfif>
		
		<div id="deal-tabs">
			<ul>
				<li><a href="#details"><span>Details</span></a></li>
				<li><a href="#performance"><span>Performance</span></a></li>
			</ul>
			<div id="details">
				
				<form action="/deal-submit.html" method="post" enctype="multipart/form-data" id="DealForm">
					<input type="hidden" name="DealID" value="<cfoutput>#variables.DealID#</cfoutput>" />			
					<div class="formContainer" >
						<cfoutput>
						<span class="required requiredDesignation">Required Fields</span>
						<ul class="form pageForm vvv">
							<li class="required">
								<label>Title</label>
								<input type="text" name="Title" value="#Request.Deal.Title#" />
							</li>
							<li class="required">
								<label>Description</label>
								<textarea name="Description">#Request.Deal.Description#</textarea>
							</li>
							<li class="required">
								<label>Category</label>
								#Request.CategoryBox#
							</li>
							<li>
								<label>Start Date:</label>
								<input type="text" class="textinput datepicker" name="StartDate" value="#Request.Deal.StartDate#" />
							</li>
							<li>
								<label for="EndDate">End Date:</label>
								<input type="text" class="textinput datepicker" name="EndDate" value="#Request.Deal.EndDate#" />
							</li>
							<li class="required">
								<label>Destination URL:</label>
								<input type="text" name="DestinationUrl" value="#Request.Deal.DestinationUrl#" />
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
								<label>Company Name:</label>
								<input type="text" name="AddressTitle" value="#Request.Deal.AddressTitle#" />
							</li>
							<li class="required">
								<label>Street 1</label>
								<input type="text" name="Street1" value="#Request.Deal.Street1#" />
							</li>
							<li>
								<label>Street 2</label>
								<input type="text" name="Street2" value="#Request.Deal.Street2#" />
							</li>
							<li class="required">
								<label>City</label>
								<input type="text" name="City" value="#Request.Deal.City#" />
							</li>
							<li class="required">
								<label>State</label>
								#Request.StateBox#
							</li>
							<li>
								<label>ZIP Code</label>
								<input type="text" name="ZipCode" value="#Request.Deal.ZipCode#" />
							</li>
							<li class="required">
								<label>Phone Number</label>
								<input type="text" name="PhoneNumber" value="#Request.Deal.PhoneNumber#" />
							</li>
							<li>
								<label>URL</label>
								<input type="text" name="URL" value="#Request.Deal.URL#" />
							</li>
							<!--- BUDGET --->
							<li class="required">
								<label>Budget</label>
								<input type="text" name="Budget" value="#Request.Deal.Budget#" />
							</li>
							<li <cfif NOT variables.IsNewItem>style="display:none"</cfif>>
								<label>Payment Model</label>
								#Request.MonetizationModelBox#
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
			</div>
			<div id="performance">
				<div class="formContainer" >
					<cfoutput>
					<ul class="form pageForm hhh">
						<li>
							<label>Range</label>
							#Request.Deal.FirstTrack# - #Request.Deal.LastTrack#
						</li>
						<li>
							<label>Payment Model</label>
							#Request.Deal.MonetizationModel#
						</li>
						<li>
							<label>Budget Used</label>
							#DollarFormat(Request.Deal.BudgetUsed)#
						</li>
						<li>
							<label>Budget Remaining</label>
							#DollarFormat(Request.Deal.BudgetRemaining)#
						</li>
					</ul>
					</cfoutput>
				</div>
			</div>
		</div>
	</section>
</div>

<div id="sidebar">
	<cfinclude template="#Request.ViewManager.getViewPath('Links.AccountDetails')#" />
	<cfinclude template="#Request.ViewManager.getViewPath('Links.Deals')#" />
	<div class="module">
		<div class="moduleContent">
			<cfoutput>#Request.AdPlacementRight#</cfoutput>
		</div>
	</div>	
</div>

<script type="text/javascript">
	$().ready( function() {
	
		$("#deal-tabs").tabs();
	
		$('#DealForm').validate({
			rules: {
				<cfif variables.IsNewItem>
					//TermsAndConditions: { required: true },
					MonetizationModel: { required: true },
				</cfif>				
				Title: { required: true, minlength: 2, maxlength: 50 },
				Description: { required: true, minlength: 4 },
				Category: { required: true },
				StartDate: { required: false, date: true },
				EndDate: { required: false, date: true },
				DestinationUrl: { required: true, url: true },
				Image: { required: false, accept: 'jpeg|jpg' },
				AddressTitle: { required: true, maxlength: 50 },
				Street1: { required: true, maxlength: 50 },
				Street2: { required: false, maxlength: 50 },
				City: { required: true, maxlength: 50 },
				State: { required: true },
				ZipCode: { required: false, zipCode: true },
				PhoneNumber: { required: false, phoneNumber: true },
				URL: { required: false, url: true },
				Budget: { required: true, number: true, min: 10 }						
			}
		});
		
	});
</script>
