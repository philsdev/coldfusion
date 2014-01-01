<script type="text/javascript">
	var __CategoryImageValidExtensionList = '<cfoutput>#REQUEST.Image.ValidExtensionList#</cfoutput>';
</script>
<script type="text/javascript" src="/Javascript/Categories.js"></script>

<div id="CategoryForm" class="inputForm">
	<form action="index.cfm?event=Admin.Category.Submit" method="post" enctype="multipart/form-data" id="CategoryEditForm">
		<cfoutput>
		<input type="hidden" name="CategoryID" id="CategoryID" value="<cfif Request.Category.CategoryID GT 0>#Request.Category.CategoryID#<cfelse>0</cfif>" />
		<input type="hidden" name="ReturnUrl" id="ReturnUrl" value="" />
		
		<ul class="form">                        
			<li class="required">
				<label>Category Name:</label>
				<input type="text" class="textinput limitedField" name="CategoryName" id="CategoryName" value="#request.Category.CategoryName#" />
			</li>
			<li class="required">
				<label>Description:</label>
				<textarea class="textinput" name="CategoryDescription" id="CategoryDescription">#request.Category.CategoryDesc#</textarea>
			</li>
			<li>
				<label>Parent:</label>
				#request.ParentBox#
			</li>
			<li class="required">
				<label>Display Position:</label>
				<input type="text" class="textinput" name="DisplayPosition" id="DisplayPosition" value="#request.Category.DisplayPosition#" />
			</li>
			<li>
				<label>Upload New Image:</label>
				<input type="file" name="CategoryImageUpload" />
			</li>
			<li class="required">
				<label>Status:</label>
				#request.StatusBox#
			</li>
		</ul>
		#Request.SubmitButtons#
		</cfoutput>
	</form>
</div>
