<cfinclude template="inc_Messages.cfm" />

<script type="text/javascript" src="/Javascript/Orders.js"></script>

<div class="TabbedPanels" id="TabbedPanels1">
<cfinclude template="inc_MainNavigation.cfm" />
	<div class="TabbedPanelsContentGroup">
		<div class="TabbedPanelsContent">
		
			<div id="navigation" >
				<form action="javascript:void(0)" method="post" id="OrderSearch">
					<h2 class="sectionTitle">Search Orders</h2>
					<ul class="form">
						<li>
							<label>Billing Last Name:</label>
							<input type="text" name="BillLastName" value=""  />
						</li>
						<li>
							<label>Shipping Last Name:</label>
							<input type="text" name="ShipLastName" value=""  />
						</li>
						<li>
							<label>Order ID:</label>
							<input type="text" name="orderID" value=""  />
						</li>
						<li>
							<label>Order Date:</label>
							<input id="DateOrdered" class="textinput datepicker" type="text" value="" name="DateOrdered" style="width: 100px;">
						</li>
						<li>
							<label>Order Total $:</label>
							<input type="text" name="OrderTotal" value=""  />
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
				<div class="formContainer"><cfoutput>#request.OrderGrid#</cfoutput></div>
			</div>
			
		</div>
	</div>
</div>