<cfcomponent hint="This component will handle editing product options" extends="MachII.framework.Listener">

		<cfscript>
		this.SortOptions = ArrayNew(1);
		
		this.SortOptions[1] = ["ProductAttributeName","Attribute Name","V.ProductAttributeName"];
		this.SortOptions[2] = ["productcount","Options","ISNULL(TOTALS.SubTotal,0)"];
		this.SortOptions[3] = ["status","Status","S.Status"];
		
		this.DefaultSord = "asc";
	</cfscript>
	
	<cffunction name="GetDefaultSord" access="public" output="false" returntype="string">
		<cfreturn this.DefaultSord />
	</cffunction>
	
	<cffunction name="GetSortOptions" access="public" output="false" returntype="array"> 
		<cfargument name="SortOptionsList" default="" />
		
		<cfset var loc_SortOptionsArray = this.SortOptions />
		<cfset var loc_SortOptionsList = Arguments.SortOptionsList />
		<cfset var loc_ThisIndex = "" />
		
		<cfif ListLen( loc_SortOptionsList )>
			<cfloop from="#ArrayLen(this.SortOptions)#" to="1" step="-1" index="loc_ThisIndex">
				<cfif NOT ListFindNoCase( loc_SortOptionsList, this.SortOptions[loc_ThisIndex][1] )>
					<cfset ArrayDeleteAt( loc_SortOptionsArray, loc_ThisIndex ) />
				</cfif>
			</cfloop>
		</cfif>
		
		<cfreturn loc_SortOptionsArray />
	</cffunction>

	
	<cffunction name="GetAttributes" returntype="query">
		<cfargument name="StartRow" type="numeric" default="1" />
		<cfargument name="EndRow" type="numeric" default="#REQUEST.Settings.RecordsPerPage#" /> 
		<cfargument name="ProductAttributeName" type="string" default="" />
		<cfargument name="ProductAttributeStatus" type="any" required="no" default="" />
		<cfargument name="sidx" type="string" required="no" default="#this.SortOptions[1][3]#" />
		<cfargument name="sord" type="string" required="no" default="#this.DefaultSord#" />
    	
		<cfset var loc_Attributes = "" />
	
		<cfquery datasource="#request.dsource#" name="loc_Attributes">
			SELECT		*
			FROM  (
					  
						SELECT			ROW_NUMBER() OVER ( ORDER BY #Arguments.sidx# #Arguments.sord# ) AS RowNum,
										COUNT(*) OVER () as Row_Total,
										V.ProductAttributeID,
										V.ProductAttributeName,
										V.ProductAttributeStatus,	
										ISNULL(TOTALS.SubTotal,0) AS ProductCount,
										S.Status
						
						FROM			ProductAttributes V
						JOIN			Status S ON V.ProductAttributeStatus = S.ID
						LEFT JOIN		(
											SELECT		GroupID,
											COUNT(*) AS SubTotal
											FROM		ProductOptions
											GROUP BY	GroupID
						
										) TOTALS ON V.ProductAttributeID = TOTALS.GroupID
						
						WHERE			1=1
						
					<CFIF Len(Arguments.ProductAttributeName)>
						AND				V.ProductAttributeName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.ProductAttributeName#%" />		
					</CFIF>
					<CFIF IsBoolean(Arguments.ProductAttributeStatus)>
						AND				V.ProductAttributeStatus = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.ProductAttributeStatus#" />		
					</CFIF>
					
			
			) AS RowConstrainedResult

			WHERE		RowNum >= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.StartRow#" />
			AND			RowNum <= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.EndRow#" />
			
			ORDER BY 	RowNum		
		</cfquery>
		
		<cfreturn loc_Attributes />
		
	</cffunction>
	
	<cffunction name="GetAttributeDetails" returntype="query" output="no">
		<cfargument name="ProductAttributeID" type="numeric" default="0" />

		<cfset var loc_ProductDetails = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_ProductDetails">
				select ProductAttributeID,ProductAttributeName, ProductAttributeStatus
				from ProductAttributes
				where ProductAttributeID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ProductAttributeID#" >		
		</cfquery>
		
		<cfreturn loc_ProductDetails />	
	</cffunction>	
					
					
	<cffunction name="UpdateProductAttribute" returntype="query" output="no">		
		<cfargument name="ProductAttributeID" type="numeric" default="0" />
		<cfargument name="ProductAttributeName" type="string" required="yes" />
		<cfargument name="ProductAttributeStatus" type="boolean" required="yes">
		<cfargument name="ProductID" type="numeric" default="0" />
	
		<cfset var loc_ProductAttributeID = Arguments.ProductAttributeID />
		<cfset var loc_ProductID = Arguments.ProductID />
				
		<cfset var loc_UpdateProduct = "" />
		<cfset var loc_StatusMessage = "" />
			
		<cfquery datasource="#request.dsource#" name="loc_UpdateProduct">
		DECLARE @ProductAttributeID AS Int;

			SET @ProductAttributeID = (
				SELECT	ProductAttributeID
				FROM	ProductAttributes
				WHERE	ProductAttributeID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_ProductAttributeID#" />
			);
			
			IF @ProductAttributeID IS NULL
			
				BEGIN
				SET NOCOUNT ON
					
				INSERT INTO ProductAttributes (
					ProductAttributeName,
					ProductAttributeStatus 
				) VALUES (
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ProductAttributeName#" />,
				<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.ProductAttributeStatus#" >
				)
	
			SELECT	@@IDENTITY AS NewID,
							'Attribute.Added' AS StatusMessage
					SET NOCOUNT OFF
				END
			ELSE
				BEGIN
		
					UPDATE	ProductAttributes
					SET		ProductAttributeName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ProductAttributeName#" />,
							ProductAttributeStatus = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.ProductAttributeStatus#" />
					WHERE	ProductAttributeID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_ProductAttributeID#" />;

			SELECT	#loc_ProductAttributeID# AS NewID,
							'Attribute.Updated' AS StatusMessage
				END
				</cfquery>
		
		<cfset loc_ProductAttributeID = loc_UpdateProduct.NewID />
		<cfset loc_StatusMessage = loc_UpdateProduct.StatusMessage />
		
		<cflocation url="#Arguments.ReturnUrl#&Message=#loc_StatusMessage#&ProductAttributeID=#loc_ProductAttributeID#" addtoken="no" />
												
	</cffunction>	
	
	<cffunction name="DeleteProductAttribute" output="no">
		<cfargument name="ProductAttributeID" type="numeric" default="0" />
		
		
		<cfset var loc_StatusMessage = "" />
		<cfset var loc_DeleteAttribute = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_DeleteAttribute">
			DELETE 
			FROM ProductAttributes
			WHERE ProductAttributeID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ProductAttributeID#" />;
			
		</cfquery>
		
		<cfset loc_StatusMessage = "Attribute.Deleted" />
		
		<cflocation url="#Arguments.ReturnUrl#&Message=#loc_StatusMessage#" addtoken="no" />
		

	</cffunction>

	
</cfcomponent>
