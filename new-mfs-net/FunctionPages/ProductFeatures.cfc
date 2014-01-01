<cfcomponent extends="MachII.framework.Listener">
	
	<cffunction name="GetProductFeatures" returntype="query" output="no">
	
		<cfset var loc_ProductFeatures = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_ProductFeatures">
			SELECT		PF.FeatureID,
						PF.ProductID,
						P.ProductName,
						PI.ImageName,
						CASE
							WHEN P.ProductDiscountPrice > 0 
							THEN P.ProductDiscountPrice
							ELSE P.ProductOurPrice
						END AS ProductPrice
						
			FROM		ProductFeatures PF
			JOIN		Products P ON PF.ProductID = P.ProductID
			JOIN		ProductImages PI ON P.ProductID = PI.ProductID AND PI.ImageTypeID = 1
			
			ORDER BY	PF.DisplayPosition
		</cfquery>
		
		<cfreturn loc_ProductFeatures />	
	</cffunction>

</cfcomponent>