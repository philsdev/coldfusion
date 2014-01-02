<!------------------------------------------------------------------------------------------

	MarketplaceForm.cfm

------------------------------------------------------------------------------------------->

<cfscript>
	switch(URL.Message) {
		case "Item.Added": {
			variables.Message = "Your item was added";	
			break;
		}
		case "Item.Updated": {
			variables.Message = "Your item was updated";	
			break;
		}
		default: {
			variables.Message = "";	
		}	
	}
	
	if (Request.Item.RecordCount) {
		variables.IsNewItem = false;
		variables.Title = "Edit an Item";
		variables.ButtonTitle = "Edit Item";
		variables.ItemID = Request.Item.ID;
	} else {
		variables.IsNewItem = true;
		variables.Title = "Post an Item";
		variables.ButtonTitle = "Post Item";
		variables.ItemID = "0";		
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
		<a href="/marketplace.html">Marketplace</a>
		<span><cfoutput>#variables.Title#</cfoutput></span>
	</div>
	<header class="contentListHeader clearfix">
		<h1><cfoutput>#variables.Title#</cfoutput></h1>
	</header>
	<section class="formSection">
		<cfif len(variables.Message)>
			<p class="message"><cfoutput>#variables.Message#</cfoutput></p>
		</cfif>
		<form action="/marketplace-submit.html" method="post" enctype="multipart/form-data" id="MarketplaceForm">
			<input type="hidden" name="ItemID" value="<cfoutput>#variables.ItemID#</cfoutput>" />
			<div class="formContainer" >
				<cfoutput>
				<span class="required requiredDesignation">Required Fields</span>
				<ul class="form pageForm vvv">
					<li class="required">
						<label>Title</label>
						<input type="text" name="Title" value="#Request.Item.Title#" />
					</li>
					<li class="required">
						<label>Description</label>
						<textarea name="Description">#Request.Item.Description#</textarea>
					</li>
					<li class="required">
						<label>Category</label>
						#Request.CategoryBox#
					</li>
					<li>
						<label>Start Date</label>
						<input type="text" name="StartDate" value="#Request.Item.StartDate#" class="datepicker" />
					</li>
					<li>
						<label>End Date</label>
						<input type="text" name="EndDate" value="#Request.Item.EndDate#" class="datepicker" />
					</li>
					<li class="required">
						<label>Price</label>
						<span style="float:left; font-size:16px; padding:5px 5px 0 0 ">$</span><input type="text" name="Price" value="#Request.Item.Price#" />
                        
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
	<cfinclude template="#Request.ViewManager.getViewPath('Links.Marketplace')#" />	
	<div class="module">
		<div class="moduleContent">
			<cfoutput>#Request.AdPlacementRight#</cfoutput>
		</div>
	</div>	
</div>

<script type="text/javascript">
	$().ready( function() {
		
		$('#MarketplaceForm').validate({
			rules: {
				<!--- <cfif variables.IsNewItem>
					TermsAndConditions: { required: true },
				</cfif> --->
				Title: { required: true, minlength: 2, maxlength: 50 },
				Description: { required: true, minlength: 4 },
				Category: { required: true },
				StartDate: { required: false, date: true },
				EndDate: { required: false, date: true },
				Price: { required: true, number: true, range: [1,100000] }, 
				Image: { required: false, accept: 'jpeg|jpg' }				
			}
		});
		
	});
</script>
