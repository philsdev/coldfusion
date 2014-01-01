<script type="text/javascript" src="/Javascript/ReportPurchasedProducts.js"></script>

<div class="TabbedPanels" id="TabbedPanels1">
<cfinclude template="inc_MainNavigation.cfm" />
	<div class="TabbedPanelsContentGroup">
		<div class="TabbedPanelsContent">
		
			<div id="navigation" >
				<form action="javascript:void(0)" method="post" id="PurchasedProductsSearch">
					<h2 class="sectionTitle">Search Purchased Productss</h2>
					<ul class="form">
						<li>
							<label>Purchased Products:</label>
							<input type="text" name="PurchasedProducts" value=""  />
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