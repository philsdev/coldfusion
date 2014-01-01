<cfcomponent extends="MachII.framework.Listener">
		
	<cffunction name="GetOrderItems" returntype="query" output="no">
		<cfargument name="OrderID" type="numeric" default="0" />
		
		<cfset var loc_OrderItems = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_OrderItems">
			SELECT		O.TaxCharge,
						O.ShippingCharge,
						O.MiscCharge,
						O.DiscountTotal,
						OI.OrderDetailsID,
						OI.OrderID,
						OI.Quantity,
						OI.ProductPrice,
						OI.Quantity * OI.ProductPrice AS TotalPrice,
						OI.ShippingNumber,
						CONVERT(CHAR(10),OI.ShippingDate,101) AS ShippingDate,
						OI.ShippingStatus,
						S.OrderStatus,
						P.ProductName,
						P.ProductItemNumber,
						V.VendorName,
						ISNULL(OIO.OptionName,'Unknown Option') AS OptionName,
						ISNULL(OIO.OptionValue,'Unknown Value') AS OptionValue,
						ISNULL(POA.Price,0) AS Price,
						ISNULL(POA.AddPrice,0) AS AddPrice,
						PR.PromotionName,
						PR.DiscountPercent,
						PR.DiscountAmount,
						P.ProductID

						
			FROM		Orders O
			JOIN		Order_Items OI ON O.OrderID = OI.OrderID
			JOIN		OrderStatus S ON O.OrderStatus = S.OrderStatusID
			JOIN		Products P ON OI.ProductID = P.ProductID
			JOIN		Vendors V ON P.VendorID = V.VendorID
			LEFT JOIN	Order_Item_Options OIO ON OI.OrderDetailsID = OIO.OrderDetailsID
			LEFT JOIN	ProductOptionsAssoc POA ON P.ProductID = POA.ProductID
			AND			POA.OptionID = OIO.OptionID
			LEFT JOIN	Promotions PR ON O.PromotionID = PR.PromotionID
			
			WHERE		O.OrderID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.OrderID#" />
			ORDER by 	OrderDetailsID
		</cfquery>
		
		<cfreturn loc_OrderItems />
	
	</cffunction>
	
	
	<cffunction name="GetOrderStatus" returntype="query" output="no">
		<cfset var loc_OrderStatus = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_OrderStatus">
			SELECT		OrderStatus, 
						OrderStatusID
			FROM		Orderstatus
			ORDER BY	OrderStatus
		</cfquery>
		
		<cfreturn loc_OrderStatus />
	
	</cffunction>
	
	<cffunction name="UpdateOrderItems" returntype="void">
		<cfargument name="OrderID" type="numeric" required="yes" />
		<cfargument name="OrderDetailsID" type="string" required="yes" />
		<cfargument name="TaxCharge" type="string" required="no" />
		<cfargument name="ShippingCharge" type="string" required="no" />
		<cfargument name="MiscCharge" type="string" required="no" />
		<cfargument name="TotalCharge" type="string" required="no" />
		<cfargument name="ReturnUrl" type="string" required="yes" />
		<cfargument name="FrontEnd" type="boolean" default="0" />
		
		<cfset var loc_CustomerID = Arguments.OrderID />
		<cfset var loc_UpdateCustomer = "" />
		<cfset var loc_StatusMessage = "" />
		
		<cfset var loc_ItemIndex = "" />
		<cfset var loc_ItemSelectionList = Arguments.OrderDetailsID />
		<cfset var loc_ItemSelectionListLength = ListLen( loc_ItemSelectionList ) />		
		
		
		<cfoutput>
			<cfloop list="#loc_ItemSelectionList#" index="loc_ItemIndex">
				<cfset loc_OrderStatusID = Evaluate("OrderStatusID_#loc_ItemIndex#") />
				<cfset loc_ShippingNumber = Evaluate("ShippingNumber_#loc_ItemIndex#") />
				<cfset loc_ShippingDate = Evaluate("ShippingDate_#loc_ItemIndex#") /> 
				
				<cfquery datasource="#request.dsource#" name="loc_UpdateOrderItems">
				UPDATE	Order_Items
					
				SET		ShippingStatus = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_OrderStatusID#" />,
						ShippingDate = 	<cfqueryparam cfsqltype="cf_sql_date" value="#loc_ShippingDate#" />,
						ShippingNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#loc_ShippingNumber#" />
						
				WHERE	OrderDetailsID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_ItemIndex#" />
				</cfquery>		
			</cfloop>
		</cfoutput>
		

		<cfquery datasource="#request.dsource#" name="loc_UpdateCustomer">
					UPDATE	Orders
					
					SET		TaxCharge = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.TaxCharge#" />,
							ShippingCharge = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ShippingCharge#" />,
							MiscCharge = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.MiscCharge#" />,
							OrderTotal = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.TotalCharge#" />
				
					WHERE	OrderID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_CustomerID#" />
		</cfquery> 
		
		<cfset loc_StatusMessage = "Order.Updated" />
	
		<cflocation url="#Arguments.ReturnUrl#&Message=#loc_StatusMessage#&OrderID=#loc_CustomerID#" addtoken="no" />

	</cffunction>


</cfcomponent>
