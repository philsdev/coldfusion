<cfcomponent extends="MachII.framework.Listener">
		
	<cffunction name="GetOrderShippingDetails" returntype="query" output="no">
		<cfargument name="OrderID" type="numeric" default="0" />
		
		<cfset var loc_OrderShippingDetails = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_OrderShippingDetails">
			SELECT		OS.ShipID,
						OS.OrderID,
						OS.OrderDetailsID,
						OS.ShipFirstName,
						OS.ShipLastName,
						OS.ShipAddress,
						OS.ShipAddress2,
						OS.ShipCity,
						OS.ShipState,
						OS.ShipProvince,
						OS.ShipZipCode,
						OS.ShipCountry,
						OS.ShipPhoneNumber,
						OS.ShipPhoneExt,
						OS.ShipAltNumber,
						OS.ShipAltExt,
						OS.ShipEmailAddress,						
						OS.ShipCompany,
						O.ShippingMethod
						
			FROM		Order_ShipInfo OS
			JOIN		Orders O ON OS.OrderID = O.OrderID
			
			WHERE		OS.OrderID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.OrderID#" />
		</cfquery>
		
		<cfreturn loc_OrderShippingDetails />
	
	</cffunction>
	
	<cffunction name="UpdateOrderShipping" returntype="void">
		<cfargument name="OrderID" type="numeric" required="yes" />	
		<cfargument name="ShipFirstName" type="string" required="yes" />
		<cfargument name="ShipLastName" type="string" required="yes" />		
		<cfargument name="ShipAddress" type="string" required="yes" />
		<cfargument name="ShipAddress2" type="string" required="yes" />
		<cfargument name="ShipCity" type="string" required="yes" />
		<cfargument name="ShipState" type="string" required="yes" />
		<cfargument name="ShipZipCode" type="string" required="yes" />
		<cfargument name="ShipProvince" type="string" required="no" />	
		<cfargument name="ShipCountry" type="string" required="yes" />	
		<cfargument name="ShipPhonenumber" type="string" required="yes" />
		<cfargument name="ShipPhoneExt" type="string" required="no" />
		<cfargument name="ShipAltnumber" type="string" required="no" />
		<cfargument name="ShipAltExt" type="string" required="no" />
		<cfargument name="ShipEmailAddress" type="string" required="no" />
		<cfargument name="ShipCompany" type="string" required="no" />
		<cfargument name="ReturnUrl" type="string" required="yes" />
		<cfargument name="FrontEnd" type="boolean" default="0" />
		
		<cfset var loc_CustomerID = Arguments.OrderID />
		<cfset var loc_UpdateCustomer = "" />
		<cfset var loc_StatusMessage = "" />
			
		<cfquery datasource="#request.dsource#" name="loc_UpdateCustomer">
					UPDATE	order_shipInfo
					
					SET		ShipFirstName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ShipFirstName#" />,
							ShipLastName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ShipLastName#" />,
							ShipAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ShipAddress#" />,
							ShipAddress2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ShipAddress2#" />,
							ShipCity = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ShipCity#" />,
							ShipState = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ShipState#" />,
							ShipZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ShipZipCode#" />,
							ShipProvince = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ShipProvince#" />,
							ShipCountry = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ShipCountry#" />,
							ShipPhonenumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ShipPhonenumber#" />,
							ShipPhoneExt = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ShipPhoneExt#" />,
							ShipAltnumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ShipAltnumber#" />,
							ShipAltExt = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ShipAltExt#" />,
							ShipEmailAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ShipEmailAddress#" />,
							ShipCompany = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ShipCompany#" />
				
					WHERE	OrderID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_CustomerID#" />
		</cfquery>
		
		<cfset loc_StatusMessage = "Order.Updated" />
	
		<cflocation url="#Arguments.ReturnUrl#&Message=#loc_StatusMessage#&OrderID=#loc_CustomerID#" addtoken="no" />

	</cffunction>


</cfcomponent>
