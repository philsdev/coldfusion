<cfparam name="URL.PromotionID" default="0" />

<cfinclude template="inc_Messages.cfm" />

<script type="text/javascript" src="/Javascript/Promotions.js"></script>

<div class="TabbedPanels" id="TabbedPanels1">
<cfinclude template="inc_MainNavigation.cfm" />
	<div class="TabbedPanelsContentGroup">
		<div class="TabbedPanelsContent">
			<div class="formContainer">       		                 
				<div id="PromotionForm" class="inputForm">
					<form action="index.cfm?event=Admin.Promotion.Submit" method="post" id="PromotionEditForm">
						<cfoutput>
						<input type="hidden" name="PromotionID" id="PromotionID" value="<cfif Request.Promotion.PromotionID GT 0>#Request.Promotion.PromotionID#<cfelse>0</cfif>" />
						<input type="hidden" name="ReturnUrl" id="ReturnUrl" value="" />
						<ul class="form">                       
							<li>
								<label>Promotion Name:</label>
								<input type="text" class="textinput limitedField" name="PromotionName" id="PromotionName" value="#request.Promotion.PromotionName#" />
							</li>
							<li>
								<label>Promotion Code:</label>
								<input type="text" class="textinput limitedField" name="PromotionCode" id="PromotionCode" value="#request.Promotion.PromotionCode#" />
							</li>
							<li>
								<label>Redemption Maximum:</label>
								<input type="text" class="textinput number" name="RedemptionMaximum" id="RedemptionMaximum" value="#request.Promotion.RedemptionMaximum#" />
							</li>
							<li>
								<label>Order Minimum Amount:</label>
								<input type="text" class="textinput price" name="OrderMinimumAmount" id="OrderMinimumAmount" value="#request.Promotion.OrderMinimumAmount#" />
							</li>
							<li>
							
							<cfif request.Promotion.DiscountPercent NEQ "">
								<cfset variable.DiscountPercentVar = request.Promotion.DiscountPercent>
							<cfelse>
								<cfset variable.DiscountPercentVar = 0>
							</cfif>
								<label>Disount Percent:</label>
								<input type="text" class="textinput percent" name="DiscountPercent" id="DiscountPercent" value="#variable.DiscountPercentVar#" />
							</li>
							<li>
							
							<cfif request.Promotion.DiscountAmount NEQ "">
								<cfset variable.DiscountAmountVar = request.Promotion.DiscountAmount>
							<cfelse>
								<cfset variable.DiscountAmountVar = 0>
							</cfif>
								<label>Discount Amount:</label>
								<input type="text" class="textinput price" name="DiscountAmount" id="DiscountAmount" value="#variable.DiscountAmountVar#" />
							</li>
							<li>
								<label>Start Date:</label>
								<input type="text" class="textinput datepicker" name="StartDate" id="StartDate" value="#request.Promotion.StartDate#" />
							</li>
							<li>
								<label>End Date:</label>
								<input type="text" class="textinput datepicker" name="EndDate" id="EndDate" value="#request.Promotion.EndDate#" />
							</li>
							<li>
								<label>Status:</label>
								#request.StatusBox#
							</li>
						</ul>
						#Request.SubmitButtons#
						</cfoutput>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>