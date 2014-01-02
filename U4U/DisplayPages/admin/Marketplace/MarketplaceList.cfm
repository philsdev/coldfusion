<cfinclude template="inc_Messages.cfm" />

<script type="text/javascript" src="/Javascript/Marketplace.js"></script>

<div class="TabbedPanels" id="TabbedPanels1">
<cfinclude template="inc_MainNavigation.cfm" />
	<div class="TabbedPanelsContentGroup">
		<div class="TabbedPanelsContent">
		
			<div id="navigation" >
				<form action="javascript:void(0)" method="post" id="MarketplaceSearch">
					<h2 class="sectionTitle">Search Marketplace</h2>
					<ul class="form">
						<li>
							<label>Title:</label>
							<input type="text" name="Title" value=""  />
						</li>
						<li>
							<label>Category:</label>
							<cfoutput>#Request.CategoryBox#</cfoutput>
						</li>
						<li>
							<label>Price (min):</label>
							<input type="text" name="PriceMin" value="" />
						</li>
						<li>
							<label>Price (max):</label>
							<input type="text" name="PriceMax" value=""/>
						</li>
						<li>
							<label>Start Date:</label>
							<input type="text" name="StartDate" value="" class="datepicker"  />
						</li>
						<li>
							<label>End Date:</label>
							<input type="text" name="EndDate" value="" class="datepicker"  />
						</li>
						<li>
							<label>Status:</label>
							<cfoutput>#Request.StatusBox#</cfoutput>
						</li>
						<li>
							<label>Sort:</label>
							<cfoutput>#Request.SortBox#</cfoutput>
						</li>
					</ul>
					<div class="submitButtonContainer mb10">
						<button>Submit</button>
					</div>
				</form>
			</div>
			
			<div id="content">
				<div class="formContainer"><cfoutput>#Request.MarketplaceGrid#</cfoutput></div>
			</div>
			
		</div>
	</div>
</div>