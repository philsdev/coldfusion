<script type="text/javascript" src="/Javascript/ProductCategories.js"></script>

<cfinclude template="inc_Messages.cfm" />

<div id="ProductForm" class="inputForm">

	<cfif URL.ProductID GT 0>
		<form action="index.cfm?event=Admin.Product.Category.Submit" method="post" id="ProductCategoryEditForm">
			<cfoutput>
			<input type="hidden" name="ProductID" id="ProductID" value="#URL.ProductID#" />
			<input type="hidden" name="ReturnUrl" id="ReturnUrl" value="" />
			</cfoutput>
			
			<cfset ListCategoryAssoc = "#valuelist(request.DisplayCategoryAssociation.CategoryID)#">
			
			<ul class="form">
			<cfif request.Categories.recordcount GT 0>
			<h2 class="sectionTitle">Available Categories</h2>
			<table class="existingItemsTable" width="100%" cellspacing="0" cellpadding="0">
				<thead>
					<tr>
						<th class="left">Category Name</th>
						<th>Status</th>
						<th>Select</th>
					</tr>
				</thead>
				<tbody>
				<cfoutput query="request.Categories" group="Category1ID">
					<tr rowid="#Category1ID#" class="tree" level="1">
						<td class="level1 <cfif listfind(ListCategoryAssoc, Category1ID) GT 0 AND Level1Count GT 0>minus<cfelseif Level1Count GT 0>plus</cfif>">#Category1Name#</td>
						<td>#Status1#</td>
						<td class="functions"><input  class="editing" value="#Category1ID#" name="categoryid" parentid="#Category1ID#"  level="1" type="checkbox" <cfif listfind(ListCategoryAssoc, Category1ID) GT 0>checked</cfif> ></td>      
					</tr>
					<cfoutput group="Category2ID">
						<cfif Level1Count GT 0>
							<tr rowid="#Category2ID#" class="tree" level="2" parent="#Category2Parent#" style="display:<cfif listfind(ListCategoryAssoc, Category1ID) GT 0>show<cfelse>none</cfif>">
								<td class="level2 <cfif listfind(ListCategoryAssoc, Category2ID) GT 0 AND Level2Count GT 0>minus<cfelseif Level2Count GT 0>plus</cfif>">#Category2Name#</td>
								<td>#Status2#</td>
								<td class="functions"><input  class="editing" value="#Category2ID#"  name="categoryid" parentid="#Category2ID#"  level="2"  type="checkbox" <cfif listfind(ListCategoryAssoc, Category2ID) GT 0>checked</cfif> ></td>      
							</tr>	
							<cfif Level2Count GT 0>
								<cfoutput>
									<tr rowid="#Category3ID#" class="tree" level="3" parent="#Category3Parent#" grandparent="#Category2Parent#"  style="display:<cfif listfind(ListCategoryAssoc, Category2ID) GT 0>show<cfelse>none</cfif>">
										<td class="level3">#Category3Name#</td>
										<td>#Status3#</td>
										<td class="functions"><input class="editing" value="#Category3ID#" name="categoryid" parentid="#Category3ID#" level="3" type="checkbox" <cfif listfind(ListCategoryAssoc, Category3ID) GT 0>checked</cfif> ></td>      
									</tr>			
								</cfoutput>
							</cfif>
						</cfif>
					</cfoutput>
				</cfoutput>
				</tbody>                    
			</table>
			</cfif>
			<cfoutput>
			#Request.SubmitButtons#
			</cfoutput>
		</form>
	<cfelse>
		<p style="margin-left:10px;">You must create and save the product details before adding categories.</p>
	</cfif>
</div>