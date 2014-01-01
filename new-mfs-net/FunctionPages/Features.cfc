<cfcomponent extends="MachII.framework.Listener">

	<cffunction name="GetFeatures" access="public" output="no" returntype="query">    		
		<cfset var loc_GetFeature = "" />		
		
		<cfquery datasource="#request.dsource#" name="loc_GetCategoryFeatured">
			SELECT 		FC.FeatureID, 
						FC.CategoryID, 
						FC.DisplayPosition, 
						C.CategoryName
						
			FROM 		HomepageFeaturedCategory FC 			
			LEFT JOIN	Categories C ON FC.CategoryID = C.CategoryID
			
			ORDER BY 	FC.DisplayPosition
		</cfquery>
		
		<cfreturn loc_GetCategoryFeatured />	
		
	</cffunction>
	
	<cffunction name="UpdateFeatures" returntype="void" output="no">		
		<cfargument name="SelectedProductID" type="string" required="yes" />
		<cfargument name="ReturnUrl" type="string" required="no" />
		
		<cfset var loc_AvailableProducts = "" />
		<cfset var loc_ProductIDList = "" />
		<cfset var loc_ThisProductID = "" />
		<cfset var loc_ThisProductCount = 0 />
		
		<!--- reduce possible dupes --->
		<cfloop list="#Arguments.SelectedProductID#" index="loc_ThisProductID">
			<cfif NOT ListFind( loc_ProductIDList, loc_ThisProductID )>
				<cfset loc_ProductIDList = ListAppend( loc_ProductIDList, loc_ThisProductID ) />
			</cfif>
		</cfloop>
		
		<cfquery datasource="#request.dsource#" name="loc_AvailableProducts">
			DELETE
			FROM		HomepageFeaturedCategory
		
			<cfloop list="#loc_ProductIDList#" index="loc_ThisProductID">
				<cfset loc_ThisProductCount = IncrementValue( loc_ThisProductCount ) />
				
				INSERT INTO HomepageFeaturedCategory (
					CategoryID,
					DisplayPosition
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#loc_ThisProductID#" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#loc_ThisProductCount#" />
				);
			</cfloop>
		</cfquery>
		
		
		<cfset loc_StatusMessage = "Feature.Updated" />
		
				
		<cflocation url="#Arguments.ReturnUrl#&Message=#loc_StatusMessage#" addtoken="no" />
		
	</cffunction>
	
</cfcomponent>