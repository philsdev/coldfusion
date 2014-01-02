<cfcomponent extends="MachII.framework.Listener">

	<cfscript>
		this.SortOptions = ArrayNew(1);
		
		this.SortOptions[1] = ["firstname","First Name","A.FirstName"];
		this.SortOptions[2] = ["lastname","Last Name","A.LastName"];
		this.SortOptions[3] = ["username","Username","A.Username"];
		this.SortOptions[4] = ["email","E-mail Address","A.Email"];
		this.SortOptions[5] = ["school","School","SCH.Title"];
		this.SortOptions[6] = ["city","City","ADDR.City"];
		this.SortOptions[7] = ["state","State","ADDR.State"];
		this.SortOptions[8] = ["datecreated","Date Created","A.DateCreated"];
		this.SortOptions[9] = ["status","Status","ST.Status"];
		
	</cfscript>
	
	<cffunction name="GetSortOptions" access="public" output="false" returntype="array"> 
		<cfreturn this.SortOptions />
	</cffunction>
	
	<cffunction name="GetUsers" access="public" output="false" returntype="query">  
        
		<cfset var loc_Users = "" />
        
		<cfquery datasource="#request.dsource#" name="loc_Users">
			SELECT			ID,
							Username AS Label						
			FROM			AMP_Accounts			
			ORDER BY 		Username
		</cfquery>
		
		<cfreturn loc_Users />
	</cffunction>
		
	<cffunction name="GetAccounts" access="public" output="false" returntype="query">    
		<cfargument name="StartRow" type="numeric" default="1" />
		<cfargument name="EndRow" type="numeric" default="#Request.RecordsPerPage#" /> 
		<cfargument name="FirstName" type="string" default="" />
		<cfargument name="LastName" type="string" default="" />
		<cfargument name="Username" type="string" default="" />
		<cfargument name="School" type="string" default="" />
		<cfargument name="City" type="string" default="" />
		<cfargument name="State" type="string" default="" />
		<cfargument name="Status" type="string" default="" />
		<cfargument name="sidx" type="string" required="no" default="#this.SortOptions[1][3]#" />
		<cfargument name="sord" type="string" required="no" default="asc" />
        
		<cfset var loc_Accounts = "" />
        
		<cfquery datasource="#request.dsource#" name="loc_Accounts">
			SELECT		*
			FROM  (
					  
						SELECT			ROW_NUMBER() OVER ( ORDER BY #Arguments.sidx# ) AS RowNum,
										COUNT(*) OVER () as Row_Total,
										A.ID,
										A.Username,
										A.Email,
										A.FirstName,
										A.LastName,
										SCH.Title AS School,
										CONVERT(CHAR(10),A.DateCreated,101) AS DateCreated,
										A.IsAdvertiser,
										A.IsDealer,
										ST.Status,
										ADDR.Title AS AddressTitle,
										ADDR.Street1,
										ADDR.Street2,
										ADDR.City,
										ADDR.State,
										ADDR.ZipCode,
										ADDR.PhoneNumber,
										ADDR.URL
						
						FROM			AMP_Accounts A
						JOIN			AMP_Status ST ON A.Status = ST.ID
						LEFT JOIN		AMP_Schools SCH ON A.SchoolID = SCH.ID							
						LEFT JOIN		AMP_Address ADDR ON A.AddressID = ADDR.ID
						
						WHERE			1=1
					<cfif Len(Arguments.FirstName)>
						AND				A.FirstName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.FirstName#%" />		
					</cfif>
					<cfif Len(Arguments.LastName)>
						AND				A.LastName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.LastName#%" />		
					</cfif>
					<cfif Len(Arguments.Username)>
						AND				A.Username LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.Username#%" />		
					</cfif>
					<cfif IsNumeric(Arguments.School)>
						AND				A.SchoolID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.School#" />		
					</cfif>
					<cfif Len(Arguments.City)>
						AND				ADDR.City LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.City#%" />		
					</cfif>
					<cfif Len(Arguments.State)>
						AND				ADDR.State LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.State#%" />		
					</cfif>
					<cfif Request.IsFrontEnd>
						AND				A.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
					<cfelseif IsBoolean(Arguments.Status)>
						AND				A.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />		
					</cfif>
		
			) AS RowConstrainedResult

			WHERE		RowNum >= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.StartRow#" />
			AND			RowNum <= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.EndRow#" />
			
			ORDER BY 	RowNum		
		</cfquery>
		
		<cfreturn loc_Accounts />
	</cffunction>
	
	<cffunction name="GetAccountDetails" access="public" output="false" returntype="query">    
		<cfargument name="AccountID" default="0" />
        
		<cfset var loc_Account = "" />
        
		<cfquery datasource="#request.dsource#" name="loc_Account">
			SELECT		A.ID,
						A.Username,
						A.Email,
						A.FirstName,
						A.LastName,
						A.SchoolID,
						SCH.Title AS SchoolName,
						A.Signature,
						A.Status,
						A.IsAdvertiser,
						A.IsDealer,
						ADDR.Title AS AddressTitle,
						ADDR.Street1,
						ADDR.Street2,
						ADDR.City,
						ADDR.State,
						ADDR.ZipCode,
						ADDR.PhoneNumber,
						ADDR.URL						
			
			FROM		AMP_Accounts A
			LEFT JOIN	AMP_Address ADDR ON A.AddressID = ADDR.ID
			LEFT JOIN	AMP_Schools SCH ON A.SchoolID = SCH.ID
			
			WHERE		A.ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AccountID#" />
			<cfif Request.IsFrontEnd>
				AND		A.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
			</cfif>
		</cfquery>		
		
		<cfreturn loc_Account />
	</cffunction> 
	
	<cffunction name="GetAddressDetails" access="public" output="false" returntype="query">
		<cfargument name="AddressID" required="yes" type="numeric" />
		
		<cfset var loc_Address = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_Address">
			SELECT		ADDR.Title AS AddressTitle,
						ADDR.Street1,
						ADDR.Street2,
						ADDR.City,
						ADDR.State,
						ADDR.ZipCode,
						ADDR.PhoneNumber,
						ADDR.URL						
			
			FROM		AMP_Address ADDR
			
			WHERE		ADDR.ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AddressID#" />
		</cfquery>
		
		<cfreturn loc_Address />
	</cffunction>
	
	<cffunction name="GetProfileDetails" access="public" output="false" returntype="query">    
		<cfargument name="AccountID" required="yes" type="numeric" />
        
		<cfset var loc_Profile = "" />
        
		<cfquery datasource="#request.dsource#" name="loc_Profile">
			SELECT		A.ID,
						A.Username,
						A.Email,
						A.DateCreated,
						A.SchoolID,
						SCH.Title AS SchoolName,
						ADDR.City,
						ADDR.State				
			
			FROM		AMP_Accounts A
			LEFT JOIN	AMP_Address ADDR ON A.AddressID = ADDR.ID
			LEFT JOIN	AMP_Schools SCH ON A.SchoolID = SCH.ID
			
			WHERE		A.ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AccountID#" />
			AND			A.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
		</cfquery>		
		
		<cfreturn loc_Profile />
	</cffunction> 
	
	<cffunction name="CreateAccount" access="public" output="true" returntype="void" hint="I am called by 'sign up'">    
		<cfargument name="FirstName" type="string" default="" />
		<cfargument name="LastName" type="string" default="" />
		<cfargument name="Email" type="string" required="yes" />
		<cfargument name="Username" type="string" default="" />
		<cfargument name="Password" type="string" required="yes" />
		<cfargument name="School" type="string" default="" />
		
		<cfset var loc_CreateAccount = "" />
		<cfset var loc_Admin = Request.ListenerManager.GetListener( "AdminManager" ) />
		<cfset var loc_Users = Request.ListenerManager.GetListener( "UserManager" ) />
		<cfset var loc_PW = Arguments.Password />
		<cfset var loc_PWE = loc_Admin.GetHashedValue( InputValue:Arguments.Password ) />

		
		<cfquery datasource="#request.dsource#" name="loc_CreateAccount">
			INSERT INTO AMP_Accounts (
				Username,
				Password,
				Email,
				FirstName,
				LastName,
				SchoolID,
				Status,
				AddressID,		
				IsAdvertiser,
				IsDealer,
				DateCreated
			 )
			 VALUES (
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Username#" maxlength="20" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#loc_PWE#" maxlength="255" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Email#" maxlength="100" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.FirstName#" maxlength="50" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.LastName#" maxlength="50" />,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.School#" null="#NOT( IsNumeric( Arguments.School ) )#" />,
				<cfqueryparam cfsqltype="cf_sql_bit" value="1" />,
				NULL,		
				<cfqueryparam cfsqltype="cf_sql_bit" value="0" />,
				<cfqueryparam cfsqltype="cf_sql_bit" value="0" />,
				GetDate()
			 )
		</cfquery>
		
		<cfset loc_Users.VerifyLogin( Username:Arguments.Username, Password:loc_PWE, SuccessDestination:"/welcome-to-U4U.html" )>
		
	</cffunction>
	
	<cffunction name="UpdateAccount" access="public" output="false" returntype="void">    
		<cfargument name="AccountID" type="numeric" required="yes" />		
		<cfargument name="FirstName" type="string" default="" />
		<cfargument name="LastName" type="string" default="" />
		<cfargument name="Email" type="string" required="yes" />
		<cfargument name="Username" type="string" default="" />
		<cfargument name="Password" type="string" required="yes" />
		<cfargument name="School" type="string" default="" />
		<cfargument name="IsAdvertiser" default="0" />
		<cfargument name="IsDealer" default="0" />
		<cfargument name="Status" default="1" />
		<cfargument name="ReturnUrl" type="string" required="yes" />
		<cfargument name="AddressTitle" type="string" default="" />
		<cfargument name="Street1" type="string" default="" />
		<cfargument name="Street2" type="string" default="" />
		<cfargument name="City" type="string" default="" />
		<cfargument name="State" type="string" default="" />
		<cfargument name="ZipCode" type="string" default="" />
		<cfargument name="PhoneNumber" type="string" default="" />
		<cfargument name="Url" type="string" default="" />
		<cfargument name="Signature" type="string" default="" />
		<cfargument name="Image" type="string" default="" />
		
		<cfset var loc_UpdateAccount = "" />
		<cfset var loc_AccountID = Arguments.AccountID />
		<cfset var loc_PW = Arguments.Password />
		<cfset var loc_HasNewPW = false />
		<cfset var loc_ItemUploadPath = "" />
		<cfset var loc_Admin = Request.ListenerManager.GetListener( "AdminManager" ) />
		<cfset var loc_UserManager = Request.ListenerManager.GetListener( "UserManager" ) />
		<cfset var loc_SchoolManager = Request.ListenerManager.GetListener( "SchoolManager" ) />
		<cfset var loc_SchoolName = "" />
		<cfset var loc_ItemKey = "user" />
		<cfset var loc_StatusMessage = "" />
		<cfset var loc_ReturnUrl = "" />
		
		<cfif LEN( loc_PW )>
			<cfset loc_HasNewPW = true />
		</cfif>
		
		<cfquery datasource="#request.dsource#" name="loc_UpdateAccount">
			DECLARE @AddressID AS Int;
			DECLARE @AccountID AS Int;

			SET @AddressID = (
				SELECT	AddressID
				FROM	AMP_Accounts
				WHERE	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_AccountID#" />
			);
			
			SET @AccountID = (
				SELECT	ID
				FROM	AMP_Accounts
				WHERE	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_AccountID#" />
			);
			
			IF @AddressID IS NULL
			
				BEGIN
				
					SET NOCOUNT ON;
				
					INSERT INTO AMP_Address (
						Title,
						Street1,
						Street2,
						City,
						State,
						ZIPCode,
						PhoneNumber,
						URL,
						DateCreated
					) VALUES (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.AddressTitle#" maxlength="50" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Street1#" maxlength="50" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Street2#" maxlength="50" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.City#" maxlength="50" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.State#" maxlength="2" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ZipCode#" maxlength="10" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.PhoneNumber#" maxlength="20" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Url#" maxlength="200" />,
						GETDATE()	
					);
			
					SET @AddressID = @@IDENTITY;
					
				END
					
			ELSE
			
				UPDATE	AMP_Address
			
				SET		Street1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Street1#" maxlength="50" />,
						Street2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Street2#" maxlength="50" />,
						City = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.City#" maxlength="50" />,
						State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.State#" maxlength="2" />,
						ZIPCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ZipCode#" maxlength="10" />,
						PhoneNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.PhoneNumber#" maxlength="20" />,
						URL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Url#" maxlength="200" />,
						DateModified = GETDATE()
		
				WHERE	ID = @AddressID;
				
			IF @AccountID IS NULL
			
				BEGIN
				
					SET NOCOUNT ON;
					
					INSERT INTO AMP_Accounts (
						Username,
						Password,
						Email,
						FirstName,
						LastName,
						SchoolID,
					<cfif NOT Request.IsFrontEnd>
						IsAdvertiser,
						IsDealer,
						Signature,
						Status,
					<cfelse>
						Status,
					</cfif>
						AddressID,			
						DateCreated
					 ) VALUES (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Username#" maxlength="20" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#loc_PW#" maxlength="255" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Email#" maxlength="100" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.FirstName#" maxlength="50" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.LastName#" maxlength="50" />,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.School#" null="#NOT( IsNumeric( Arguments.School ) )#" />,
					<cfif NOT Request.IsFrontEnd>
						<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.IsAdvertiser#" />,
						<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.IsDealer#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Signature#" maxlength="2000" />,
						<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />,
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_bit" value="1" />,
					</cfif>
						@AddressID,						
						GetDate()
					 );
					 
					SELECT	@@IDENTITY AS NewID,
							'Account.Added' AS StatusMessage;
					SET NOCOUNT OFF;
					
				END
				
			ELSE
				
				UPDATE	AMP_Accounts
				
				SET		<cfif loc_HasNewPW>
							Password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#loc_PW#" maxlength="255" />,
						</cfif>
						Email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Email#" maxlength="100" />,
						FirstName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.FirstName#" maxlength="50" />,
						LastName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.LastName#" maxlength="50" />,
						SchoolID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.School#" null="#NOT( IsNumeric( Arguments.School ) )#" />,
						<cfif NOT Request.IsFrontEnd>
							IsAdvertiser = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.IsAdvertiser#" />,
							IsDealer = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.IsDealer#" />,
							Username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Username#" maxlength="20" />,
							Status = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />,
						</cfif>
						AddressID = @AddressID,
						Signature = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Signature#" maxlength="2000" />,
						DateModified = GetDate()
						
				WHERE	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_AccountID#" />;

				SELECT	#loc_AccountID# AS NewID,
						'Account.Updated' AS StatusMessage	
				
		</cfquery>
		
		<cfset loc_AccountID = loc_UpdateAccount.NewID />
		<cfset loc_StatusMessage = loc_UpdateAccount.StatusMessage />
		
		<!--- item image was uploaded --->
		<cfif len(Arguments.Image)>
		
			<cfset loc_ItemUploadPath = Request.Root[loc_ItemKey].Original & loc_AccountID & ".jpg" />
			
			<!--- upload user file (as-is) --->
			<cffile action="upload" filefield="Image" destination="#loc_ItemUploadPath#" nameconflict="overwrite" />
			
			<cfset loc_Admin.CreateImageVariations( ItemKey:loc_ItemKey, ItemID:loc_AccountID ) />
		
		</cfif>
		
		<cfif Request.IsFrontEnd>
		
			<!--- get school name --->
			<cfif IsNumeric( Arguments.School )>
				<cfset loc_SchoolName = loc_SchoolManager.GetSchoolDetails( SchoolID:Arguments.School ).Title />
			<cfelse>
				<cfset loc_SchoolName = "" />
			</cfif>
			
			<!--- update user session to reflect recent changes --->
			<cfset loc_UserManager.SetUserSession (
				UserName:Arguments.Username,
				FirstName:Arguments.FirstName,
				LastName:Arguments.LastName,
				SchoolID:Arguments.School,
				SchoolName:loc_SchoolName
			) />
			
			<cfset loc_ReturnUrl = "/profile-" & ListLast( loc_StatusMessage, "." ) & ".html" />
		<cfelse>
			<cfset loc_ReturnUrl = Arguments.ReturnUrl & "&AccountID=" & AccountID & "&Message=" & loc_StatusMessage />
		</cfif>
		
		<cflocation url="#loc_ReturnUrl#" addtoken="no" />
		
	</cffunction> 
	
	<cffunction name="DeleteAccount" access="public" output="false" returntype="void">    
		<cfargument name="AccountID" type="numeric" required="yes" />
		
		<cfset var loc_DeleteAccount = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_DeleteAccount">
			DECLARE @AddressID AS Int;

			SET @AddressID = (
				SELECT	AddressID
				FROM	AMP_Accounts
				WHERE	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AccountID#" />
			);
		
			DELETE
			FROM		AMP_Accounts
			WHERE		ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AccountID#" />;
			
			IF @AddressID IS NOT NULL
			
				DELETE
				FROM		AMP_Address
				WHERE		ID = @AddressID;	
		</cfquery>
		
	</cffunction>	
	
	<cffunction name="CancelAccount" access="public" output="false" returntype="void">    
		<cfargument name="AccountID" type="numeric" required="yes" />
		
		<cfset var loc_CancelAccount = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_CancelAccount">
			UPDATE		AMP_Accounts
			SET			Status = <cfqueryparam cfsqltype="cf_sql_bit" value="0" />
			WHERE		ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AccountID#" />
		</cfquery>
		
		<!---
			<!--- Delete the created sessions --->
			<cfloop collection="#session#" item="ThisKey">
				<cfif NOT ListFindNoCase( "cfid,cftoken", ThisKey )>
					<cfset StructDelete( session , "#ThisKey#" ) />
				</cfif>
			</cfloop>
			
			<cflocation url="/" addtoken="no" />	
		--->
		
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
			SELECT		ID
			FROM		AMP_Accounts
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
	
	<cffunction name="UpdateAccountPicture" access="public" output="false" returntype="void">    
		<cfargument name="AccountID" type="numeric" required="yes" />
		<cfargument name="Image" type="string" required="yes" />
		
		<cfset var loc_AccountID = Arguments.AccountID />
		<cfset var loc_Admin = Request.ListenerManager.GetListener( "AdminManager" ) />
		<cfset var loc_ItemKey = "user" />
		<cfset var loc_ItemUploadPath = Request.Root.User.Original & loc_AccountID & ".jpg" />
			
		<!--- upload user file (as-is) --->
		<cffile action="upload" filefield="Image" destination="#loc_ItemUploadPath#" nameconflict="overwrite" />
		
		<cfset loc_Admin.CreateImageVariations( ItemKey:loc_ItemKey, ItemID:loc_AccountID ) />
		
		<cflocation url="/profile-avatar-updated.html" addtoken="no" />	
		
	</cffunction>
	
	<cffunction name="SendContactRequest" access="public" output="false" returntype="void">  
		<cfargument name="AccountID" type="numeric" required="yes" />
		<cfargument name="FirstName" type="string" required="yes" />
		<cfargument name="LastName" type="string" required="yes" />
		<cfargument name="Email" type="string" required="yes" />
		<cfargument name="PhoneNumber" type="string" required="yes" />
		<cfargument name="Comments" type="string" required="yes" />
		
		<cfset var loc_AccountDetails = GetAccountDetails( AccountID:Arguments.AccountID ) />
		<cfset var loc_ReturnUrl = "" />
		
		<cfmail		to="#loc_AccountDetails.Email#"
					from="#Request.Sender_Email#"
					subject="User Contact Request from #Request.SiteLabel#">The following contact request was just submitted:
					
First Name: #Arguments.FirstName#

Last Name: #Arguments.LastName#

E-mail: #Arguments.Email#

Phone Number: #Arguments.PhoneNumber#

Comments: #Arguments.Comments#</cfmail>	

		<cfset loc_ReturnUrl = "/profile-#Arguments.AccountID#/contact-sent.html" />

		<cflocation url="#loc_ReturnUrl#" addtoken="no" />	
		
	</cffunction>
	
</cfcomponent>