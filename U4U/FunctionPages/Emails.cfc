<cfcomponent extends="MachII.framework.Listener">

	<cfscript>
		this.SortOptions = ArrayNew(1);
		
		this.SortOptions[1] = ["email","E-mail","E.Email"];
		this.SortOptions[2] = ["datecreated","Date Created","E.DateCreated"];
		this.SortOptions[3] = ["status","Status","ST.Status"];
	</cfscript>
	
	<cffunction name="GetSortOptions" access="public" output="false" returntype="array"> 
		<cfreturn this.SortOptions />
	</cffunction>
		
	<cffunction name="GetEmails" access="public" output="false" returntype="query">    
		<cfargument name="StartRow" type="numeric" default="1" />
		<cfargument name="EndRow" type="numeric" default="#Request.RecordsPerPage#" /> 
		<cfargument name="Email" type="string" default="" />
		<cfargument name="Status" type="string" default="" />
		<cfargument name="sidx" type="string" required="no" default="#this.SortOptions[1][3]#" />
		<cfargument name="sord" type="string" required="no" default="asc" />
        
		<cfset var loc_Emails = "" />
        
		<cfquery datasource="#request.dsource#" name="loc_Emails">
			SELECT		*
			FROM  (
					  
						SELECT			ROW_NUMBER() OVER ( ORDER BY #Arguments.sidx# ) AS RowNum,
										COUNT(*) OVER () as Row_Total,
										E.ID,
										E.Email,
										CONVERT(CHAR(10),E.DateCreated,101) AS DateCreated,
										ST.Status
						
						FROM			AMP_Emails E
						LEFT JOIN		AMP_Status ST ON E.Status = ST.ID
						
						WHERE			1=1
					<cfif Len(Arguments.Email)>
							AND			E.Email LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.Email#%" />		
					</cfif>
					<cfif IsBoolean(Arguments.Status)>
						AND				E.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />		
					</cfif>
		
			) AS RowConstrainedResult

			WHERE		RowNum >= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.StartRow#" />
			AND			RowNum <= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.EndRow#" />
			
			ORDER BY 	RowNum	
		</cfquery>
		
		<cfreturn loc_Emails />
	</cffunction>
	
	<cffunction name="GetEmailDetails" access="public" output="false" returntype="query">    
		<cfargument name="EmailID" default="0" />
        
		<cfset var loc_Email = "" />
        
		<cfquery datasource="#request.dsource#" name="loc_Email">
			SELECT		E.ID,
						E.Email,
						E.Status
			
			FROM		AMP_Emails E
			
			WHERE		E.ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.EmailID#" />
		</cfquery>		
		
		<cfreturn loc_Email />
	</cffunction> 
	
	<cffunction name="UpdateEmail" access="public" output="true" returntype="void">    
		<cfargument name="IsBackEnd" default="no">
		<cfargument name="EmailID" type="numeric" required="yes" />		
		<cfargument name="Status" default="1" />
		<cfargument name="Email" type="string" default="" />
		
		<cfset var loc_UpdateEmail = "" />
		<cfset var loc_EmailID = Arguments.EmailID />
		<cfset var loc_StatusMessage = "" />
		<cfset var loc_ReturnUrl = "" />
		
	   	<cfquery datasource="#request.dsource#" name="loc_UpdateEmail">
			DECLARE @EmailID AS Int;

			SET @EmailID = (
				SELECT	ID
				FROM	AMP_Emails
				WHERE	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_EmailID#" />
			);
			
			IF @EmailID IS NULL
			
				BEGIN
				
					SET NOCOUNT ON;
					
					INSERT INTO AMP_Emails (
						Email,
						Status,
						DateCreated
					 )
					 VALUES (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Email#" maxlength="100" />,
						<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />,
						GetDate()
					 )
						 
					SELECT	@@IDENTITY AS NewID,
							'Email.Added' AS StatusMessage;
					SET NOCOUNT OFF;
				END
			ELSE
				BEGIN
				
					UPDATE	AMP_Emails
			
					SET		Email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Email#" maxlength="100" />,
							Status = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />,
							DateModified = GETDATE()					
			
					WHERE	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_EmailID#" />;
			
					SELECT	#loc_EmailID# AS NewID,
							'Email.Updated' AS StatusMessage;
				END
		</cfquery>
		
		<cfset loc_EmailID = loc_UpdateEmail.NewID />
		<cfset loc_StatusMessage = loc_UpdateEmail.StatusMessage />
		
		<cfset loc_ReturnUrl = Arguments.ReturnUrl />
		<cfif Arguments.IsBackEnd>
			<cfset loc_ReturnUrl = loc_ReturnUrl & "&EmailID=" & loc_EmailID />
		</cfif>
		
		<cflocation url="#loc_ReturnUrl#" addtoken="no" />	
		
	</cffunction> 
	
	<cffunction name="DeleteEmail" access="public" output="false" returntype="void">    
		<cfargument name="EmailID" type="numeric" required="yes" />
		
		<cfset var loc_DeleteEmail = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_DeleteEmail">
			DELETE
			FROM		AMP_Emails
			WHERE		ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.EmailID#" />
		</cfquery>
		
	</cffunction>
	
	<cffunction name="EmailListSubscribe" access="public" output="false" returntype="void">    
		<cfargument name="Email" type="string" default="" />
		
		<cfset var loc_UpdateEmail = "" />
		<cfset var loc_Email = Arguments.Email />
		
	   	<cfquery datasource="#request.dsource#" name="loc_UpdateEmail">
			DECLARE @EmailID AS Int;

			SET @EmailID = (
				SELECT	ID
				FROM	AMP_Emails
				WHERE	Email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#loc_Email#" />
			);
			
			IF @EmailID IS NULL
			
				BEGIN
				
					INSERT INTO AMP_Emails (
						Email,
						Status,
						DateCreated
					 )
					 VALUES (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Email#" maxlength="100" />,
						1,
						GetDate()
					 );
				END
			ELSE
				BEGIN
				
					UPDATE	AMP_Emails
			
					SET		Email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Email#" maxlength="100" />,
							Status = 1,
							DateModified = GETDATE()					
			
					WHERE	ID = @EmailID;
				END
		</cfquery>
					
	</cffunction>
	
	<cffunction name="EmailListUnsubscribe" access="public" output="false" returntype="void">    
		<cfargument name="Email" type="string" default="" />
		
		<cfset var loc_UpdateEmail = "" />
		<cfset var loc_Email = Arguments.Email />
		
	   	<cfquery datasource="#request.dsource#" name="loc_UpdateEmail">
			DECLARE @EmailID AS Int;

			SET @EmailID = (
				SELECT	ID
				FROM	AMP_Emails
				WHERE	Email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#loc_Email#" />
			);
			
			IF @EmailID IS NULL
			
				BEGIN
				
					INSERT INTO AMP_Emails (
						Email,
						Status,
						DateCreated
					 )
					 VALUES (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Email#" maxlength="100" />,
						0,
						GetDate()
					 );
				END
			ELSE
				BEGIN
				
					UPDATE	AMP_Emails
			
					SET		Email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Email#" maxlength="100" />,
							Status = 0,
							DateModified = GETDATE()					
			
					WHERE	ID = @EmailID;
				END
		</cfquery>
				
	</cffunction> 
	
	<cffunction name="IsValidSchoolEmail" access="public" output="true" returntype="void">    
		<cfargument name="School" type="numeric" required="yes" />
		<cfargument name="Email" type="string" required="yes" />
		
		<cfset var loc_Email = Arguments.Email />
		<cfset var loc_IsValidEmail = "" />
		<cfset var loc_EmailSubdomain = "" />
		
		<cfset enablecfoutputonly="yes" />
		<cfcontent reset="yes" />
		
		<cfif ListLen( loc_Email, "@" ) EQ 2>
			<cfset loc_EmailSubdomain = ListGetAt( Loc_Email, 2, "@" ) />
		<cfelse>
			<cfoutput>0</cfoutput>
			<cfabort>
		</cfif>
		
		<cfquery datasource="#request.dsource#" name="loc_IsValidEmail">
			SELECT		COUNT(*) AS Total
			FROM		AMP_SchoolEmailDomains
			WHERE		SchoolID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.School#" />
			AND			<cfqueryparam cfsqltype="cf_sql_varchar" value="#loc_EmailSubdomain#" maxlength="50" /> LIKE '%' + Subdomain + '%'
		</cfquery>
		
		<cfset loc_IsValidEmail = IIF( loc_IsValidEmail.Total GT 0, 1, 0 ) />
		
		<cfoutput>#loc_IsValidEmail#</cfoutput>
		
	</cffunction>
	
</cfcomponent>