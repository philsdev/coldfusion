<script type="text/javascript" src="/Javascript/Products.js"></script>

<div id="ProductForm" class="inputForm">
	<form action="index.cfm?event=Admin.Product.Submit" method="post" id="ProductEditForm">
		<cfoutput>
		<input type="hidden" name="ProductID" id="ProductID" value="<cfif Request.Product.ProductID GT 0>#Request.Product.ProductID#<cfelse>0</cfif>" />
		<input type="hidden" name="ReturnUrl" id="ReturnUrl" value="" />
		<ul class="form">                        
			<li>
				<label>Product Name:</label>
				<input type="text" class="textinput limitedField" name="ProductName" id="ProductName" value="#request.Product.ProductName#" />
			</li>
			<li>
				<label>Product Number:</label>
				<input type="text" class="textinput limitedField" name="ProductNumber" id="ProductNumber" value="#request.Product.ProductItemNumber#" />
			</li>
			<li>
				<label>Status:</label>
				#request.StatusBox#
			</li>
			<li>
				<label>Taxable?</label>
				#request.TaxableBox#
			</li>
			<li>
				<label>Oversize?</label>
				#request.OversizeBox#
			</li>
			<li>
				<label>For Sale Online?</label>
				#request.ForSaleOnlineBox#
			</li>
			<li>
				<label>Engraving?</label>
				#request.EngraveBox#
			</li>
			<li>
				<label>Gold Stamp?</label>
				#request.GoldStampBox#
			</li>
			<li>
				<label>Memorial?</label>
				#request.MemorialBox#
			</li>
			<li>
				<label>Out Of Stock?</label>
				#request.OutOfStockBox#
			</li>
			<li>
				<label>Out Of Stock Message:</label>
				<input type="text" class="textinput limitedField" name="ProductOutOfStockMessage" id="ProductOutOfStockMessage" value="#request.Product.OutOfStockMessage#" />
			</li>
			<li>
				<label>Weight:</label>
				<input type="text" class="textinput weight" name="ProductWeight" id="ProductWeight" value="#request.Product.ProductWeight#" />
			</li>
			<li>
				<label>Vendor:</label>
				#request.VendorBox#
			</li>
			<li>
				<label>List Price:</label>
				<input type="text" class="textinput price" name="ProductListPrice" id="ProductListPrice" value="#request.Product.ProductListPrice#" />
			</li>	
			<li>
				<label>Our Price:</label>
				<input type="text" class="textinput price" name="ProductOurPrice" id="ProductOurPrice" value="#request.Product.ProductOurPrice#" />
			</li>	
			<li>
				<label>Discount Price:</label>
				<input type="text" class="textinput price" name="ProductDiscountPrice" id="DiscountPrice" value="#request.Product.ProductDiscountPrice#" />
			</li>				
		</ul>
		#Request.SubmitButtons#
		</cfoutput>
	</form>
</div>