<cfcomponent extends="MachII.framework.Listener">
		
	<cffunction name="GetOrderBillingDetails" returntype="query" output="no">
		<cfargument name="OrderID" type="numeric" default="0" />
		
		<cfset var loc_OrderBillingDetails = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_OrderBillingDetails">
			SELECT		OB.BillID,
						OB.OrderID,
						OB.BillFirstName,
						OB.BillLastName,
						OB.BillAddress,
						OB.BillAddress2,
						OB.BillCity,
						OB.BillState,
						OB.BillProvince,
						OB.BillZipCode,
						OB.BillCountry,
						OB.BillPhoneNumber,
						OB.BillPhoneExt,
						OB.BillAltNumber,
						OB.BillAltExt,
						OB.BillEmailAddress,						
						OB.BillCompany
						
			FROM		Order_BillInfo OB
			
			WHERE		OB.OrderID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.OrderID#" />
		</cfquery>
		
		<cfreturn loc_OrderBillingDetails />
	
	</cffunction>
	
	<cffunction name="UpdateOrderBilling" returntype="void">
		<cfargument name="OrderID" type="numeric" required="yes" />	
		<cfargument name="BillFirstName" type="string" required="yes" />
		<cfargument name="BillLastName" type="string" required="yes" />		
		<cfargument name="BillAddress" type="string" required="yes" />
		<cfargument name="BillAddress2" type="string" required="yes" />
		<cfargument name="BillCity" type="string" required="yes" />
		<cfargument name="BillState" type="string" required="yes" />
		<cfargument name="BillZipCode" type="string" required="yes" />
		<cfargument name="BillProvince" type="string" required="no" />	
		<cfargument name="BillCountry" type="string" required="yes" />	
		<cfargument name="BillPhonenumber" type="string" required="yes" />
		<cfargument name="BillPhoneExt" type="string" required="no" />
		<cfargument name="BillAltnumber" type="string" required="no" />
		<cfargument name="BillAltExt" type="string" required="no" />
		<cfargument name="BillEmailAddress" type="string" required="no" />
		<cfargument name="BillCompany" type="string" required="no" />
		<cfargument name="ReturnUrl" type="string" required="yes" />
		<cfargument name="FrontEnd" type="boolean" default="0" />
		
		<cfset var loc_CustomerID = Arguments.OrderID />
		<cfset var loc_UpdateCustomer = "" />
		<cfset var loc_StatusMessage = "" />
			
		<cfquery datasource="#request.dsource#" name="loc_UpdateCustomer">
					UPDATE	order_BillInfo
					
					SET		BillFirstName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.BillFirstName#" />,
							BillLastName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.BillLastName#" />,
							BillAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.BillAddress#" />,
							BillAddress2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.BillAddress2#" />,
							BillCity = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.BillCity#" />,
							BillState = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.BillState#" />,
							BillZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.BillZipCode#" />,
							BillProvince = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.BillProvince#" />,
							BillCountry = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.BillCountry#" />,
							BillPhonenumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.BillPhonenumber#" />,
							BillPhoneExt = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.BillPhoneExt#" />,
							BillAltnumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.BillAltnumber#" />,
							BillAltExt = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.BillAltExt#" />,
							BillEmailAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.BillEmailAddress#" />,
							BillCompany = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.BillCompany#" />
				
					WHERE	OrderID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_CustomerID#" />
		</cfquery>
		
		<cfset loc_StatusMessage = "Order.Updated" />
	
		<cflocation url="#Arguments.ReturnUrl#&Message=#loc_StatusMessage#&OrderID=#loc_CustomerID#" addtoken="no" />

	</cffunction>


</cfcomponent>
