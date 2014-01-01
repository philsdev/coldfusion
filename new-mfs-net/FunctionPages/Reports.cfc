<cfcomponent extends="MachII.framework.Listener">

	<cfscript>
		this.SortOptions = ArrayNew(1);
		this.SortOptions[1] = ["ProductName","Product Name","ProductName"];
		this.SortOptions[2] = ["ProductID","Product ID","ProductID"];
		//this.SortOptions[3] = ["resultcount","Results Returned","ISNULL(SUM(W.ResultsRetuned),0)"];
			
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
	
	<cffunction name="GetPurchasedProducts" returntype="query">
		<cfargument name="StartRow" type="numeric" default="1" />
		<cfargument name="EndRow" type="numeric" default="#REQUEST.Settings.RecordsPerPage#" /> 
		<cfargument name="ProductName" type="string" default="" />
		<cfargument name="ProductID" type="string" default="" />
		<cfargument name="sidx" type="string" required="no" default="#this.SortOptions[1][3]#" />
		<cfargument name="sord" type="string" required="no" default="#this.DefaultSord#" />
    	
		<cfset var loc_WordsSearched = "" />
	
		<cfquery datasource="#request.dsource#" name="loc_WordsSearched">
			SELECT		*
			FROM  (
					  
						SELECT			ROW_NUMBER() OVER ( ORDER BY #Arguments.sidx# #Arguments.sord# ) AS RowNum,
										COUNT(*) OVER () as Row_Total,
										count(*) as ProductTotal,
										ProductName,
										ProductID
										
						FROM			Order_Items W
						
						WHERE			1=1		
					<CFIF Len(Arguments.ProductName)>
						AND				ProductName =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ProductName#" />		
					</CFIF>
					<CFIF Len(Arguments.ProductID)>
						AND				productID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ProductID#" />		
					</CFIF>
					
						GROUP BY		ProductID, ProductName
			
			) AS RowConstrainedResult

			WHERE		RowNum >= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.StartRow#" />
			AND			RowNum <= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.EndRow#" />
			
			ORDER BY 	RowNum		
		</cfquery>
		
		<cfreturn loc_WordsSearched />
		
	</cffunction>
	
	<cffunction name="GetProductSelected" returntype="query" output="no">		
		<cfargument name="ProductID" type="string" default="0" />
		
		<cfset var loc_ProductUpsells = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_ProductUpsells">
			SELECT			P.ProductID,
							P.ProductName,							
							P.ProductItemNumber,
							V.VendorName
							
			FROM			ProductUpsells U
			JOIN			Products P ON U.AssocProductID = P.ProductID
			LEFT JOIN		Vendors V ON P.VendorID = V.VendorID
				
			WHERE			U.MainProductID IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ProductID#" />)
			
			ORDER BY 		U.DisplayPosition ASC
		</cfquery>
		
		<cfreturn loc_ProductUpsells />	
	</cffunction>
	
	
	<cffunction name="GetSalesReport" returntype="query">
		<cfargument name="ProductCategory" type="string" default="" />
		<cfargument name="ProductID" type="string" default="" required="no">
		<cfargument name="StartDate" type="string" default="#DateFormat(dateAdd('m',  '-1',  now()),'mm/dd/yyyy')#" />
		<cfargument name="EndDate" type="string" default="#DateFormat(now(),'mm/dd/yyyy')#" />
		<cfargument name="TotalRangeGT" type="string" required="no" default="0" />
		<cfargument name="TotalRangeLT" type="string" required="no" default="0" />
		<cfargument name="SelectedProductID" type="string" required="no" default="" />
		    	
		<cfset var loc_SalesReport = "" />
		<cfset var loc_ProductIDList = "" />
		<cfset var loc_ThisProductID = "" />
		<cfset var loc_ThisProductCount = 0 />
		<cfset var loc_ProductCategoryLast = "" />
		
		<cfset var loc_TotalRangeGT = "#Arguments.TotalRangeGT#" />
		<cfset var loc_TotalRangeLT = "#Arguments.TotalRangeLT#" />
		<cfset var loc_StartDate = "#Arguments.StartDate#" />
		<cfset var loc_EndDate = "#Arguments.EndDate#" />
		<cfset var loc_ProductCategory = "#Arguments.ProductCategory#" />
		
		<cfset loc_ProductCategoryLast = #Listlast(Arguments.ProductCategory)#>
		<!--- reduce possible dupes --->
		<CFIF Len(Arguments.SelectedProductID)>
			<cfloop list="#Arguments.SelectedProductID#" index="loc_ThisProductID">
				<cfif NOT ListFind( loc_ProductIDList, loc_ThisProductID )>
					<cfset loc_ProductIDList = ListAppend( loc_ProductIDList, loc_ThisProductID ) />
				</cfif>
			</cfloop>
		</cfif>
	<!---	
	<cfoutput> hello: <br>
	#Arguments.ProductCategory#<br>
	#Listlast(Arguments.ProductCategory)#<br>
	loc_TotalRangeGT: #loc_TotalRangeGT#<br>	
	#Arguments.TotalRangeGT#<br>
	#Arguments.TotalRangeLT#<br>
	#Arguments.ProductCategory#<br>
	#Arguments.ProductID#<br>
	#Arguments.StartDate# = #loc_StartDate#<br>
	#Arguments.EndDate# = #loc_EndDate#<br>
	#Arguments.SelectedProductID#<br>
	#loc_ProductIDList# 
	
	</cfoutput>  <cfabort>--->
			<cfquery datasource="#request.dsource#" name="loc_SalesReport">
			
			SELECT COUNT(a.OrderID) as TotalOrders, SUM(a.OrderTotal) as TotalOrdered,	 
			'#loc_TotalRangeGT#' AS TotalRangeGT,
			'#loc_TotalRangeLT#' AS TotalRangeLT,
			'#loc_StartDate#' AS StartDate,
			'#loc_EndDate#' AS EndDate,
			'#loc_ProductIDList#' AS SelectedProductID,
			'#loc_ProductCategory#' AS ProductCategory
			FROM Orders a LEFT JOIN Order_Items b
			ON a.OrderID = b.OrderID
			LEFT JOIN categoryProductAssoc c
			ON b.productID = c.productID
			WHERE 1=1
			<CFIF Arguments.TotalRangeGT GT 0>
			and a.OrderTotal >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.TotalRangeGT#" />
			</cfif>
			<CFIF Arguments.TotalRangeLT GT 0>
			 AND a.OrderTotal <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.TotalRangeLT#" />
			 </cfif>
			<CFIF Len(Arguments.ProductCategory)>
				and c.categoryid =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#loc_ProductCategoryLast#" />	
			</CFIF>
			<CFIF Len(Arguments.SelectedProductID)>
			and c.ProductID IN (#loc_ProductIDList#)	
			</CFIF>
			<CFIF Arguments.StartDate NEQ "" AND Arguments.EndDate NEQ ""> 
				AND (a.DateOrdered >= <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.StartDate#">		
				AND a.DateOrdered <= <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.EndDate#">	)
			</CFIF>
	
			</cfquery>
		
		<cfreturn loc_SalesReport />
		
	</cffunction>
	
	
	
	
	
		
</cfcomponent>