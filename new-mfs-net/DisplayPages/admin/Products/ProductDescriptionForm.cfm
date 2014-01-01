<div id="ProductForm" class="inputForm">
	<cfif URL.ProductID GT 0>
		<form action="index.cfm?event=Admin.Product.Description.Submit" method="post" id="ProductDescriptionEditForm">
			<cfoutput>
			<input type="hidden" name="ProductID" id="ProductID" value="#URL.ProductID#" />
			<input type="hidden" name="ReturnUrl" id="ReturnUrl" value="" />
			<ul class="form">
				<li>
					<label>Short Description:</label>
					<textarea class="textinput" name="ShortDescription">#request.ProductDescriptions.ProductShortDesc#"</textarea>
				</li>
				<li>
					<label>Long Description:</label>
					<textarea class="textinput" name="LongDescription">#request.ProductDescriptions.ProductLongDesc#"</textarea>
				</li>
			</ul>
			#Request.SubmitButtons#
			</cfoutput>
		</form>
	<cfelse>
		<p style="margin-left:10px;">You must create and save the product details before adding descriptions.</p>
	</cfif>
</div>