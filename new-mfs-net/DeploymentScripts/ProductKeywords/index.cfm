<!--- 
	
	Copy comma-delimited list of keywords from Products.ProductKeywords to its own table
	
	NOTE: can't use queryparams since it will max out the request (limit 2,100 params)

--->

<cfsetting requesttimeout="600" showdebugoutput="no" />

<cfquery datasource="#request.dsource#" name="variables.Products">
	SELECT		ProductID,
				ProductKeywords
	FROM		Products
	WHERE		DATALENGTH(ProductKeywords) > 0
	<!--- AND	ProductID > 11000 --->
</cfquery>

<cfif variables.Products.RecordCount>
	<p>Starting on <cfoutput>#variables.Products.RecordCount#</cfoutput> products .....</p>
	<cfflush />
	<cfquery datasource="#request.dsource#" name="variables.Products">
		<cfoutput query="variables.Products">
			<cfloop list="#variables.Products.ProductKeywords#" index="variables.ThisKeyword">
				<cfif len(trim(variables.ThisKeyword))>
					INSERT INTO ProductKeywords (
						ProductID, 
						Keyword
					) VALUES (
						#variables.Products.ProductID#,
						'#LEFT( TRIM( variables.ThisKeyword ), 255)#'
					);
				</cfif>
			</cfloop>
		</cfoutput>
	</cfquery>
	<p>Done!</p>
	<cfflush />
<cfelse>
	<p>No records!</p>
</cfif>