<cfquery datasource="#request.dsource#" name="variables.ProductOptions">
	SELECT			PriceNew AS Price,
					AddPriceNew AS AddPrice
					
	FROM        	ProductOptionsAssoc
</cfquery>

<cfoutput query="variables.ProductOptions">
	<cfif not isnumeric(variables.ProductOptions.Price)>
		<p>Price: #variables.ProductOptions.Price#</p>
	</cfif>
	<cfif not isnumeric(variables.ProductOptions.AddPrice)>
		<p>AddPrice: #variables.ProductOptions.AddPrice#</p>
	</cfif>
</cfoutput>