<script type="text/javascript" src="/Javascript/Reports.js"></script>

<cfparam name="request.Reports.recordcount" default="0">

<cfif request.Reports.recordcount GT 0>
	<cfset loc_StartDate = request.Reports.StartDate>
	<cfset loc_EndDate = request.Reports.EndDate>
	<cfset loc_SelectedProductID = request.Reports.SelectedProductID>
	<cfset loc_TotalRangeLT = request.Reports.TotalRangeLT>
	<cfset loc_TotalRangeGT = request.Reports.TotalRangeGT>
	<cfset loc_ProductCategory = request.Reports.ProductCategory>
	
<cfelse>
	<cfset loc_StartDate = "">
	<cfset loc_EndDate = "">
	<cfset loc_SelectedProductID = "">
	<cfset loc_TotalRangeLT = "">
	<cfset loc_TotalRangeGT = "">
	<cfset loc_ProductCategory = "">
</cfif>

<cfset CatID_1 = "0">
<cfset CatID_2 = "0">
<cfset CatID_3 = "0"> 
 
<cfoutput>
<cfloop from="1" to="#listlen(loc_ProductCategory)#" index="ind">
	<cfset "CatID_#ind#" =  ListGetAt(loc_ProductCategory,  ind)>
</cfloop>
</cfoutput>


<cfscript>
	variables.ProductUpsellManager = Request.ListenerManager.GetListener( "ProductUpsellManager" );
	variables.FirstCharacterList = "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,0,1,2,3,4,5,6,7,8,9";
</cfscript>

<div class="TabbedPanels" id="TabbedPanels1">
<cfinclude template="inc_MainNavigation.cfm" />
<cfoutput>
	<div class="TabbedPanelsContentGroup">
		<div class="TabbedPanelsContent">
				<!---  <form action="javascript:void(0)" method="post" id="ReportEditForm" >  --->
				<form action="index.cfm?event=Admin.Report.Search" method="post" id="ReportEditForm" >
				<input type="hidden" name="loc_SelectedProductID" value="#loc_SelectedProductID#">
					<h2 class="sectionTitle">Sales Reports</h2>
					<ul class="form">
						<li>
							<label>Start Date:</label>
							<!--- <input id="StartDate" class="textinput datepicker" type="text" value="#DateFormat(dateAdd('m',  '-1',  now()),'mm/dd/yyyy')#" name="StartDate" style="width: 100px;"> --->
							<input id="StartDate" class="textinput datepicker" type="text" name="StartDate" style="width: 100px;" value="#DateFormat(loc_StartDate,'mm/dd/yyyy')#" >
						</li>
						<li>
							<label>End Date:</label>
							<!--- <input id="EndDate" class="textinput datepicker" type="text" value="#DateFormat(now(),'mm/dd/yyyy')#" name="EndDate" style="width: 100px;"> --->
							<input id="EndDate" class="textinput datepicker" type="text" name="EndDate" style="width: 100px;" value="#DateFormat(loc_EndDate,'mm/dd/yyyy')#" >
						</li>
						<li id="ProductCategoryNode">
							<label>Category: #CatID_1#</label>
							<span id="ProductCategoryOptionsContainer">
								#request.CategoryBox# 
							</span>
						</li>
						<li id="ProductSubcategoryNode" style="display:none;margin-left:10px">
							<label>SubCategory: #CatID_2#  </label>
							<span id="ProductSubcategoryOptionsContainer"></span>
						</li>
						<li id="ProductSubSubcategoryNode" style="display:none;margin-left:20px">
							<label>Sub-SubCategory:  #CatID_3#</label>
							<span id="ProductSubSubcategoryOptionsContainer"></span>
						</li>
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
					</span>
				</li>
						<li>
							<label>Order Total Greater Than:</label>
							$ <input id="TotalRangeGT" type="text" value="#loc_TotalRangeGT#" name="TotalRangeGT" style="width: 100px;">
						</li>
						<li>
							<label>Order Total Less Than:</label>
							$ <input id="TotalRangeLT" type="text" value="#loc_TotalRangeLT#" name="TotalRangeLT" style="width: 100px;">
						</li>
						<cfif request.Reports.recordcount GT 0>
							<li>
								<label>Total Orders:</label>
								<strong>#request.Reports.TotalOrders#</strong>
							</li>
							<li>	
								<label>Total Sales:</label>
								<strong>#dollarformat(request.Reports.TotalOrdered)#</strong>
							</li>
						</cfif>
						
					</ul>
					<div class="submitButtonContainer mb10">
						<button>Submit</button>
					</div>
				</form>
				
		</div>
	</div>
</cfoutput>
</div>