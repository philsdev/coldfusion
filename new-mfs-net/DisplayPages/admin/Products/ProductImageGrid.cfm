<cfset variables.ImageManager = Request.ListenerManager.GetListener( "ImageManager" ) />

<cfif isDefined("URL.ProductID")>
	<cfset currProductID = URL.ProductID>
<cfelse>
	<cfset currProductID = productID>
</cfif>


<script type="text/javascript" src="/Javascript/ProductImages.js"></script>

<div id="ProductForm" class="inputForm">
	<cfif currProductID GT 0>
		<cfif request.ProductImages.recordcount GT 0>
			<h2 class="sectionTitle">Images</h2>
			<table class="existingItemsTable" cellspacing="0" cellpadding="0">
				<thead>
					<tr>
						<th class="left">Thumbnail</th>
						<th>Filename</th>
						<th>Type</th>
						<th>Functions</th>
					</tr>
				</thead>
				<tbody>
				<cfoutput query="request.ProductImages">
					<cfset variables.Images = StructNew() />
					<cfset variables.Images.Thumbnail = variables.ImageManager.GetImageUrl( Filename:request.ProductImages.ImageName, ImageCategory:"product", ImageType:"thumbnail" ) />
					<cfset variables.Images.Enlarged = variables.ImageManager.GetImageUrl( Filename:request.ProductImages.ImageName, ImageCategory:"product", ImageType:"enlarged" ) />
					<tr rowid="#request.ProductImages.ImageID#">
						<td class="left"><a href='#variables.Images.Enlarged#' class='fancyProduct'><img src='#variables.Images.Thumbnail#' /></a></td>
						<td>#request.ProductImages.ImageName#</td>
						<td>#request.ProductImages.ImageType#</td>
						<td class="functions"><a>Edit</a> | <a>Delete</a></td>      
					</tr>
				</cfoutput>
				</tbody>                    
			</table>
		<cfelse>
			<p style="margin-left:10px;">There were no images found.</p>
		</cfif>
	<cfelse>
		<p style="margin-left:10px;">You must create and save the product details before adding images.</p>
	</cfif>
</div>
<button>Add New Image</button>		