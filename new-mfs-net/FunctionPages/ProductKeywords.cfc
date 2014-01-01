<cfcomponent hint="This component will handle editing site administrators" extends="MachII.framework.Listener">
	
	<cffunction name="GetProductKeywords" returntype="query" output="no">
		<cfargument name="ProductID" type="numeric" default="0" />
		
		<cfset var loc_ProductKeywords = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_ProductKeywords">
			SELECT		Keyword
			FROM		ProductKeywords
			WHERE		ProductID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ProductID#" />
		</cfquery>
		
		<cfreturn loc_ProductKeywords />	
	</cffunction>	
	
	<cffunction name="UpdateProductKeywords" access="public" output="yes" returntype="void">
		<cfargument name="ProductID" type="numeric" default="0" />
		<cfargument name="ProductKeyword" type="string" default="" />
		
		<cfset var loc_KeywordList = Arguments.ProductKeyword />
		<cfset var loc_UpdateProductKeywords = "" />
		<cfset var loc_ThisKeyword = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_UpdateProductKeywords">
			DELETE
			FROM		ProductKeywords
			WHERE		ProductID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ProductID#" />;
			
			<cfif ListLen( loc_KeywordList )>
				<cfloop list="#loc_KeywordList#" index="loc_ThisKeyword">
					<cfif LEN(TRIM(loc_ThisKeyword))>
						INSERT INTO ProductKeywords (
							ProductID,
							Keyword
						) VALUES (
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ProductID#" />,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(loc_ThisKeyword)#" />
						);
					</cfif>
				</cfloop>
			</cfif>
		</cfquery>
		
	</cffunction>

</cfcomponent>