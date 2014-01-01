<cfcomponent extends="MachII.framework.Listener">
	
	<cffunction name="UpdateProductCategory" returntype="query" output="no">
		<cfargument name="CategoryID" type="string" required="yes">		
		<cfargument name="ProductID" type="numeric" required="yes" />
		<cfargument name="ReturnUrl" type="string" required="yes" />
		
		<cfset var loc_StatusMessage = "" />
		
		
		<!--- delete old categories --->
		
		<cfquery datasource="#request.dsource#" name="loc_deleteProductCategories">
			DELETE 
			FROM CategoryProductAssoc
			WHERE ProductID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ProductID#" />
		</cfquery>
		
		<cfloop list="#trim(Arguments.CategoryID)#" index="iCat">
		<cfquery datasource="#request.dsource#" name="loc_ProductCategories">
			INSERT INTO CategoryProductAssoc
						(CategoryID,
						ProductID,
						Status)
					VALUES
						('#iCat#',
						'#Arguments.ProductID#',
						1)
		</cfquery>
		</cfloop>
		
		<cfset loc_StatusMessage = "Product Categories Updated" />
		
		<cflocation url="#Arguments.ReturnUrl#&Message=#loc_StatusMessage#" addtoken="no" />
	</cffunction>

</cfcomponent>