<cfcomponent hint="This component will handle editing site administrators" extends="MachII.framework.Listener">

	<cfscript>
		this.SortOptions = ArrayNew(1);
		
		this.SortOptions[1] = ["email","E-mail","E.Email"];
		this.SortOptions[2] = ["source","Source","E.Email_Source"];
		this.SortOptions[3] = ["dateinserted","Date Inserted","E.Email_DateInserted"];
		this.SortOptions[4] = ["emailname","Full Name","E.EmailName"];
		this.SortOptions[5] = ["issubscribed","Date Created","E.Email_Subscribed"];
		
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
	
	<cffunction name="GetEmailSources" returntype="query">
		<cfset var loc_EmailSources = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_EmailSources">
			SELECT			E.Email_Source			
			FROM			Email_List E
			GROUP BY		E.Email_Source			
			ORDER BY		Email_Source
		</cfquery>
		
		<cfreturn loc_EmailSources />		
	</cffunction>

	<cffunction name="GetEmails" returntype="query">
		<cfargument name="StartRow" type="numeric" default="1" />
		<cfargument name="EndRow" type="numeric" default="#REQUEST.Settings.RecordsPerPage#" /> 
		<cfargument name="Email" type="string" default="" />
		<cfargument name="EmailSource" type="string" default="" />
		<cfargument name="DateInserted" type="string" default="" />
		<cfargument name="StartDate" type="string" default="#DateFormat(dateAdd('m',  '-1',  now()),'mm/dd/yyyy')#" />
		<cfargument name="EndDate" type="string" default="#DateFormat(now(),'mm/dd/yyyy')#" />
		<cfargument name="EmailName" type="string" default="" />
		<cfargument name="IsSubscribed" type="any" required="no" default="" />
		<cfargument name="sidx" type="string" required="no" default="#this.SortOptions[1][3]#" />
		<cfargument name="sord" type="string" required="no" default="#this.DefaultSord#" />
    	
		<cfset var loc_Emails = "" />
	
		<cfquery datasource="#request.dsource#" name="loc_Emails">
			SELECT		*
			FROM  (
					  
						SELECT			ROW_NUMBER() OVER ( ORDER BY #Arguments.sidx# #Arguments.sord# ) AS RowNum,
										COUNT(*) OVER () as Row_Total,
										E.EmailID,
										E.Email, 
										E.Email_Source,
										CONVERT(CHAR(10),E.Email_DateInserted,101) AS DateInserted,
										E.EmailName,
										E.Email_Subscribed
						
						FROM			Email_List E
						
						WHERE			1=1
						
					<CFIF Len(Arguments.EmailSource)>
						AND				E.Email_Source = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.EmailSource#" />		
					</CFIF>
					<CFIF Len(Arguments.Email)>
						AND				E.Email LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.Email#%" />		
					</CFIF>
					<CFIF Len(Arguments.EmailName)>
						AND				E.EmailName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.EmailName#%" />		
					</CFIF>
					<CFIF IsBoolean(Arguments.IsSubscribed)>
						AND				E.Email_Subscribed = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.IsSubscribed#" />		
					</CFIF>
					<CFIF Len(Arguments.StartDate)>
						AND				E.Email_DateInserted > <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.StartDate#">		
					</CFIF>
					<CFIF Len(Arguments.EndDate)>
						AND				E.Email_DateInserted < <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.EndDate#">		
					</CFIF>
					
			
			) AS RowConstrainedResult

			WHERE		RowNum >= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.StartRow#" />
			AND			RowNum <= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.EndRow#" />
			
			ORDER BY 	RowNum		
		</cfquery>
		
		<cfreturn loc_Emails />
		
	</cffunction>
    
	<cffunction name="GetEmailDetails" returntype="query" output="no" hint="I return the selected email details">
		<cfargument name="EmailID" type="numeric" default="0" />
		
		<cfset var loc_EmailDetails = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_EmailDetails">
			SELECT		EmailID,
						Email_source,
						Email,
						Email_DateInserted,
						Emailname,
						Email_subscribed, 
						StateName
			FROM		Email_list
			WHERE		EmailID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.EmailID#" />
		</cfquery>
		
		<cfreturn loc_EmailDetails />
	
	</cffunction>
	
	<cffunction name="UpdateEmail" returntype="void" output="no">
		<cfargument name="EmailID" type="numeric" required="yes" />		
		<cfargument name="IsSubscribed" type="string" required="yes" />
		<cfargument name="Email" type="string" required="yes" />
		<cfargument name="Emailname" type="string" required="yes" />
		<cfargument name="ReturnUrl" type="string" required="yes" />
		
		<cfset var loc_EmailID = Arguments.EmailID />
		<cfset var loc_UpdateEmail = "" />
		<cfset var loc_StatusMessage = "" />
		
		
		<cfquery datasource="#request.dsource#" name="loc_UpdateEmail">
			DECLARE @EmailID AS Int;

			SET @EmailID = (
				SELECT	EmailID
				FROM	Email_list
				WHERE	EmailID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_EmailID#" />
			);
			
			IF @EmailID IS NULL
			
				BEGIN
		
					SET NOCOUNT ON
					
					INSERT INTO Email_list (
						Email, 
						Emailname, 
						Email_source,
						Email_subscribed,
						Email_DateInserted
					) VALUES (
						 <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Email#" />,
						 <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Emailname#" />,
						 <cfqueryparam cfsqltype="cf_sql_char" value="Admin" />,
						 <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.IsSubscribed#" />,
						 GetDate()
						)
					 
					SELECT	@@IDENTITY AS NewID,
							'Email.Added' AS StatusMessage
					SET NOCOUNT OFF
				END
			ELSE
				BEGIN
		
					UPDATE	Email_list
					
					SET		Email = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Email#" />,
							Emailname =  <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Emailname#" />,
							Email_subscribed = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.IsSubscribed#" />
					WHERE	EmailID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_EmailID#" />;
					
					SELECT	#loc_EmailID# AS NewID,
							'Email.Updated' AS StatusMessage
				END
		</cfquery>
		
		<cfset loc_EmailID = loc_UpdateEmail.NewID />
		<cfset loc_StatusMessage = loc_UpdateEmail.StatusMessage />
		
		<cflocation url="#Arguments.ReturnUrl#&Message=#loc_StatusMessage#&EmailID=#loc_EmailID#" addtoken="no" />
    
    </cffunction>
    
    <cffunction name="DeleteEmail" access="public" output="false" returntype="void">    
		<cfargument name="EmailID" type="string" required="yes" />		
		
		<cfset var loc_DeleteEmail = "" />		
		<cfset var loc_EmailIDList = "#Arguments.EmailID#" />
		<cfset var loc_ThisEmailID = "" />
		
		
		<cfquery datasource="#request.dsource#" name="loc_DeleteEmail">
			<cfloop list="#loc_EmailIDList#" index="loc_ThisEmailID">
				DELETE
				FROM		Email_list
				WHERE		EmailID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_ThisEmailID#" />;
				</cfloop>
		</cfquery>
		
	</cffunction>
	
	<cffunction name="Subscribe" access="public" output="false" returntype="boolean">    
		<cfargument name="Email" type="string" required="yes" />		
		
		<cfset var loc_Subscribe = "" />
		<cfset var loc_IsNewEmail = true />
		<cfset var loc_Email = TRIM( LCASE( Arguments.Email ) ) />
		
		<cfquery datasource="#request.dsource#" name="loc_Subscribe">
			DECLARE @EmailID AS Int;

			SET @EmailID = (
				SELECT	EmailID
				FROM	Email_list
				WHERE	Email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#loc_Email#" />
			);
			
			IF @EmailID IS NULL
			
				BEGIN
		
					INSERT INTO Email_list (
						Email, 
						Emailname, 
						Email_source,
						Email_subscribed,
						Email_DateInserted
					) VALUES (
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#loc_Email#" />,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="" />,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="Home Page" />,
						 <cfqueryparam cfsqltype="cf_sql_bit" value="1" />,
						 GetDate()
						)
					 
					SELECT	'Email.Added' AS StatusMessage
					
				END
			ELSE
				BEGIN						
					SELECT	'Email.Exists' AS StatusMessage
				END
		</cfquery>
		
		<cfif loc_Subscribe.StatusMessage EQ "Email.Exists">
			<cfset loc_IsNewEmail = false />
		</cfif>
		
		<cfreturn loc_IsNewEmail />		
	</cffunction>
	
	<cffunction name="BuildEmailCSV" access="public" output="false"  returntype="void">
		<cfargument name="EmailID" type="string" required="yes" />	
		<!--- <cfargument name="ReturnUrl" type="string" required="yes" /> --->
		
		<cfset var loc_EmailCSV = "" />
		
		<!--- EmailID: <cfoutput>#Arguments.EmailID#</cfoutput><cfabort> --->
		
		<cfquery datasource="#request.dsource#" name="loc_EmailCSV">
		SELECT 	Email
		FROM	Email_list
		WHERE	emailID IN (#Arguments.EmailID#)
		</cfquery>
		
		<CFSET columnnames = "">
		<cfoutput query="loc_EmailCSV">
			<CFSET columnnames = #listappend(columnnames,"#Email#",chr(10))#>
		</cfoutput>

		<!--- #REQUEST.Root.Server.Email.CSV# --->
		<CFFILE action="write" file="d:\inetpub\wwwroot\sheehan\DisplayPages\admin\Emails\EmailAddress.xls" nameconflict="overwrite" output="#columnnames#">

		<!--- <cfoutput><a href="#REQUEST.Root.Web.Base##REQUEST.Root.Paths.Email.CSV#EmailAddress.xls">Open CSV file</a></cfoutput>		 --->
	</cffunction>

</cfcomponent>