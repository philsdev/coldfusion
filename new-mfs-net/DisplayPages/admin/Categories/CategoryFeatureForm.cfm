 <script type="text/javascript" src="/Javascript/CategoryFeatures.js"></script>

<!---<cfinclude template="inc_Messages.cfm" /> --->

<!--- <cfscript>
	variables.ProductFeatureManager = Request.ListenerManager.GetListener( "ProductFeatureManager" );
	variables.FirstCharacterList = "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,0,1,2,3,4,5,6,7,8,9";
</cfscript> --->

<div id="CategoryForm" class="inputForm">
	<cfif URL.CategoryID GT 0>
		<form action="index.cfm?event=Admin.Category.Feature.Submit" method="post" id="ProductFeatureEditForm">
			<cfoutput>
			<input type="hidden" name="CategoryID" id="CategoryID" value="#URL.CategoryID#" />
			<input type="hidden" name="ReturnUrl" id="ReturnUrl" value="" />
			<ul class="form">
				<li>
					<label>Available Products:</label>
					<select size="10" class="textinput" name="AvailableProductID" id="AvailableProducts" multiple>
						<cfloop query="request.CategoryProducts">
							<option value="#request.CategoryProducts.ProductID#">#request.CategoryProducts.ProductName#</option>
						</cfloop>
					</select>
					</span>
				</li>
				<li>
					<label>&nbsp;</label>
					<span class="ButtonLinks">
						<a class="OptionAdd">Add</a>
					</span>
				</li>
				<li>
					<label>Featured Products:</label>
					<select size="12" class="textinput" name="SelectedProductID" id="SelectedProducts" multiple>
						
						<cfloop query="request.CategoryFeatured">
							<option value="#request.CategoryFeatured.ProductID#">#request.CategoryFeatured.ProductName#</option>
						</cfloop>
					</select>
					<input type="hidden" name="SelectedProductID" id="SelectedProducts" value="" >
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
		<p style="margin-left:10px;">You must create and save the category details before adding features.</p>
	</cfif>
</div>