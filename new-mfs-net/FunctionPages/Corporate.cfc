<cfcomponent hint="This component will handle editing site administrators" extends="MachII.framework.Listener">

	<cfscript>
		this.SortOptions = ArrayNew(1);
		
		this.SortOptions[1] = ["Company","Company","Company"];
		this.SortOptions[2] = ["FirstName","First Name","FirstName"];
		this.SortOptions[3] = ["Lastname","Last Name","Lastname"];		
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

	<cffunction name="GetCorporates" returntype="query">
		<cfargument name="StartRow" type="numeric" default="1" />
		<cfargument name="EndRow" type="numeric" default="#REQUEST.Settings.RecordsPerPage#" /> 
		<cfargument name="FirstName" type="string" default="" />
		<cfargument name="Lastname" type="string" default="" />
		<cfargument name="Company" type="string" default="" />
		<cfargument name="Status" type="any" required="no" default="" />
		<cfargument name="sidx" type="string" required="no" default="#this.SortOptions[1][3]#" />
		<cfargument name="sord" type="string" required="no" default="#this.DefaultSord#" />
    	
		<cfset var loc_Corporate = "" />
	
		<cfquery datasource="#request.dsource#" name="loc_Corporate">
			SELECT		*
			FROM  (
					  
						SELECT			ROW_NUMBER() OVER ( ORDER BY #Arguments.sidx# #Arguments.sord# ) AS RowNum,
										COUNT(*) OVER () as Row_Total,
										D.DealerID,
										D.FirstName AS FirstName,
										D.Lastname AS LastName,
										D.Company,
										S.Status												
						FROM			Dealers D Join Status S
						ON				D.Status = S.ID
						
						WHERE			1=1
						
					<CFIF Len(Arguments.FirstName)>
						AND				D.FirstName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.FirstName#%" />		
					</CFIF>
					<CFIF Len(Arguments.Lastname)>
						AND				D.Lastname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.Lastname#%" />		
					</CFIF>
					<CFIF Len(Arguments.Company)>
						AND				D.Company LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.Company#%" />		
					</CFIF>
					<CFIF IsBoolean(Arguments.Status)>
						AND				D.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />		
					</CFIF>
							
			) AS RowConstrainedResult

			WHERE		RowNum >= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.StartRow#" />
			AND			RowNum <= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.EndRow#" />
			
			ORDER BY 	RowNum		
		</cfquery>
		
		<cfreturn loc_Corporate />
		
	</cffunction>
    
	<cffunction name="GetCorporateDetails" returntype="query" output="no" hint="I return the selected Customer details">
		<cfargument name="DealerID" type="numeric" default="0" />
		
		<cfset var loc_CustomerDetails = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_CustomerDetails">
			SELECT	DealerID,
					Company,
					FirstName,
					LastName,
					FirstName2,
					LastName2,
					Phonenumber,
					Phonenumber2,
					YearsInBusiness,
					EmailAddress,
					Password,
					ShipFirstName,
					ShipLastName,
					ShipAddress,
					ShipAddress2,
					ShipCity,
					ShipState,
					ShipProvince,
					ShipZipCode,
					ShipCountry,
					ShipPhonenumber,
					ShipPhoneExt,
					ShipAltnumber,
					ShipAltExt,
					BillFirstName,
					BillLastName,
					BillAddress,
					BillAddress2,
					BillCity,
					BillState,
					BillProvince,
					BillZipCode,
					BillCountry,
					BillPhonenumber,
					BillPhoneExt,
					BillAltnumber,
					BillAltExt,
					TaxID,
					DunnNumber,
					BankName,
					BankNumber,
					Comments,
					Status,
					Username,
					PayMethod,
					DiscountPercent,
					TaxExempt
			
			FROM	Dealers
			WHERE 	DealerID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.DealerID#" />
			
		</cfquery>
		
		<cfreturn loc_CustomerDetails />
	
	</cffunction>
	
	
	<cffunction name="UpdateCorporate" returntype="void">
		<cfargument name="DealerID" type="numeric" required="yes" />		
		<cfargument name="FirstName" type="string" required="yes" />
		<cfargument name="LastName" type="string" required="yes" />
		<cfargument name="PhoneNumber" type="string" required="yes" />
		<cfargument name="FirstName2" type="string" required="no" />
		<cfargument name="LastName2" type="string" required="no" />
		<cfargument name="PhoneNumber2" type="string" required="no" />
		<cfargument name="EmailAddress" type="string" required="yes" />
		<cfargument name="YearsInBusiness" type="string" required="yes" />
		<cfargument name="Username" type="string" required="yes" />
		<cfargument name="Password" type="string" required="no" />
		<cfargument name="DiscountPercent" type="string" required="yes" />
		<cfargument name="Status" type="boolean" required="yes" />	
		<cfargument name="TaxExempt" type="boolean" required="no" default="0" />		
		<cfargument name="ReturnUrl" type="string" required="yes" />
		<cfargument name="FrontEnd" type="boolean" default="0" />
		
		<cfset var loc_CustomerID = Arguments.DealerID />
		<cfset var loc_UpdateCustomer = "" />
		<cfset var loc_StatusMessage = "" />
			
		<cfquery datasource="#request.dsource#" name="loc_UpdateCustomer">
			DECLARE @DealerID AS Int;

			SET @DealerID = (
				SELECT	DealerID
				FROM	Dealers
				WHERE	DealerID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_CustomerID#" />
			);
			
			IF @DealerID IS NULL
			
				BEGIN
		
					SET NOCOUNT ON
					
					INSERT INTO Dealers (
							Company,
							FirstName,
							LastName,
							FirstName2,
							LastName2,
							PhoneNumber,
							PhoneNumber2,
							YearsInBusiness,
							EmailAddress,
							<!--- Password, --->
							Username,
							TaxExempt,
							Status,
							DiscountPercent
					) VALUES (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Company#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.FirstName#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.LastName#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.FirstName2#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.LastName2#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.PhoneNumber#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.PhoneNumber2#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.YearsInBusiness#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.EmailAddress#" />,
						<!--- <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Password#" />, --->
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Username#" />,
						<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.TaxExempt#" />,
						<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.DiscountPercent#" />
						)
					 
					SELECT	@@IDENTITY AS NewID,
							'Corporate.Added' AS StatusMessage
					SET NOCOUNT OFF
				END
			ELSE
				BEGIN
		
					UPDATE	Dealers
					
					SET		Company = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Company#" />,
							FirstName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.FirstName#" />,
							LastName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.LastName#" />,
							FirstName2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.FirstName2#" />,
							LastName2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.LastName2#" />,
							PhoneNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.PhoneNumber#" />,
							PhoneNumber2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.PhoneNumber2#" />,
							YearsInBusiness = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.YearsInBusiness#" />,
							EmailAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.EmailAddress#" />,
							<!--- Password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Password#" />, --->
							Username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Username#" />,
							TaxExempt = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.TaxExempt#" />,
							Status = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#">,
							DiscountPercent = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.DiscountPercent#" />
					WHERE	DealerID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_CustomerID#" />;
					
					SELECT	#loc_CustomerID# AS NewID,
							'Corporate.Updated' AS StatusMessage
				END
		</cfquery>
		
		<cfset loc_CustomerID = loc_UpdateCustomer.NewID />
		<cfset loc_StatusMessage = loc_UpdateCustomer.StatusMessage />
	
		<cfif FrontEnd NEQ 1>
			<cflocation url="#Arguments.ReturnUrl#&Message=#loc_StatusMessage#&DealerID=#loc_CustomerID#" addtoken="no" />
    	</cfif>	

	</cffunction>
	
	<cffunction name="UpdateCorporateBilling" returntype="void">
		<cfargument name="DealerID" type="numeric" required="yes" />	
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
		
		<cfset var loc_CustomerID = Arguments.DealerID />
		<cfset var loc_UpdateCustomer = "" />
		<cfset var loc_StatusMessage = "" />
		<cfset var loc_IsShippingToBilling = Arguments.IsShippingToBilling />
			
		<cfquery datasource="#request.dsource#" name="loc_UpdateCustomer">
					UPDATE	Dealers
					
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
					WHERE	DealerID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_CustomerID#" />
		</cfquery>
		
		<cfset loc_CustomerID = loc_CustomerID />
		<cfset loc_StatusMessage = "Corporate.Updated" />
	
		<cflocation url="#Arguments.ReturnUrl#&Message=#loc_StatusMessage#&DealerID=#loc_CustomerID#" addtoken="no" />

	</cffunction>
	
	<cffunction name="UpdateCorporateShipping" returntype="void">
		<cfargument name="DealerID" type="numeric" required="yes" />	
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
		
		<cfset var loc_CustomerID = Arguments.DealerID />
		<cfset var loc_UpdateCustomer = "" />
		<cfset var loc_StatusMessage = "" />
			
		<cfquery datasource="#request.dsource#" name="loc_UpdateCustomer">
					UPDATE	Dealers
					
					SET		
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
				
					WHERE	DealerID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_CustomerID#" />
		</cfquery>
		
		<cfset loc_CustomerID = loc_CustomerID />
		<cfset loc_StatusMessage = "Corporate.Updated" />
	
		<cflocation url="#Arguments.ReturnUrl#&Message=#loc_StatusMessage#&DealerID=#loc_CustomerID#" addtoken="no" />

	</cffunction>

	<cffunction name="DeleteCustomer" returntype="void">
		<cfargument name="DealerID" type="numeric" required="yes" />	
		
			<cfquery datasource="#request.dsource#" name="loc_UpdateCustomer">
				DELETE 
				FROM Dealers
				WHERE	DealerID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.DealerID#" />
			</cfquery>
	
			<cfset loc_StatusMessage = "Corporate.Delete" />
			
			<cflocation url="#Arguments.ReturnUrl#&Message=#loc_StatusMessage#" addtoken="no" />
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
			SELECT		DealerID
			FROM		Dealers
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