<script type="text/javascript" src="/Javascript/ProductOptions.js"></script>

<cfinclude template="inc_Messages.cfm" />

<div id="ProductForm" class="inputForm">

	<cfif URL.ProductID GT 0>
	
		<form action="index.cfm?event=Admin.Product.Option.Submit" method="post" id="ProductOptionEditForm">
			<cfoutput>
			<ul class="form">
			<input type="hidden" name="OptionID" id="OptionID" value="<cfif Request.DisplayOptionAssociation.OptionID GT 0>#Request.DisplayOptionAssociation.OptionID#<cfelse>0</cfif>" />
			<input type="hidden" name="ProductID" id="ProductID" value="#URL.ProductID#" />
			<input type="hidden" name="ReturnUrl" id="ReturnUrl" value="" />
			
			<li>
				<label>Option Name:</label>
				<input type="text" class="textinput limitedField" name="OptionName" id="OptionName" value="#request.DisplayOptionAssociation.OptionName#" />
			</li>
			<li>
				<label>Option Number:</label>
				<input type="text" class="textinput limitedField" name="OptionNumber" id="OptionNumber" value="#request.DisplayOptionAssociation.OptionNumber#" />
			</li>
			<li>
				<label>Option Image:</label>
				#request.DisplayOptionAssociation.OptionImage# &nbsp;
			</li>
			<!--- <li>
				<label>Upload New Image:</label>
				<input type="file" name="OptionImageUpload" />
			</li> --->
			<li>
				<label>Set Price:</label>
				<input type="text" class="textinput price" name="Price" id="Price" value="<cfif request.DisplayOptionAssociation.Price EQ "">0.00<cfelse>#request.DisplayOptionAssociation.Price#</cfif>" />
			</li>
			<li>
				<label>Additional Price:</label>
				<input type="text" class="textinput price" name="AddPrice" id="AddPrice" value="<cfif request.DisplayOptionAssociation.AddPrice EQ "">0.00<cfelse>#request.DisplayOptionAssociation.AddPrice#</cfif>" />
			</li>
			<li>
				<label>Attribute:</label>
				#request.AttributeBox#
			</li>
			<li>
				<label>Out Of Stock?:</label>
				#request.OutOfStockBox#
			</li>
			<li>
				<label>Required?:</label>
				#request.RequiredBox#
			</li>
			</ul>
			#Request.SubmitButtons#
			</cfoutput>
		</form>
	<cfelse>
		<p style="margin-left:10px;">You must create and save the product details before adding options.</p>
	</cfif>
</div>