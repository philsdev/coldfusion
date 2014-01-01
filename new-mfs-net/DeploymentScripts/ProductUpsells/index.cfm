<!--- 
	
	Copy 4 related product ID cols into new related table
	
	NOTE: can't use queryparams since it will max out the request (limit 2,100 params)

--->

<cfsetting requesttimeout="600" showdebugoutput="no" />

<cfquery datasource="#request.dsource#" name="variables.Products">
	SELECT		ProductID,
				ProductRelated1,
				ProductRelated2,
				ProductRelated3,
				ProductRelated4
	FROM		Products
	WHERE		DATALENGTH(ProductRelated1) > 0
</cfquery>

<cfif variables.Products.RecordCount>
	<p>Starting on <cfoutput>#variables.Products.RecordCount#</cfoutput> products .....</p>
	<cfflush />
	<cfquery datasource="#request.dsource#" name="variables.Products">
		<cfoutput query="variables.Products">
			<cfif IsNumeric(variables.Products.ProductRelated1)>
				INSERT INTO ProductUpsells (
					MainProductID, 
					AssocProductID,
					DisplayPosition
				) VALUES (
					#variables.Products.ProductID#,
					#variables.Products.ProductRelated1#,
					1
				);
			</cfif>
			<cfif IsNumeric(variables.Products.ProductRelated2)>
				INSERT INTO ProductUpsells (
					MainProductID, 
					AssocProductID,
					DisplayPosition
				) VALUES (
					#variables.Products.ProductID#,
					#variables.Products.ProductRelated2#,
					2
				);
			</cfif>
			<cfif IsNumeric(variables.Products.ProductRelated3)>
				INSERT INTO ProductUpsells (
					MainProductID, 
					AssocProductID,
					DisplayPosition
				) VALUES (
					#variables.Products.ProductID#,
					#variables.Products.ProductRelated3#,
					3
				);
			</cfif>
			<cfif IsNumeric(variables.Products.ProductRelated4)>
				INSERT INTO ProductUpsells (
					MainProductID, 
					AssocProductID,
					DisplayPosition
				) VALUES (
					#variables.Products.ProductID#,
					#variables.Products.ProductRelated4#,
					4
				);
			</cfif>
		</cfoutput>
	</cfquery>
	<p>Done!</p>
	<cfflush />
<cfelse>
	<p>No records!</p>
</cfif>