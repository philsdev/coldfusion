<cfcomponent hint="This component will handle loggin in and logging out the front end" extends="MachII.framework.Listener">

	<cfscript>
		this.SessionUserIdentifier = "UserID";
		this.SessionUserLabel = "Username";
		this.SessionFirstNameLabel = "FirstName";
		this.SessionLastNameLabel = "LastName";
		this.SessionAdvertiserLabel = "UserIsAdvertiser";
		this.SessionDealerLabel = "UserIsDealer";
		this.SessionSchoolIdentifier = "SchoolID";
		this.SessionSchoolLabel = "SchoolName";
		this.SessionSuccessDestination = "SuccessDestination";

		this.PasswordGen = StructNew();
		this.PasswordGen.UpperCount = 1;
		this.PasswordGen.LowerCount = 3;
		this.PasswordGen.NumberMin = 1000;
		this.PasswordGen.NumberMax = 9999;
		this.PasswordGen.CharList = "abcdefghijklmnopqrstuvwxyz";
		
		this.LoginFailureMax = Request.LoginFailureMax;
	</cfscript>
	
	<cffunction name="GetHomepage" output="no" returntype="void" access="public">
	
		<cfif IsValidatedUser()>
			<cfset AnnounceEvent('Homepage.User')>
		<cfelse>
			<cfset AnnounceEvent('Homepage.Visitor')>
		</cfif>
	
	</cffunction>
	
	<cffunction name="EnforceLogin" output="no" returntype="void" access="public">
		<cfargument name="SuccessDestination" default="" />
		<cfargument name="SuccessTargetID" default="" />
		<cfargument name="SuccessTargetType" default="" />
		
		<cfset var loc_LinkManager = Request.ListenerManager.GetListener( "LinkManager" ) />
		<cfset var loc_ItemManager = "" />
		<cfset var loc_ItemDetails = "" />
		<cfset var loc_ItemType = Arguments.SuccessTargetType />
		<cfset var loc_ItemID = Arguments.SuccessTargetID />
		<cfset var loc_ItemTitle = "" />
		<cfset var loc_ItemLink = "" />
		
		<cfif NOT IsValidatedUser()>
			
			<!--- user was trying to access a main page (deals, events, etc) --->
			<cfif LEN( Arguments.SuccessDestination )>
				<cflock type="exclusive" scope="session" timeout="10">
					<cfset session[this.SessionSuccessDestination] = Arguments.SuccessDestination />
				</cflock>
			<!--- user was trying to access a detail page, so we have to build the html link for seo purposes --->
			<cfelseif LEN( loc_ItemID ) AND LEN( loc_ItemType )>
				<cfswitch expression="#loc_ItemType#">
					<cfcase value="Deal">
						<cfset loc_ItemManager = Request.ListenerManager.GetListener( "DealManager" ) />
						<cfset loc_ItemDetails = loc_ItemManager.GetDealDetails( DealID:loc_ItemID ) />
						<cfset loc_ItemTitle = loc_ItemDetails.Title />
						<cfset loc_ItemLink = loc_LinkManager.GetDealLink( DealID:loc_ItemID, DealTitle:loc_ItemTitle ) />
					</cfcase>
					<cfcase value="Event">
						<cfset loc_ItemManager = Request.ListenerManager.GetListener( "EventManager" ) />
						<cfset loc_ItemDetails = loc_ItemManager.GetEventDetails( EventID:loc_ItemID ) />
						<cfset loc_ItemTitle = loc_ItemDetails.Title />
						<cfset loc_ItemLink = loc_LinkManager.GetEventLink( EventID:loc_ItemID, EventTitle:loc_ItemTitle ) />
					</cfcase>
					<cfcase value="Job">
						<cfset loc_ItemManager = Request.ListenerManager.GetListener( "JobManager" ) />
						<cfset loc_ItemDetails = loc_ItemManager.GetJobDetails( JobID:loc_ItemID ) />
						<cfset loc_ItemTitle = loc_ItemDetails.Title />
						<cfset loc_ItemLink = loc_LinkManager.GetJobLink( JobID:loc_ItemID, JobTitle:loc_ItemTitle ) />
					</cfcase>
					<cfcase value="Marketplace">
						<cfset loc_ItemManager = Request.ListenerManager.GetListener( "MarketplaceManager" ) />
						<cfset loc_ItemDetails = loc_ItemManager.GetItemDetails( ItemID:loc_ItemID ) />
						<cfset loc_ItemTitle = loc_ItemDetails.Title />
						<cfset loc_ItemLink = loc_LinkManager.GetMarketplaceLink( MarketplaceID:loc_ItemID, MarketplaceTitle:loc_ItemTitle ) />
					</cfcase>
				</cfswitch>
				
				<cfif LEN( loc_ItemLink )>
					<cflock type="exclusive" scope="session" timeout="10">
						<cfset session[this.SessionSuccessDestination] = loc_ItemLink />
					</cflock>
				</cfif>
			</cfif>
		
			<cflocation url="/login.html" addtoken="no" />
		</cfif>
	
	</cffunction>
	
	<cffunction name="IsValidatedUser" output="no" returntype="boolean" access="public">
		
		<cfset var loc_IsValidatedUser = false />
		
		<cfif StructKeyExists(request, this.SessionUserIdentifier) AND request[this.SessionUserIdentifier] GT 0>
			<cfset loc_IsValidatedUser = true />	
		</cfif>
		
		<cfreturn loc_IsValidatedUser />		
	</cffunction>
	
	<cffunction name="EnforceSchool" output="no" returntype="void" access="public">
	
		<cfif NOT IsSchoolUser()>
			<cflocation url="/school-required.html" addtoken="no" />
		</cfif>
	
	</cffunction>
	
	<cffunction name="IsSchoolUser" output="no" returntype="boolean" access="public">
		
		<cfset var loc_IsSchoolUser = false />
		
		<cfif StructKeyExists(request, this.SessionSchoolIdentifier) AND request[this.SessionSchoolIdentifier] GT 0>
			<cfset loc_IsSchoolUser = true />	
		</cfif>
		
		<cfreturn loc_IsSchoolUser />		
	</cffunction>
	
	<cffunction name="EnforceAdvertiser" output="no" returntype="void" access="public">
	
		<cfif NOT IsAdvertiser()>
			<cflocation url="/unavailable.html" addtoken="no" />
		</cfif>
	
	</cffunction>
	
	<cffunction name="IsAdvertiser" output="no" returntype="boolean" access="public">
		
		<cfset var loc_IsAdvertiser = false />
		
		<cfif StructKeyExists(request, this.SessionAdvertiserLabel) AND request[this.SessionAdvertiserLabel]>
			<cfset loc_IsAdvertiser = true />	
		</cfif>
		
		<cfreturn loc_IsAdvertiser />		
	</cffunction>
	
	<cffunction name="EnforceDealer" output="no" returntype="void" access="public">
	
		<cfif NOT IsDealer()>
			<cflocation url="/unavailable.html" addtoken="no" />
		</cfif>
	
	</cffunction>
	
	<cffunction name="IsDealer" output="no" returntype="boolean" access="public">
		
		<cfset var loc_IsDealer = false />
		
		<cfif StructKeyExists(request, this.SessionDealerLabel) AND request[this.SessionDealerLabel]>
			<cfset loc_IsDealer = true />	
		</cfif>
		
		<cfreturn loc_IsDealer />		
	</cffunction>
	
	<cffunction name="GetCurrentUser" output="no" returntype="numeric" access="public">
	
		<cfset var loc_UserID = 0 />
		
		<cflock type="readonly" scope="session" timeout="10">
			<cfif StructKeyExists( SESSION, this.SessionUserIdentifier ) AND IsNumeric( SESSION[this.SessionUserIdentifier] )>
				<cfset loc_UserID = SESSION[this.SessionUserIdentifier] />
			</cfif>
		</cflock>
		
		<cfreturn loc_UserID />
	</cffunction>
	
	<cffunction name="GeneratePassword" output="no" access="private" returntype="string">
		
		<cfset var loc_newPassword = "" />
		<cfset var loc_index = "" />
		<cfset var loc_charsUpper = "" />
		<cfset var loc_charsLower = "" />
		<cfset var loc_charsNumeric = "" />
		
		<cfloop from="1" to="#this.PasswordGen.UpperCount#" index="loc_index">
			<cfset loc_charsUpper = loc_charsUpper & UCASE( MID( this.PasswordGen.CharList, RandRange(1,26), 1 ) ) />
		</cfloop>
		
		<cfloop from="1" to="#this.PasswordGen.LowerCount#" index="loc_index">
			<cfset loc_charsLower = loc_charsLower & LCASE( MID( this.PasswordGen.CharList, RandRange(1,26), 1 ) ) />
		</cfloop>
		
		<cfset loc_charsNumeric = RandRange( this.PasswordGen.NumberMin, this.PasswordGen.NumberMax ) />
		
		<cfset loc_newPassword = loc_charsUpper & loc_charsLower & loc_charsNumeric />
		
		<cfreturn loc_newPassword />		
	</cffunction>	
	
	<cffunction name="SetAccountLock" output="no" access="public" returntype="void">	
		<cfargument name="UserID" type="numeric" required="true" />
		<cfargument name="IsLockNeeded" type="boolean" required="true" />
		
		<cfset var loc_AccountLock = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_AccountLock">
			UPDATE 		AMP_Accounts
			SET			IsLocked = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.IsLockNeeded#" />,
						DateModified = GETDATE()
			WHERE		ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.UserID#" />
		</cfquery>
				
	</cffunction>
	
	<cffunction name="SetLoginResult" output="no" access="public" returntype="void">	
		<cfargument name="UserID" type="numeric" required="true" />
		<cfargument name="IsSuccess" type="boolean" required="true" />
		
		<cfset var loc_LoginResult = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_LoginResult">
			INSERT INTO AMP_AccountLoginHistory (
				AccountID,
				IsSuccess,
				IPAddress,
				DateCreated
			) VALUES (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.UserID#" />,
				<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.IsSuccess#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_HOST#" maxlength="15" />,
				GETDATE()
			)
		</cfquery>
				
	</cffunction>
	
	<cffunction name="SetUserSession" output="no" access="public" returntype="void">
		
		<cflock type="exclusive" scope="session" timeout="10">			

			<cfif StructKeyExists( Arguments, "UserID" )>
				<cfset Session[this.SessionUserIdentifier] = Arguments.UserID />
			</cfif>
			
			<cfif StructKeyExists( Arguments, "Username" )>
				<cfset Session[this.SessionUserLabel] = Arguments.Username />
			</cfif>	
			
			<cfif StructKeyExists( Arguments, "FirstName" )>
				<cfset Session[this.SessionFirstNameLabel] = Arguments.FirstName />
			</cfif>	
			
			<cfif StructKeyExists( Arguments, "LastName" )>
				<cfset Session[this.SessionLastNameLabel] = Arguments.LastName />
			</cfif>	
			
			<cfif StructKeyExists( Arguments, "IsAdvertiser" )>
				<cfset Session[this.SessionAdvertiserLabel] = Arguments.IsAdvertiser />
			</cfif>	
			
			<cfif StructKeyExists( Arguments, "IsDealer" )>
				<cfset Session[this.SessionDealerLabel] = Arguments.IsDealer />
			</cfif>	
			
			<cfif StructKeyExists( Arguments, "SchoolID" )>
				<cfset Session[this.SessionSchoolIdentifier] = Arguments.SchoolID />
			</cfif>	
			
			<cfif StructKeyExists( Arguments, "SchoolName" )>
				<cfset Session[this.SessionSchoolLabel] = Arguments.SchoolName />
			</cfif>	
			
		</cflock>
		
	</cffunction>	
	
	<cffunction name="VerifyLogin" output="no" access="public" returntype="string">	
		<cfargument name="Username" type="string" required="true" />
		<cfargument name="Password" type="string" required="true" />
		<cfargument name="SuccessDestination" default="/" />
		
		<cfset var loc_UserID = 0 />
		<cfset var loc_FindUser = "" />
		<cfset var loc_UpdateUser = "" />
		<cfset var loc_IsLocked = false />
		<cfset var loc_Success = false />
		<cfset var loc_NewArgs = "" />
		<cfset var loc_Admin = Request.ListenerManager.GetListener( "AdminManager" ) />
		<cfset var loc_ReturnUrl = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_FindUser">
			SELECT		A.ID,
						A.FirstName,
						A.LastName,
						A.Username,
						A.Password,
						A.SchoolID,
						S.Title AS SchoolName,
						A.IsAdvertiser,
						A.IsDealer,
						A.IsLocked,
						ISNULL(SUM(CASE WHEN H.IsSuccess = 0 AND H.DateCreated > ALHS.LastSuccess THEN 1 END),0) AS FailureCount
						
			FROM		AMP_Accounts A
			
			LEFT JOIN	AMP_Schools S ON A.SchoolID = S.ID
			
			LEFT JOIN	AMP_AccountLoginHistory H ON A.ID = H.AccountID
			
			LEFT JOIN	(
							SELECT		AccountID,
										MAX(CASE WHEN IsSuccess = 1 THEN DateCreated END) AS LastSuccess
							FROM		AMP_AccountLoginHistory	
							GROUP BY	AccountID
						) ALHS ON A.ID = ALHS.AccountID
			
			WHERE		A.Username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Username#" />
			AND			A.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
			
			GROUP BY	A.ID,
						A.FirstName,
						A.LastName,
						A.Username,
						A.Password,
						A.SchoolID,
						S.Title,
						A.IsAdvertiser,
						A.IsDealer,
						A.IsLocked
		</cfquery>
		
		<!--- user exists --->
		<cfif loc_FindUser.RecordCount>
		
			<cfset loc_UserID = loc_FindUser.ID />
		
			<!--- locked user --->
			<cfif loc_FindUser.IsLocked>
				<cfset loc_IsLocked = true />
			<!--- successful login --->
			<cfelseif loc_FindUser.Password EQ Arguments.Password>
				<cfset loc_Success = true />
			<!--- user at bad login max, account needs to be locked --->
			<cfelseif loc_FindUser.FailureCount GTE this.LoginFailureMax>
				<cfset SetAccountLock( UserID:loc_UserID, IsLockNeeded:true ) />
				<cfset loc_IsLocked = true />
			</cfif>
			
			<!--- if an attempt was made for a known user, record the status --->
			<cfset SetLoginResult( UserID:loc_UserID, IsSuccess:loc_Success ) />
		</cfif>
				
		<cfif loc_Success>
			<cfset SetUserSession (
				UserID:loc_UserID,
				UserName:loc_FindUser.Username,
				FirstName:loc_FindUser.FirstName,
				LastName:loc_FindUser.LastName,
				IsAdvertiser:loc_FindUser.IsAdvertiser,
				IsDealer:loc_FindUser.IsDealer,
				SchoolID:loc_FindUser.SchoolID,
				SchoolName:loc_FindUser.SchoolName,
				SuccessDestination:''
			) />
			
			<!--- user is loggin in after attempting a secure page --->
			<cfif LEN( Request.SuccessDestination )>
				<cfset loc_ReturnUrl= Request.SuccessDestination />
			<cfelse>
				<cfset loc_ReturnUrl = Arguments.SuccessDestination />
			</cfif>
			
		<cfelse>
			<cfset SetUserSession (
				UserID:0,
				UserName:"",
				FirstName:"",
				LastName:"",
				IsAdvertiser:0,
				IsDealer:0,
				SchoolID:0,
				SchoolName:""
			) />
			<cfif loc_IsLocked>
				<cfset loc_ReturnUrl="/login-locked.html" />
			<cfelse>
				<cfset loc_ReturnUrl="/login-error.html" />
			</cfif>
		</cfif>
		
		<cflocation url="#loc_ReturnUrl#" addtoken="no" />	
	</cffunction>
	
	<cffunction name="UpdatePassword" access="public" output="true" returntype="void"> 
		<cfargument name="AccountID" type="numeric" required="yes" />
		<cfargument name="PasswordExisting" type="string" required="yes" />
		<cfargument name="Password" type="string" required="yes" />
		
		<cfset var loc_AccountID = Arguments.AccountID />
		<cfset var loc_PWE = Arguments.PasswordExisting />
		<cfset var loc_PW = Arguments.Password />
		<cfset loc_VerifyAccount = "" />
		<cfset loc_UpdatePassword = "" />
		
		<cfif loc_PWE EQ loc_PW>
			<cflocation url="/password-unique.html" addtoken="no" />
		</cfif>
		
		<!--- verify user is current and supplied correct existing password --->
		<cfquery datasource="#request.dsource#" name="loc_VerifyAccount" maxrows="1">
			SELECT		ID
			FROM		AMP_Accounts
			WHERE		ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_AccountID#" />
			AND			Password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#loc_PWE#" />
			AND			Status = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
		</cfquery>
		
		<cfif NOT loc_VerifyAccount.RecordCount>
			<cflocation url="/password-incorrect.html" addtoken="no" />
		</cfif>
		
		<cfquery datasource="#request.dsource#" name="loc_UpdatePassword">
			UPDATE		AMP_Accounts
			SET			Password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#loc_PW#" />
			WHERE		ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_AccountID#" />
		</cfquery>
		
		<cflocation url="/password-set.html" addtoken="no" />		
	</cffunction>
	
	<cffunction name="ResetPassword" output="no" access="public" returntype="void">	
		<cfargument name="Username" type="string" required="true" />
		
		<cfset var loc_FindUser = "" />
		<cfset var loc_UserID = "" />
		<cfset var loc_Admin = Request.ListenerManager.GetListener( "AdminManager" ) />
		<cfset var loc_newPassword = "" />
		<cfset var loc_newPasswordHashed = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_FindUser" maxrows="1">
			SELECT		ID,
						Email
			FROM		AMP_Accounts
			WHERE		Username = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Username#" />
			AND			Status = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
		</cfquery>	
		
		<cfif NOT loc_FindUser.RecordCount>
			<cflocation url="/password-forgot-error.html" addtoken="no" />
		<cfelse>
			<cfset loc_UserID = loc_FindUser.ID />
			<cfset loc_UserEmail = loc_FindUser.Email />
			
			<cfset loc_newPassword = GeneratePassword() />
			<cfset loc_newPasswordHashed = loc_Admin.GetHashedValue( loc_newPassword ) />
			
			<cfquery datasource="#request.dsource#" name="loc_FindUser">
				UPDATE		AMP_Accounts
				SET			Password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#loc_newPasswordHashed#" />
				WHERE		ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_UserID#" />
			</cfquery>
			
			<cfmail		to="#loc_UserEmail#"
						from="#Request.Admin_Email#"
						subject="Your Account on #Request.SiteLabel#">At your request, we have reset your password to: #loc_newPassword#
						
Thank you,
#Request.SiteLabel#</cfmail>
			
			<cflocation url="/login-password-reset.html" addtoken="no" />			
		</cfif>
		
	</cffunction>
	
	<cffunction name="Logout">
		
		<!--- Delete the created sessions --->
		<cfloop collection="#session#" item="ThisKey">
			<cfif NOT ListFindNoCase( "cfid,cftoken", ThisKey )>
				<cfset StructDelete( session , "#ThisKey#" ) />
			</cfif>
		</cfloop>
		
		<!--- Admin logged out, call the Event to display the login page --->
		<cflocation url="logged-out.html" addtoken="no" />
        
	</cffunction>    
	
</cfcomponent>