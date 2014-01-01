<cfcomponent hint="This component will handle editing site administrators" extends="MachII.framework.Listener">

	<cfscript>
		this.SortOptions = ArrayNew(1);
		
		this.SortOptions[1] = ["dateordered","Date Ordered","O.DateOrdered"];
		this.SortOptions[2] = ["billfirstname","Bill First Name","BI.BillFirstName"];
		this.SortOptions[3] = ["billlastname","Bill Last Name","BI.BillLastName"];
		this.SortOptions[4] = ["orderitems","Items","OI.Total"];		
		this.SortOptions[5] = ["ordertotal","Total","O.OrderTotal"];		
		this.SortOptions[6] = ["orderstatus","Status","S.OrderStatus"];
		
		this.DefaultSord = "desc";
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

	<cffunction name="GetOrderStatuses" returntype="query">
    	
		<cfset var loc_OrderStatuses = "" />
	
		<cfquery datasource="#request.dsource#" name="loc_OrderStatuses">					  
			SELECT			S.OrderStatusID,
							S.OrderStatus
			
			FROM			OrderStatus S
			
			ORDER BY		S.OrderStatusID
		</cfquery>
		
		<cfreturn loc_OrderStatuses />
		
	</cffunction>
	
	<cffunction name="GetOrders" returntype="query">
		<cfargument name="StartRow" type="numeric" default="1" />
		<cfargument name="EndRow" type="numeric" default="#REQUEST.Settings.RecordsPerPage#" /> 
		<cfargument name="ShipLastName" type="string" default="" />
		<cfargument name="BillLastName" type="string" default="" />
		<cfargument name="OrderID" type="any" default="" required="no" />
		<cfargument name="OrderTotal" type="any" default="" required="no" />
		<cfargument name="DateOrdered" type="any" required="no" default="" />
		<cfargument name="ProductCategory" type="string" default="" />
		<cfargument name="OrderStatus" type="any" required="no" default="" />
		<cfargument name="sidx" type="string" required="no" default="#this.SortOptions[1][3]#" />
		<cfargument name="sord" type="string" required="no" default="#this.DefaultSord#" />
    	
		<cfset var loc_Orders = "" />
		<cfset var loc_CategorySelectionList = Arguments.ProductCategory />
		<cfset var loc_CategorySelectionListLength = ListLen( loc_CategorySelectionList ) />		
		<cfset var loc_CategorySelection = "" />
		
		<cfloop from="#loc_CategorySelectionListLength#" to="1" step="-1" index="loc_CategoryIndex">
			<cfset loc_ThisSelection = ListGetAt( loc_CategorySelectionList, loc_CategoryIndex ) />
			<cfif IsNumeric( loc_ThisSelection )>
				<cfset loc_CategorySelection = loc_ThisSelection />
				<cfbreak />
			</cfif>
		</cfloop>

		<cfquery datasource="#request.dsource#" name="loc_Orders">
			SELECT		*
			FROM  (
					  
						SELECT			ROW_NUMBER() OVER ( ORDER BY #Arguments.sidx# #Arguments.sord# ) AS RowNum,
										COUNT(*) OVER () as Row_Total,
										O.NewOrderID,
										O.OrderID,
										O.OrderTotal,
										CONVERT(CHAR(10),O.DateOrdered,101) AS DateOrdered,
										OI.Total AS TotalItems,
										BI.BillFirstName,
										BI.BillLastName,
										S.OrderStatus
						
						FROM			Orders O
						
						JOIN			OrderStatus S ON O.OrderStatus = S.OrderStatusID
						
						LEFT JOIN		Order_BillInfo BI ON O.OrderID = BI.OrderID
						LEFT JOIN		Order_ShipInfo SI ON O.OrderID = SI.OrderID						
						LEFT JOIN		(
											SELECT		OrderID,
														COUNT(*) AS Total
											FROM		Order_Items
											GROUP BY	OrderID
										) OI ON O.OrderID = OI.OrderID
										
						WHERE			1=1
					<cfif LEN( Arguments.BillLastName )>
						AND				BI.BillLastName = <CFQUERYPARAM cfsqltype="cf_sql_varchar" value="#Arguments.BillLastName#" />
					</cfif>
					<cfif LEN( Arguments.ShipLastName )>
						AND				SI.ShipLastName = <CFQUERYPARAM cfsqltype="cf_sql_varchar" value="#Arguments.ShipLastName#" />
					</cfif>
					<cfif IsNumeric( Arguments.OrderStatus )>
						AND				O.OrderStatus = <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.OrderStatus#" />
					</cfif>
					<cfif IsNumeric( Arguments.orderID )>
						AND				O.OrderID = <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.orderID#" />
					</cfif>
					<cfif IsNumeric( Arguments.OrderTotal )>
						AND				O.OrderTotal = <CFQUERYPARAM cfsqltype="cf_sql_varchar" value="#Arguments.OrderTotal#" />
					</cfif>
					<cfif LEN( Arguments.DateOrdered )>
						AND				O.DateOrdered  >  <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.DateOrdered#">
						AND				O.DateOrdered  <  <cfqueryparam cfsqltype="cf_sql_date" value="#dateAdd('d',  '1',  Arguments.DateOrdered)#">
					</cfif>
					<cfif IsNumeric(loc_CategorySelection)>
						AND				O.OrderID IN (
											SELECT		OrderID
											FROM		Order_Items
											WHERE		ProductID IN (
															SELECT		ProductID
															FROM		CategoryProductAssoc
															WHERE		CategoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_CategorySelection#" />
														)
										)
					</cfif>
			
			) AS RowConstrainedResult

			WHERE		RowNum >= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.StartRow#" />
			AND			RowNum <= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.EndRow#" />
			
			ORDER BY 	RowNum		
		</cfquery>
		
		<cfreturn loc_Orders />
		
	</cffunction>
	
	<cffunction name="GetOrderDetails" returntype="query" output="no">
		<cfargument name="OrderID" type="numeric" default="0" />
		
		<cfset var loc_OrderDetails = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_OrderDetails">
			SELECT		O.OrderID,
						O.NewOrderID,
						O.DateOrdered,
						O.OrderNotes,
						O.CustomerComments,
						O.PayFlowProComments,
						O.OrderTotal,
						ShippingCarrier, 
						ShippingMethod
						
			FROM		Orders O
			
			WHERE		O.OrderID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.OrderID#" />
		</cfquery>
		
		<cfreturn loc_OrderDetails />
	
	</cffunction>
	
	<cffunction name="UpdateOrder" returntype="void">
		<cfargument name="OrderID" default="0" />		
		<cfargument name="OrderNotes" type="string" required="yes" />
		<cfargument name="ReturnUrl" type="string" required="yes" />
		
		<cfset var loc_OrderID = Arguments.OrderID />
		<cfset var loc_UpdateOrder = "" />
		<cfset var loc_StatusMessage = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_UpdateOrder">
			DECLARE @OrderID AS Int;

			SET @OrderID = (
				SELECT	OrderID
				FROM	Orders
				WHERE	OrderID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_OrderID#" />
			);
			
			IF @OrderID IS NULL
			
				BEGIN
		
					SET NOCOUNT ON
					
					INSERT INTO Orders (
						OrderNotes
					) VALUES (
						 <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.OrderNotes#" />
					)
					 
					SELECT	@@IDENTITY AS NewID,
							'Order.Added' AS StatusMessage
					SET NOCOUNT OFF
				END
			ELSE
				BEGIN
		
					UPDATE	Orders
					
					SET		OrderNotes = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.OrderNotes#" />
							
					WHERE	OrderID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_OrderID#" />;
					
					SELECT	#loc_OrderID# AS NewID,
							'Order.Updated' AS StatusMessage
				END
		</cfquery>
		
		<cfset loc_OrderID = loc_UpdateOrder.NewID />
		<cfset loc_StatusMessage = loc_UpdateOrder.StatusMessage />
		
		<cflocation url="#Arguments.ReturnUrl#&Message=#loc_StatusMessage#&OrderID=#loc_OrderID#" addtoken="no" />
    
    </cffunction>
	
	<cffunction name="DeleteOrder" access="public" output="false" returntype="void">    
		<cfargument name="OrderID" type="numeric" required="yes" />		
		
		<cfset var loc_DeleteOrder = "" />		
		
		<cfquery datasource="#request.dsource#" name="loc_DeleteOrder">
			DELETE
			FROM		Orders
			WHERE		OrderID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.OrderID#" />
		</cfquery>
		
	</cffunction>
	
	
	<cffunction name="GetOrdersByAccount" returntype="query" output="no">
		<cfargument name="UserID" type="numeric" default="0" />
		<cfargument name="CurrentOrder" type="numeric" default="1" />
		
		<cfset var loc_OrderDetails = "" />
		<cfset var loc_CurrentOrder = "#Arguments.CurrentOrder#" />
		
		<cfquery datasource="#request.dsource#" name="loc_OrderDetails">
			SELECT	O.OrderID, O.DateOrdered, O.OrderTotal, O.NewOrderID, O.CustomerType, O.accountID, OI.ProductName, OI.ShippingStatus, OI.ShippingDate
			FROM 	Orders O  JOIN order_items OI
			ON 		O.orderID = OI.orderID
			WHERE	O.AccountID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.UserID#" />
			<cfif loc_CurrentOrder eq 1>
				AND OI.ShippingStatus <> 30
			</cfif>
			<cfif loc_CurrentOrder eq 0>
				AND OI.ShippingStatus = 30
			</cfif>
			Order by O.DateOrdered Desc
		</cfquery>
		
				
		<cfreturn loc_OrderDetails />
	
	</cffunction>
	
	
</cfcomponent>
