<script type="text/javascript" src="/Javascript/ProductUpsells.js"></script>

<cfinclude template="inc_Messages.cfm" />

<cfscript>
	variables.ProductUpsellManager = Request.ListenerManager.GetListener( "ProductUpsellManager" );
	variables.FirstCharacterList = "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,0,1,2,3,4,5,6,7,8,9";
</cfscript>

<div id="ProductForm" class="inputForm">
	<cfif URL.ProductID GT 0>
		<form action="index.cfm?event=Admin.Product.Upsell.Submit" method="post" id="ProductUpsellEditForm">
			<cfoutput>
			<input type="hidden" name="ProductID" id="ProductID" value="#URL.ProductID#" />
			<input type="hidden" name="ReturnUrl" id="ReturnUrl" value="" />
			<ul class="form">
				<li>
					<label>Search by:</label>
					<select id="UpsellSearchBy">
						<option value="ProductID">Product ID</option>
						<option value="ProductName">Product Name</option>
						<option value="VendorName">Vendor</option>
						<option value="ProductItemNumber">Product Item Number</option>						
					</select>
				</li>
				<li>
					<label>Starting with:</label>
					<span class="FirstCharacter">
					<cfloop list="#variables.FirstCharacterList#" index="variables.ThisChar">
						<a>#variables.ThisChar#</a>
					</cfloop>
					</span>
				</li>
				<li>
					<label>Available Products:</label>
					<span id="AvailableProductsWaiter" style="display:none"><img src="/images/calculating.gif" /></span>
					<span id="AvailableProductsContainer">
						<select multiple="multiple" size="10" class="textinput" id="AvailableProducts"></select>
					</span>
				</li>
				<li>
					<label>&nbsp;</label>
					<span class="ButtonLinks">
						<a class="OptionAdd">Add</a>
					</span>
				</li>
				<li>
					<label>Selected Products:</label>
					<select size="10" class="textinput" name="SelectedProductID" id="SelectedProducts">
						<cfloop query="request.ProductUpsells">
							<cfset variables.ProductUpsellTitle = variables.ProductUpsellManager.GetProductUpsellTitle(
								ProductID:request.ProductUpsells.ProductID,
								ProductTitle:request.ProductUpsells.ProductName,
								VendorName:request.ProductUpsells.VendorName,
								ProductItemNumber:request.ProductUpsells.ProductItemNumber
							) />
							<option value="#request.ProductUpsells.ProductID#">#variables.ProductUpsellTitle#</option>
						</cfloop>
					</select>
				</li>
				<li>
					<label>&nbsp;</label>
					<span class="ButtonLinks">
						<a class="OptionRemove">Remove</a>
						<a class="OptionMoveUp">Move Up</a>
						<a class="OptionMoveDown">Move Down</a>
					</span>
				</li>
			</ul>
			#Request.SubmitButtons#
			</cfoutput>
		</form>
	<cfelse>
		<p style="margin-left:10px;">You must create and save the product details before adding upsells.</p>
	</cfif>
</div>