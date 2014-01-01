<cfparam name="URL.Message" default="" />
<cfparam name="URL.Tab" default="0" />
<cfparam name="URL.ProductAttributeID" default="0" />


<cfinclude template="inc_Messages.cfm" />

<script type="text/javascript" src="/Javascript/Attributes.js"></script>

<div class="TabbedPanels" id="TabbedPanels1">
<cfinclude template="inc_MainNavigation.cfm" />
	<div class="TabbedPanelsContentGroup">
		<div class="TabbedPanelsContent">
		
			<div id="ProductForm" class="inputForm">

				<form action="index.cfm?event=Admin.Attribute.Submit" method="post" id="AttributeEditForm">
					<cfoutput>
					<ul class="form">
					<input type="hidden" name="ProductAttributeID" id="ProductAttributeID" value="<cfif Request.Attributes.ProductAttributeID GT 0>#Request.Attributes.ProductAttributeID#<cfelse>0</cfif>" />
					<!--- <input type="hidden" name="ProductID" id="ProductID" value="#url.ProductID#" /> --->
					<input type="hidden" name="ReturnUrl" id="ReturnUrl" value="" />
					
					<li>
						<label>Attribute Name:</label>
						<input type="text" class="textinput limitedField" name="ProductAttributeName" id="ProductAttributeName" value="#request.Attributes.ProductAttributeName#" />
					</li>
					<li>
						<label>Active?:</label>
						#request.ProductAttributeStatusBox#
					</li>
					</ul>
					#Request.SubmitButtons#
					</cfoutput>
				</form>

			</div>

		</div>		
	</div>
</div>