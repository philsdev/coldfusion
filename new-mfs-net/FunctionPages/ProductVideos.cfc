<cfcomponent hint="This component will handle editing site administrators" extends="MachII.framework.Listener">
	
	<cffunction name="GetProductVideos" returntype="query" output="no">		
		<cfargument name="ProductID" type="numeric" default="0" />
		
		<cfset var loc_ProductVideos = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_ProductVideos">
			SELECT			V.VideoID,
							V.VideoKey,
							V.Title,
							CONVERT(CHAR(10),V.DateCreated,101) AS DateCreated,
							S.Status
			FROM			ProductVideos V
			JOIN			Status S ON V.Status = S.ID
				
			WHERE			V.ProductID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ProductID#" />
			
			ORDER BY 		V.Title
		</cfquery>
		
		<cfreturn loc_ProductVideos />	
	</cffunction>	
	
	<cffunction name="GetProductVideoDetails" returntype="query" output="no">
		<cfargument name="VideoID" type="numeric" default="0" />
		
		<cfset var loc_VideoDetails = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_VideoDetails">
			SELECT		V.VideoID,
						V.ProductID,
						V.VideoKey,
						V.Title,
						V.Status
			FROM		ProductVideos V
			WHERE		V.VideoID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.VideoID#" />
		</cfquery>
		
		<cfreturn loc_VideoDetails />	
	</cffunction>

</cfcomponent>