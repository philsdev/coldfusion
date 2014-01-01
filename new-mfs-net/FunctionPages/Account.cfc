<cfcomponent hint="This component will handle Account information for Corporate and Customer Accounts" extends="MachII.framework.Listener">

	<cffunction name="GetAccountInfo" access="public" output="yes"> 
		<cfargument name="UserID" type="numeric" default="0" />
		<cfargument name="UserType" type="numeric" default="0" />
		
		<cfset var loc_Manager = "" />
		<cfset var loc_UserID = Arguments.UserID />
		<cfset var loc_UserType = Arguments.UserType />
		<cfset var loc_CustomerInfo = "" />
		
		<cfif loc_UserType eq 1>
			<cfset loc_Manager = Request.ListenerManager.GetListener( "CustomerManager" ) />
			<cfset loc_CustomerInfo = loc_Manager.GetCustomerDetails( loc_UserID ) />
		<cfelseif loc_UserType eq 2>
			<cfset loc_Manager = Request.ListenerManager.GetListener( "CorporateManager" ) />
			<cfset loc_CustomerInfo = loc_Manager.GetCorporateDetails( loc_UserID ) />
		</cfif>
		
		
		
		<cfreturn loc_CustomerInfo />
	</cffunction>
	
	
	<cffunction name="VerifyLogin" output="no" access="public" returntype="void">	
		<cfargument name="Username" type="string" required="true" />
		<cfargument name="Password" type="string" required="true" />
		<cfargument name="UserType" type="numeric" required="true" default="1" />
		<cfargument name="ReturnUrl" type="string" required="true" />
		<cfargument name="ErrorUrl" type="string" required="true" />
		
		
		<cfset var loc_FindAdmin = "" />
		<cfset var loc_UserID = "" />
		<cfset var loc_PW = Arguments.Password />
		
		<cfset var loc_UserType = Arguments.UserType />
		<cfset var loc_FindUserType = "" />
		<cfset var loc_UserTypeName = "" />
		<cfset var loc_DBTable = "" />
		<cfset var loc_DBTableID = "" />
		
		
		<cfquery datasource="#request.dsource#" name="loc_FindUserType">
			SELECT		Name, 
						DBTable,
						DBTableID
			FROM		UserType
			WHERE		UserTypeID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_UserType#" />
		</cfquery>	
	

			
		<cfset loc_UserTypeName = loc_FindUserType.Name />
		<cfset loc_DBTable = loc_FindUserType.DBTable />
		<cfset loc_DBTableID = loc_FindUserType.DBTableID />
		
	
		<cfquery datasource="#request.dsource#" name="loc_FindUser">
			SELECT		ISNULL(#loc_DBTableID#,0) AS UserID, 
						BillFirstName,
						BillLastName,
						EmailAddress,
						BillPhoneNumber
			FROM		#loc_DBTable#
			WHERE		Username = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Username#" />
			AND			Password = <cfqueryparam cfsqltype="cf_sql_char" value="#loc_PW#" />
			AND			Status = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
		</cfquery>	
		
		<cfset loc_UserID = loc_FindUser.UserID />
		
		<cflock type="exclusive" scope="SESSION" timeout="10">			
			<cfscript>
				if (loc_UserID GT 0) {
					
					SESSION.User.UserType = #loc_UserType#;
					SESSION.User.LoggedIN = 1;
					SESSION.User.Fname = #loc_FindUser.BillFirstName#;
					SESSION.User.Lname = #loc_FindUser.BillLastName#;
					SESSION.User.EmailAddress = #loc_FindUser.EmailAddress#;
					SESSION.User.BillPhoneNumber = #loc_FindUser.BillPhoneNumber#;
					SESSION.User.UserID = loc_UserID;		
					SESSION.User.Failed = "no";
					//AnnounceEvent('ShoppingCart.List');	
					
				} else {
						
					SESSION.User.Failed = "yes";
					SESSION.User.LoggedIN = 0;
					//AnnounceEvent('Customer.Profile.Login');
			
				}
				
				REQUEST.SessionStruct = StructCopy(SESSION);
			</cfscript>
		</cflock>
	
		<cfif SESSION.User.Failed EQ "yes">
			<cflocation url="#Arguments.ErrorUrl#" addtoken="no" />
		<cfelse>
			<cflocation url="#Arguments.ReturnUrl#" addtoken="no" />
		</cfif>

		
	</cffunction>	
	
	<cffunction name="Logout" returntype="void" output="false" hint="logging out the customers from front end">
	
		<cfset var loc_ThisKey = "" />

		<cflock type="exclusive" scope="SESSION" timeout="10">
			<cfset StructDelete(SESSION.User, "UserType") >
			<cfset StructDelete(SESSION.User, "LoggedIN") >
			<cfset StructDelete(SESSION.User, "UserFname")> 
			<cfset StructDelete(SESSION.User, "UserID") >
			
			<!--- delete shipping info --->
			<cfloop collection="#SESSION.Cart.ShippingInfo#" item="loc_ThisKey">
				<cfif NOT ListFindNoCase( "CFID,CFTOKEN", loc_ThisKey )>
					<cfset StructDelete(SESSION.Cart.ShippingInfo,"#loc_ThisKey#") />
				</cfif>
			</cfloop>
			
			<!--- delete billing info --->
			<cfloop collection="#SESSION.Cart.BillingInfo#" item="loc_ThisKey">
				<cfif NOT ListFindNoCase( "CFID,CFTOKEN", loc_ThisKey )>
					<cfset StructDelete(SESSION.Cart.BillingInfo,"#loc_ThisKey#") />
				</cfif>
			</cfloop>

			<cfscript>
					
				/* shipping info  */
				SESSION.Cart.ShippingInfo = StructNew();	
				SESSION.Cart.ShippingInfo.FirstName = "";
				SESSION.Cart.ShippingInfo.LastName = "";
				SESSION.Cart.ShippingInfo.Email = "";
				SESSION.Cart.ShippingInfo.Address = "";
				SESSION.Cart.ShippingInfo.Address2 = "";
				SESSION.Cart.ShippingInfo.City = "";
				SESSION.Cart.ShippingInfo.State = "";
				SESSION.Cart.ShippingInfo.ZIPCode = "";
				SESSION.Cart.ShippingInfo.Country = "US";
				SESSION.Cart.ShippingInfo.PhoneNumber = "";
				SESSION.Cart.ShippingInfo.PhoneNumberExt = "";
				SESSION.Cart.ShippingInfo.PhoneNumberAlt = "";
				SESSION.Cart.ShippingInfo.PhoneNumberAltExt = "";
				SESSION.Cart.ShippingInfo.Company = "";
				
				/* billing info  */
				SESSION.Cart.BillingInfo = StructNew();	
				SESSION.Cart.BillingInfo.FirstName = "";
				SESSION.Cart.BillingInfo.LastName = "";
				SESSION.Cart.BillingInfo.Email = "";
				SESSION.Cart.BillingInfo.Address = "";
				SESSION.Cart.BillingInfo.Address2 = "";
				SESSION.Cart.BillingInfo.City = "";
				SESSION.Cart.BillingInfo.State = "";
				SESSION.Cart.BillingInfo.ZIPCode = "";
				SESSION.Cart.BillingInfo.Country = "US";
				SESSION.Cart.BillingInfo.PhoneNumber = "";
				SESSION.Cart.BillingInfo.PhoneNumberExt = "";
				SESSION.Cart.BillingInfo.PhoneNumberAlt = "";
				SESSION.Cart.BillingInfo.PhoneNumberAltExt = "";
				SESSION.Cart.BillingInfo.Company = "";
			</cfscript>

			
			
		</cflock>
		<!--- <cflock type="exclusive" scope="SESSION" timeout="10">
			<!--- Delete the created SESSIONs --->
			<cfloop collection="#SESSION#" item="loc_ThisKey">
				<cfif NOT ListFindNoCase( "CFID,CFTOKEN", loc_ThisKey )>
					<cfset StructDelete(SESSION,"#loc_ThisKey#") />
				</cfif>
			</cfloop>
			
			<cfset REQUEST.SessionStruct = StructCopy(SESSION) />
		</cflock> --->
		
		<!--- Admin logged out, call the Event to display the login page --->
		<!--- <cfset announceEvent('Customer.Profile.Login') /> --->
        
	</cffunction>    
	
</cfcomponent>