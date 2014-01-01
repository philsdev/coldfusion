<cfcomponent hint="This component will handle editing product descriptions" extends="MachII.framework.Listener">
	
	<cffunction name="GetProductDescriptions" returntype="query" output="no">		
		<cfargument name="ProductID" type="numeric" default="0" />
		
		<cfset var loc_ProductDescriptions = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_ProductDescriptions">
			SELECT			ProductShortDesc,
							ProductLongDesc
							
			FROM			Products
				
			WHERE			ProductID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ProductID#" />
		</cfquery>
		
		<cfreturn loc_ProductDescriptions />	
	</cffunction>

</cfcomponent>