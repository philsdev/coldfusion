<cfinclude template="inc_Messages.cfm" />

<script type="text/javascript" src="/Javascript/Products.js"></script>

<div class="TabbedPanels" id="TabbedPanels1">
<cfinclude template="inc_MainNavigation.cfm" />
	<div class="TabbedPanelsContentGroup">
		<div class="TabbedPanelsContent">
		
			<div id="navigation" >
				<form action="javascript:void(0)" method="post" id="ProductSearch">
					<h2 class="sectionTitle">Search Products</h2>
					<ul class="form">
						<li>
							<label>Product Name:</label>
							<input type="text" name="ProductName" value=""  />
						</li>
						<li>
							<label>Item Number:</label>
							<input type="text" name="ProductItemNumber" value=""  />
						</li>
						<li id="ProductCategoryNode">
							<label>Category:</label>
							<span id="ProductCategoryOptionsContainer">
								<cfoutput>#request.CategoryBox#</cfoutput>
							</span>
						</li>
						<li id="ProductSubcategoryNode" style="display:none;margin-left:10px">
							<span id="ProductSubcategoryOptionsContainer"></span>
						</li>
						<li id="ProductSubSubcategoryNode" style="display:none;margin-left:20px">
							<span id="ProductSubSubcategoryOptionsContainer"></span>
						</li>
						<li>
							<label>Vendor:</label>
							<cfoutput>#request.VendorBox#</cfoutput>
						</li>
						<li>
							<label>Description:</label>
							<input type="text" name="Description" value=""  />
						</li>
						<li>
							<label>Keywords:</label>
							<input type="text" name="ProductKeywords" value=""  />
						</li>
						<li>
							<label>Status:</label>
							<cfoutput>#request.StatusBox#</cfoutput>
						</li>
						<li>
							<label>Sort:</label>
							<cfoutput>#Request.SortBox#</cfoutput>
						</li>
						<li>
							<label>Order:</label>
							<cfoutput>#Request.SordBox#</cfoutput>
						</li>
					</ul>
					<div class="submitButtonContainer mb10">
						<button>Submit</button>
					</div>
				</form>
			</div>
			
			<div id="content">
				<div class="formContainer"><cfoutput>#request.ProductGrid#</cfoutput></div>
			</div>
			
		</div>
	</div>
</div>