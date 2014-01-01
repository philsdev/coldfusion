<cfscript>
	variables.LinkManager = Request.ListenerManager.GetListener( "LinkManager" );
	Request.RequiredOptionsList = "";
</cfscript>

<cfoutput query="Request.ProductOptions" group="GroupID">
	<cfset variables.ThisElement = "ProductOption__" & GroupID />
	<li>
		<label>#ProductAttributeName#</label>
		<select name="#variables.ThisElement#" class="ProductOption">
			<cfif NOT Required>
				<option value="">-- Choose One --</option>
			<cfelse>
				<cfset Request.RequiredOptionsList = ListAppend( Request.RequiredOptionsList, variables.ThisElement ) />
			</cfif>
			<cfoutput>
				<cfset variables.DisplayName = variables.LinkManager.GetDisplayName( OptionName ) />
				<cfif Price GT 0>
					<cfset variables.DisplayName = variables.DisplayName & " - " & DollarFormat( Price ) />
				<cfelseif AddPrice GT 0>
					<cfset variables.DisplayName = variables.DisplayName & " [Add " & DollarFormat( AddPrice ) & "]" />
				</cfif>
				<option		value="#OptionID#" 
							price="<cfif Price GT 0>#NumberFormat(Price,'9.99')#</cfif>" 
							addPrice="<cfif AddPrice GT 0>#NumberFormat(AddPrice,'9.99')#</cfif>"
				>#variables.DisplayName#</option>
			</cfoutput>
		</select>
		<!--- FANCYBOX THIS LINK TO THE SWATCH DISPLAY --->
		<!---
			<a  class="bottomNote swatchLink button grayButton">View Swatches</a>
		--->
	</li>
</cfoutput>