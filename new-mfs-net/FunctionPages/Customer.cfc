<cfcomponent hint="This component will handle editing site administrators" extends="MachII.framework.Listener">

	<cfscript>
		this.SortOptions = ArrayNew(1);
		
		this.SortOptions[1] = ["BillFirstName","First Name","BillFirstName"];
		this.SortOptions[2] = ["BillLastname","Last Name","BillLastname"];		
		this.SortOptions[3] = ["EmailAddress","Email Address","EmailAddress"];
		this.SortOptions[4] = ["Status","Status","Status"];
		
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

	<cffunction name="GetCustomers" returntype="query">
		<cfargument name="StartRow" type="numeric" default="1" />
		<cfargument name="EndRow" type="numeric" default="#REQUEST.Settings.RecordsPerPage#" /> 
		<cfargument name="BillFirstName" type="string" default="" />
		<cfargument name="BillLastname" type="string" default="" />
		<cfargument name="EmailAddress" type="string" default="" />
		<cfargument name="Status" type="any" required="no" default="" />
		<cfargument name="sidx" type="string" required="no" default="#this.SortOptions[1][3]#" />
		<cfargument name="sord" type="string" required="no" default="#this.DefaultSord#" />
    	
		<cfset var loc_Customers = "" />
	
		<cfquery datasource="#request.dsource#" name="loc_Customers">
			SELECT		*
			FROM  (
					  
						SELECT			ROW_NUMBER() OVER ( ORDER BY #Arguments.sidx# #Arguments.sord# ) AS RowNum,
										COUNT(*) OVER () as Row_Total,
										AccountID,
										BillFirstName AS FirstName,
										BillLastname AS LastName,
										Status,
										EmailAddress		
						FROM			Accounts
						
						WHERE			1=1
						
					<CFIF Len(Arguments.BillFirstName)>
						AND				BillFirstName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.BillFirstName#%" />		
					</CFIF>
					<CFIF Len(Arguments.BillLastname)>
						AND				BillLastname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.BillLastname#%" />		
					</CFIF>
					<CFIF IsBoolean(Arguments.Status)>
						AND				Status = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />		
					</CFIF>
							
			) AS RowConstrainedResult

			WHERE		RowNum >= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.StartRow#" />
			AND			RowNum <= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.EndRow#" />
			
			ORDER BY 	RowNum		
		</cfquery>
		
		<cfreturn loc_Customers />
		
	</cffunction>
    
	<cffunction name="GetCustomerDetails" returntype="query" output="no" hint="I return the selected Customer details">
		<cfargument name="AccountID" type="numeric" default="0" />
		
		<cfset var loc_CustomerDetails = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_CustomerDetails">
			SELECT	AccountID,
					Status,
					Username,
					Password,
					EmailAddress,
					ShipFirstName,
					ShipLastName,
					ShipAddress,
					ShipAddress2,
					ShipCity,
					ShipState,
					ShipZipCode,
					ShipProvince,
					ShipCountry,
					ShipPhonenumber,
					ShipPhoneExt,
					ShipWorknumber,
					ShipWorkExt,
					ShipAltNumber,
					ShipAltExt,
					BillFirstname,
					BillLastname,
					BillAddress,
					BillAddress2,
					BillCity,
					BillState,
					BillZipCode,
					BillProvince,
					BillCountry,
					BillPhonenumber,
					BillPhoneExt,
					BillWorknumber,
					BillWorkExt,
					BillAltnumber,
					BillAltExt,
					CardType,
					CardName,
					CardNumber,
					CardExpMonth,
					CardExpYear,
					CardSecCode,
					TaxExempt
			FROM	Accounts
			WHERE 	AccountID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AccountID#" />
			
		</cfquery>
		
		<cfreturn loc_CustomerDetails />
	
	</cffunction>
	
	
	<cffunction name="UpdateCustomer" returntype="void">
		<cfargument name="AccountID" type="numeric" required="yes" />		
		<cfargument name="BillFirstName" type="string" required="yes" />
		<cfargument name="BillLastName" type="string" required="yes" />
		<cfargument name="Username" type="string" required="yes" />
		<cfargument name="Password" type="string" required="no" />
		<cfargument name="EmailAddress" type="string" required="yes" />
		<cfargument name="Status" type="boolean" required="yes" />	
		<cfargument name="TaxExempt" type="boolean" required="no" default="0" />		
		<cfargument name="ReturnUrl" type="string" required="yes" />
		<cfargument name="FrontEnd" type="boolean" default="0" />
		
		<cfset var loc_CustomerID = Arguments.AccountID />
		<cfset var loc_UpdateCustomer = "" />
		<cfset var loc_StatusMessage = "" />
			
		<cfquery datasource="#request.dsource#" name="loc_UpdateCustomer">
			DECLARE @AccountID AS Int;

			SET @AccountID = (
				SELECT	AccountID
				FROM	Accounts
				WHERE	AccountID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_CustomerID#" />
			);
			
			IF @AccountID IS NULL
			
				BEGIN
		
					SET NOCOUNT ON
					
					INSERT INTO Accounts (
						BillFirstName, 
						BillLastName,
						Username,
						EmailAddress,
						TaxExempt,
						Status
					) VALUES (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.BillFirstName#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.BillLastName#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Username#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.EmailAddress#" />,
						<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.TaxExempt#" />,
						<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#">
						)
					 
					SELECT	@@IDENTITY AS NewID,
							'Customer.Added' AS StatusMessage
					SET NOCOUNT OFF
				END
			ELSE
				BEGIN
		
					UPDATE	Accounts
					
					SET		BillFirstName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.BillFirstName#" />,
							BillLastName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.BillLastName#" />,
							Username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Username#" />,
							EmailAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.EmailAddress#" />,
							TaxExempt = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.TaxExempt#" />,
							Status = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#">
					WHERE	AccountID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_CustomerID#" />;
					
					SELECT	#loc_CustomerID# AS NewID,
							'Customer.Updated' AS StatusMessage
				END
		</cfquery>
		
		<cfset loc_CustomerID = loc_UpdateCustomer.NewID />
		<cfset loc_StatusMessage = loc_UpdateCustomer.StatusMessage />
	
		<cfif FrontEnd NEQ 1>
			<cflocation url="#Arguments.ReturnUrl#&Message=#loc_StatusMessage#&AccountID=#loc_CustomerID#" addtoken="no" />
    	</cfif>	

	</cffunction>

	
	<cffunction name="DeleteCustomer" returntype="void">
		<cfargument name="AccountID" type="numeric" required="yes" />	
		
			<cfquery datasource="#request.dsource#" name="loc_UpdateCustomer">
				DELETE 
				FROM Accounts
				WHERE	AccountID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AccountID#" />
			</cfquery>
	
			<cfset loc_StatusMessage = "Customer.Delete" />
			
			<cflocation url="#Arguments.ReturnUrl#&Message=#loc_StatusMessage#" addtoken="no" />
	</cffunction>
	
	<cffunction name="UpdateCustomerBilling" returntype="void">
		<cfargument name="AccountID" type="numeric" required="yes" />	
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
		<cfargument name="IsShippingToBilling" type="numeric" required="no" default="0" />
		

		<cfargument name="ReturnUrl" type="string" required="yes" />
		<cfargument name="FrontEnd" type="boolean" default="0" />
		
		<cfset var loc_CustomerID = Arguments.AccountID />
		<cfset var loc_UpdateCustomer = "" />
		<cfset var loc_StatusMessage = "" />
		<cfset var loc_IsShippingToBilling = Arguments.IsShippingToBilling />
			
		<cfquery datasource="#request.dsource#" name="loc_UpdateCustomer">
					UPDATE	Accounts
					
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
							BillAltExt = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.BillAltExt#" />
					<cfif loc_IsShippingToBilling eq 1>
							,
							ShipFirstName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.BillFirstName#" />,
							ShipLastName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.BillLastName#" />,
							ShipAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.BillAddress#" />,
							ShipAddress2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.BillAddress2#" />,
							ShipCity = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.BillCity#" />,
							ShipState = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.BillState#" />,
							ShipZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.BillZipCode#" />,
							ShipProvince = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.BillProvince#" />,
							ShipCountry = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.BillCountry#" />,
							ShipPhonenumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.BillPhonenumber#" />,
							ShipPhoneExt = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.BillPhoneExt#" />,
							ShipAltnumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.BillAltnumber#" />,
							ShipAltExt = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.BillAltExt#" />
					
					</cfif>
					WHERE	AccountID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_CustomerID#" />
		</cfquery>
		
		<cfset loc_CustomerID = loc_CustomerID />
		<cfset loc_StatusMessage = "Customer.Updated" />
	
		<cflocation url="#Arguments.ReturnUrl#&Message=#loc_StatusMessage#&AccountID=#loc_CustomerID#" addtoken="no" />

	</cffunction>
	
	<cffunction name="UpdateCustomerShipping" returntype="void">
		<cfargument name="AccountID" type="numeric" required="yes" />	
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

		<cfargument name="ReturnUrl" type="string" required="yes" />
		<cfargument name="FrontEnd" type="boolean" default="0" />
		
		<cfset var loc_CustomerID = Arguments.AccountID />
		<cfset var loc_UpdateCustomer = "" />
		<cfset var loc_StatusMessage = "" />
			
		<cfquery datasource="#request.dsource#" name="loc_UpdateCustomer">
					UPDATE	Accounts
					
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
							ShipAltExt = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ShipAltExt#" />
				
					WHERE	AccountID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_CustomerID#" />
		</cfquery>
		
		<cfset loc_CustomerID = loc_CustomerID />
		<cfset loc_StatusMessage = "Customer.Updated" />
	
		<cflocation url="#Arguments.ReturnUrl#&Message=#loc_StatusMessage#&AccountID=#loc_CustomerID#" addtoken="no" />

	</cffunction>

	<cffunction name="UpdateCustomerInfo" returntype="void">
		<cfargument name="AccountID" type="numeric" required="yes" />	
		<cfargument name="Username" type="string" required="yes" />
		<cfargument name="Password" type="string" required="no" />
		<cfargument name="EmailAddress" type="string" required="yes" />
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

		<cfargument name="ReturnUrl" type="string" required="yes" />
		<cfargument name="FrontEnd" type="boolean" default="1" />
		
		<cfset var loc_CustomerID = Arguments.AccountID />
		<cfset var loc_UpdateCustomer = "" />
		<cfset var loc_StatusMessage = "" />
		
			
		<cfquery datasource="#request.dsource#" name="loc_UpdateCustomer">
					UPDATE	Accounts
					
					SET		Username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Username#" />,
							EmailAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.EmailAddress#" />,
							BillFirstName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.BillFirstName#" />,
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
							ShipFirstName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ShipFirstName#" />,
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
							ShipAltExt = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ShipAltExt#" />
					
					WHERE	AccountID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_CustomerID#" />
		</cfquery>
		
		<cfset loc_CustomerID = loc_CustomerID />
		<cfset loc_StatusMessage = "Customer.Updated" />
	
		<cflocation url="#Arguments.ReturnUrl#" addtoken="no" />

	</cffunction>

	
	<cffunction name="GetUsernameAvailability" access="public" output="true" returntype="void">    
		<cfargument name="Username" type="string" required="yes" />
		
		<cfset var loc_UsernameAvailability = IsUsernameTaken( username:Arguments.Username ) />
		
		<cfoutput>#NumberFormat(loc_UsernameAvailability)#</cfoutput>
		
	</cffunction>
	
	<cffunction name="IsUsernameTaken" access="public" output="false" returntype="boolean">    
		<cfargument name="Username" type="string" required="yes" />
		
		<cfset var loc_UsernameAvailability = "" />
		<cfset var loc_IsTaken = false />
		
		<cfquery datasource="#request.dsource#" name="loc_UsernameAvailability">
			SELECT		AccountID
			FROM		Accounts
			WHERE		Username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Username#" />
		</cfquery>
		
		<cfif loc_UsernameAvailability.RecordCount>
			<cfset loc_IsTaken = true />
		</cfif>
		
		<cfreturn loc_IsTaken />		
	</cffunction>
	
	<cffunction name="IsValidUsername" access="public" output="false" returntype="boolean">    
		<cfargument name="Username" type="string" required="yes" />
		
		<cfreturn REFindNoCase( '[^A-Za-z09-]+', Arguments.Username ) />		
	</cffunction>
	
	
</cfcomponent>