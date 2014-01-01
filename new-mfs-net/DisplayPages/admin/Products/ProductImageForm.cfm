<cfscript>
	variables.ImageManager = Request.ListenerManager.GetListener( "ImageManager" );
	
	variables.Images = StructNew();
	variables.Images.List = variables.ImageManager.GetImageUrl( Filename:request.ProductImage.ImageName, ImageCategory:"product", ImageType:"List" );
	variables.Images.Detail = variables.ImageManager.GetImageUrl( Filename:request.ProductImage.ImageName, ImageCategory:"product", ImageType:"Detail" );
	variables.Images.Enlarged = variables.ImageManager.GetImageUrl( Filename:request.ProductImage.ImageName, ImageCategory:"product", ImageType:"Enlarged" );
	variables.Images.Thumbnail = variables.ImageManager.GetImageUrl( Filename:request.ProductImage.ImageName, ImageCategory:"product", ImageType:"Thumbnail" );
</cfscript>

<script type="text/javascript" src="/Javascript/ProductImages.js"></script>

<cfif isDefined("URL.ProductID")>
	<cfset currProductID = URL.ProductID>
<cfelse>
	<cfset currProductID = form.productID>
</cfif>

<div id="ProductImageForm" class="inputForm">
	<form action="index.cfm?event=Admin.Product.Image.Submit" method="post" enctype="multipart/form-data" id="ProductImageEditForm">
		<cfoutput>
		<input type="hidden" name="ProductID" id="ProductID" value="#currProductID#" />
		<input type="hidden" name="ImageID" id="ImageID" value="<cfif Request.ProductImage.ImageID GT 0>#Request.ProductImage.ImageID#<cfelse>0</cfif>" />
		<input type="hidden" name="ReturnUrl" id="ReturnUrl" value="" />
		<ul class="form">    
			<li>
				<label>Type:</label>
				#request.TypeBox#
			</li>
			<li>
				<label>Existing Image Variations:</label>
				<table class="PermissionsTable">
					<tr>
						<th>Thumbnail</th>
						<th>List</th>
						<th>Detail</th>
						<th>Enlarged</th>						
					</tr>
					<tr>
						<td><img src="#variables.Images.Thumbnail#" /></td>
						<td><img src="#variables.Images.List#" /></td>
						<td><img src="#variables.Images.Detail#" /></td>
						<td><img src="#variables.Images.Enlarged#" /></td>						
					</tr>
				</table>				
			</li>
			<li>
				<label>Upload New Image:</label>
				<input type="file" name="ProductImageUpload" />
			</li>
		</ul>
		#Request.SubmitButtons#
		</cfoutput>
	</form>
</div>