<cfcomponent extends="MachII.framework.Listener">

	<cffunction name="GetNavigationParents" access="public" output="no" returntype="query">
    	
		<cfset var loc_NavigationParents = "" />
	
		<cfquery datasource="#request.dsource#" name="loc_NavigationParents">	
			SELECT			CategoryID,
							CategoryName
							
			FROM			Categories

			WHERE			ParentID = <cfqueryparam cfsqltype="cf_sql_integer" value="0" />	
			AND				CategoryStatus = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />	

			ORDER BY 		DisplayPosition
		</cfquery>
		
		<cfreturn loc_NavigationParents />		
	</cffunction>
	
	<cffunction name="GetNavigationCategories" access="public" output="no" returntype="query">
    	
		<cfset var loc_NavigationCategories = "" />
	
		<cfquery datasource="#request.dsource#" name="loc_NavigationCategories">	
			SELECT			C1.CategoryID AS Category1ID,
							C1.CategoryName AS Category1Name,
							C1.DisplayPosition AS Category1Position,
							CASE
								WHEN C2.CategoryID IS NOT NULL
								THEN COUNT(C1.CategoryID) OVER(PARTITION BY C1.CategoryID)
								ELSE 0
							END as Level1Count,
							C2.ParentID AS Category2Parent,
							C2.CategoryID AS Category2ID,
							C2.CategoryName AS Category2Name,
							C2.DisplayPosition AS Category2Position

			FROM			Categories C1

			LEFT JOIN		Categories C2 ON C1.CategoryID = C2.ParentID
			AND				C2.CategoryStatus = 1

			WHERE			C1.ParentID = 0
			AND				C1.CategoryStatus = 1

			ORDER BY 		Category1Position,
							Category2Position
		</cfquery>
		
		<cfreturn loc_NavigationCategories />		
	</cffunction>
	
	<cffunction name="GetProductNavigationCategories" access="public" output="no" returntype="query">
		<cfargument name="ProductID" type="numeric" required="yes" />
	
		<cfset var loc_ProductNavigationCategories = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_ProductNavigationCategories">			
			/* LEVEL 1 */
			select			TOP 1 CP.CategoryID,
							C.CategoryName,
							1 AS CategoryLevel

			from			CategoryProductAssoc CP
			join			Categories C ON CP.CategoryID = C.CategoryID AND C.ParentID = 0

			where			CP.ProductID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ProductID#" />
			and				CP.Status = 1

			/* LEVEL 2 */
			UNION

			select			TOP 1 CP.CategoryID,
							C.CategoryName,
							2 AS CategoryLevel

			from			CategoryProductAssoc CP
			join			Categories C ON CP.CategoryID = C.CategoryID AND C.ParentID IN (
								select			CP.CategoryID

								from			CategoryProductAssoc CP
								join			Categories C ON CP.CategoryID = C.CategoryID AND C.ParentID = 0

								where			CP.ProductID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ProductID#" />
								and				CP.Status = 1
							)

			where			CP.ProductID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ProductID#" />
			and				CP.Status = 1
			
			<!--- TODO: Add 3rd level --->
			
			UNION
				
			select			TOP 1 CP.CategoryID,
							C.CategoryName,
							3 AS CategoryLevel

			from			CategoryProductAssoc CP
			join			Categories C ON CP.CategoryID = C.CategoryID AND C.ParentID IN
									(
									select			CP.CategoryID as CatID2
									from			CategoryProductAssoc CP
									
									join	Categories C ON CP.CategoryID = C.CategoryID AND C.ParentID IN 
											(
											select			CP.CategoryID
											from			CategoryProductAssoc CP
											join			Categories C ON CP.CategoryID = C.CategoryID AND C.ParentID = 0
											where			CP.ProductID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ProductID#" />
											and				CP.Status = 1
											)
						where			CP.ProductID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ProductID#" />
						and				CP.Status = 1
									)
				where			CP.ProductID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ProductID#" />
				and				CP.Status = 1



			ORDER BY		CategoryLevel
		</cfquery>
		
		<cfreturn loc_ProductNavigationCategories />
	</cffunction>
	
	<!---cffunction name="GetProductNavigationCategories" access="public" output="no" returntype="query">
		<cfargument name="ProductID" type="numeric" required="yes" />
	
		<cfset var loc_ProductNavigationCategories = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_ProductNavigationCategories">	
			SELECT			C1.CategoryID AS Category1ID,
							C1.CategoryName AS Category1Name,
							C2.CategoryID AS Category2ID,
							C2.CategoryName AS Category2Name,
							C3.CategoryID AS Category3ID,
							C3.CategoryName AS Category3Name

			FROM			CategoryProductAssoc CP1
			JOIN			Categories C1 ON CP1.CategoryID = C1.CategoryID AND	C1.ParentID = 0

			LEFT JOIN		CategoryProductAssoc CP2 ON CP1.ProductID = CP2.ProductID AND CP2.Status = 1
			LEFT JOIN		Categories C2 ON CP2.CategoryID = C2.CategoryID AND	C2.ParentID = C1.CategoryID AND	C2.CategoryStatus = 1
			LEFT JOIN		CategoryProductAssoc CP3 ON CP2.ProductID = CP3.ProductID AND CP3.Status = 1
			LEFT JOIN		Categories C3 ON CP3.CategoryID = C3.CategoryID AND	C3.ParentID = C2.CategoryID AND	C3.CategoryStatus = 1

			WHERE			CP1.ProductID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ProductID#" />
			AND				CP1.Status = 1
			AND				C1.CategoryID IS NOT NULL
			AND				C2.CategoryID IS NOT NULL
			AND				C3.CategoryID IS NOT NULL
				
			GROUP BY		C1.CategoryID,
							C1.CategoryName,
							C2.CategoryID,
							C2.CategoryName,
							C3.CategoryID,
							C3.CategoryName
		</cfquery>
		
		<cfreturn loc_ProductNavigationCategories />
	</cffunction--->
	
</cfcomponent>