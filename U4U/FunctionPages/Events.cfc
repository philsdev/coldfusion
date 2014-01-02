<cfcomponent extends="MachII.framework.Listener">

	<cfscript>
		this.SortOptions = ArrayNew(1);
		
		this.SortOptions[1] = ["startdate","Start Date","E.StartDate, E.Title"];
		this.SortOptions[2] = ["enddate","End Date","E.EndDate, E.Title"];	
		this.SortOptions[3] = ["title","Title","E.Title"];
		this.SortOptions[4] = ["school","School","SCH.Title"];
		this.SortOptions[5] = ["category","Category","EC.Title"];
		this.SortOptions[6] = ["organizer","Organizer","E.Organizer"];
		this.SortOptions[7] = ["city","City","A.City"];
		this.SortOptions[8] = ["state","State","A.State"];
		this.SortOptions[9] = ["datecreated","Date Created","E.DateCreated"];
		this.SortOptions[10] = ["status","Status","ST.Status"];
		
		this.DefaultSearchText = "Search Events";
	</cfscript>
	
	<cffunction name="GetDefaultSearchText" access="public" output="false" returntype="string">
		<cfreturn this.DefaultSearchText />
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
	
	<cffunction name="GetEvents" access="public" output="false" returntype="query">    
		<cfargument name="StartRow" type="numeric" default="1" />
		<cfargument name="EndRow" type="numeric" default="#Request.RecordsPerPage#" /> 
		<cfargument name="Title" type="string" default="" />
		<cfargument name="School" type="string" default="" />
		<cfargument name="Category" type="string" default="" />
		<cfargument name="User" type="string" default="" />
		<cfargument name="Organizer" type="string" default="" />
		<cfargument name="City" type="string" default="" />
		<cfargument name="State" type="string" default="" />
		<cfargument name="StartDate" type="string" default="" />
		<cfargument name="EndDate" type="string" default="" />		
		<cfargument name="Status" type="string" default="" />
		<cfargument name="SearchTerm" type="string" default="" />
		<cfargument name="sidx" type="string" required="no" default="#this.SortOptions[1][3]#" />
		<cfargument name="sord" type="string" required="no" default="asc" />
        
		<cfset var loc_Events = "" />
		<cfset var loc_SearchTerm = TRIM( Arguments.SearchTerm ) />
		
		<cfif loc_SearchTerm EQ this.DefaultSearchText>
			<cfset loc_SearchTerm = "" />
		<cfelseif LEN(loc_SearchTerm)>
			<cfset loc_SearchTerm = "%" & Arguments.SearchTerm & "%" />
		</cfif>
        
		<cfquery datasource="#request.dsource#" name="loc_Events">
			SELECT		*
			FROM  (
					  
						SELECT			ROW_NUMBER() OVER ( ORDER BY #Arguments.sidx# ) AS RowNum,
										COUNT(*) OVER () as Row_Total,
										E.ID,
										E.Title,
										E.Description,
										E.Organizer,	
										E.AddressID,										
										ADDR.Title AS AddressTitle,
										ADDR.Street1,
										ADDR.Street2,
										ADDR.City,
										ADDR.State,
										ADDR.ZipCode,
										ADDR.PhoneNumber,
										ADDR.URL,
										CONVERT(CHAR(10),E.StartDate,101) AS StartDate,
										CONVERT(CHAR(5),E.StartDate,108) AS StartTime,
										CONVERT(CHAR(10),E.EndDate,101) AS EndDate,
										CONVERT(CHAR(5),E.EndDate,108) AS EndTime,
										CONVERT(CHAR(10),E.DateCreated,101) AS DateCreated,
										E.UserID,
										A.Username,
										E.CategoryID,
										EC.Title AS Category,
										ST.Status,
										E.SchoolID,
										SCH.Title AS School
						
						FROM			AMP_Events E
						JOIN			AMP_Address ADDR ON E.AddressID = ADDR.ID		
						JOIN			AMP_Accounts A ON E.UserID = A.ID						
						JOIN			AMP_EventCategories EC ON E.CategoryID = EC.ID
						JOIN			AMP_Status ST ON E.Status = ST.ID
						LEFT JOIN		AMP_Schools SCH ON E.SchoolID = SCH.ID
						
						WHERE			1=1
					<cfif Len(Arguments.Title)>
						AND				E.Title LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.Title#%" />		
					</cfif>
					<cfif IsNumeric(Arguments.School)>
						AND				E.SchoolID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.School#" />		
					</cfif>
					<cfif IsNumeric(Arguments.Category)>
						AND				E.CategoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Category#" />		
					</cfif>
					<cfif IsNumeric(Arguments.User)>
						AND				E.UserID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.User#" />		
					</cfif>
					<cfif Len(Arguments.Organizer)>
						AND				E.Organizer LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.Organizer#%" />		
					</cfif>
					<cfif Len(Arguments.City)>
						AND				ADDR.City LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.City#%" />		
					</cfif>
					<cfif Len(Arguments.State)>
						AND				ADDR.State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.State#" />		
					</cfif>
					<cfif IsDate(Arguments.StartDate)>
						AND				E.StartDate = <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.StartDate#" />		
					</cfif>
					<cfif IsDate(Arguments.EndDate)>
						AND				E.EndDate = <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.EndDate#" />		
					</cfif>
					<cfif IsBoolean(Arguments.Status)>
						AND				E.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />		
					</cfif>
					
					<cfif LEN( loc_SearchTerm )>
						AND			(
										E.Title LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#loc_SearchTerm#" />		
										OR
										E.Description LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#loc_SearchTerm#" />
									)
					</cfif>
					
					<cfif Request.IsFrontEnd>
						AND				E.Status = 1
						AND				A.Status = 1
					</cfif>
		
			) AS RowConstrainedResult

			WHERE		RowNum >= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.StartRow#" />
			AND			RowNum <= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.EndRow#" />
			
			ORDER BY 	RowNum			
		</cfquery>
		
		<cfreturn loc_Events />
	</cffunction>
	
	<cffunction name="GetEventDetails" access="public" output="false" returntype="query">    
		<cfargument name="EventID" default="0" />
		<cfargument name="User" default="" />
        
		<cfset var loc_Event = "" />
        
		<cfquery datasource="#request.dsource#" name="loc_Event">
			SELECT		E.ID,
						E.Title,
						E.Description,
						E.Organizer,
						CONVERT(CHAR(10),E.StartDate,101) AS StartDate,
						CONVERT(CHAR(5),E.StartDate,108) AS StartTime,
						CONVERT(CHAR(10),E.EndDate,101) AS EndDate,
						CONVERT(CHAR(5),E.EndDate,108) AS EndTime,
						CONVERT(CHAR(10),E.DateCreated,101) AS DateCreated,
						E.EndDate,
						E.SchoolID,
						SCH.Title AS School,
						E.CategoryID,
						E.Status,
						E.UserID,
						A.Username,
						A.Email,
						EC.Title AS Category,
						E.AddressID,
						ADDR.Title AS AddressTitle,
						ADDR.Street1,
						ADDR.Street2,
						ADDR.City,
						ADDR.State,
						ADDR.ZipCode,
						ADDR.PhoneNumber,
						ADDR.URL
			
			FROM		AMP_Events E
			JOIN		AMP_Address ADDR ON E.AddressID = ADDR.ID
			JOIN		AMP_Accounts A ON E.UserID = A.ID						
			JOIN		AMP_EventCategories EC ON E.CategoryID = EC.ID
			LEFT JOIN	AMP_Schools SCH ON E.SchoolID = SCH.ID
			
			WHERE		E.ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.EventID#" />
			<cfif Request.IsFrontEnd>
				AND		E.Status = 1	
				AND		A.Status = 1
				<cfif IsNumeric(Arguments.User)>
					AND		E.UserID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.User#" />
				</cfif>
			</cfif>			
		</cfquery>		
		
		<cfreturn loc_Event />
	</cffunction> 
	
	<cffunction name="UpdateEvent" access="public" output="true" returntype="void">    
		<cfargument name="EventID" default="0" />
		<cfargument name="User" type="numeric" required="yes" />
		<cfargument name="School" type="numeric" required="yes" />
		<cfargument name="Category" type="numeric" required="yes" />
		<cfargument name="Title" type="string" default="" />
		<cfargument name="Description" type="string" default="" />
		<cfargument name="Organizer" type="string" default="" />
		<cfargument name="Status" default="1" />
		<cfargument name="Image" default="" />
		<cfargument name="AddressTitle" type="string" default="" />
		<cfargument name="Street1" type="string" default="" />
		<cfargument name="Street2" type="string" default="" />
		<cfargument name="City" type="string" default="" />
		<cfargument name="State" type="string" default="" />
		<cfargument name="ZipCode" type="string" default="" />
		<cfargument name="PhoneNumber" type="string" default="" />
		<cfargument name="Url" type="string" default="" />
		
		<cfset var loc_UpdateEvent = "" />
		<cfset var loc_EventID = Arguments.EventID />
		<cfset var loc_ItemUploadPath = "" />
		<cfset var loc_Admin = Request.ListenerManager.GetListener( "AdminManager" ) />
		<cfset var loc_StartDateTime = loc_Admin.GetDateTimeString( FormStruct:Arguments, DateFieldName:"StartDate", TimeFieldName:"StartTime" ) />
		<cfset var loc_EndDateTime = loc_Admin.GetDateTimeString( FormStruct:Arguments, DateFieldName:"EndDate", TimeFieldName:"EndTime" ) />
		<cfset var loc_ItemKey = "event" />
		<cfset var loc_StatusMessage = "" />
		<cfset var loc_ReturnUrl = "" />
		
	   	<cfquery datasource="#request.dsource#" name="loc_UpdateEvent">
			DECLARE @AddressID AS Int;

			SET @AddressID = (
				SELECT	AddressID
				FROM	AMP_Events
				WHERE	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_EventID#" />
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
					
					INSERT INTO AMP_Events (
						SchoolID,
						CategoryID,
						UserID,
						AddressID,
						Title,
						Description,
						Organizer,
						StartDate,
						EndDate,
						Status,
						DateCreated
					 )
					 VALUES (
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.School#" />,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Category#" />,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.User#" />,
						@AddressID,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Title#" maxlength="50" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Description#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Organizer#" maxlength="50" />,
						<cfqueryparam cfsqltype="cf_sql_datetime" value="#loc_StartDateTime#" null="#NOT(LEN(loc_StartDateTime))#" />,
						<cfqueryparam cfsqltype="cf_sql_datetime" value="#loc_EndDateTime#" null="#NOT(LEN(loc_EndDateTime))#" />,
						<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />,
						GetDate()
					 )
						 
					SELECT	@@IDENTITY AS NewID,
							'Event.Added' AS StatusMessage;
					SET NOCOUNT OFF;
				END
			ELSE
				BEGIN
				
					UPDATE	AMP_Address
			
					SET		Title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.AddressTitle#" maxlength="50" />,
							Street1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Street1#" maxlength="50" />,
							Street2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Street2#" maxlength="50" />,
							City = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.City#" maxlength="50" />,
							State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.State#" maxlength="2" />,
							ZIPCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ZipCode#" maxlength="10" />,
							PhoneNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.PhoneNumber#" maxlength="20" />,
							URL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Url#" maxlength="200" />,
							DateModified = GETDATE()
			
					WHERE	ID = @AddressID;
				
					UPDATE	AMP_Events
			
					SET		SchoolID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.School#" />,
							CategoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Category#" />,
							AddressID = @AddressID,
							Title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Title#" maxlength="50" />,
							Description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Description#" />,
							Organizer = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Organizer#" maxlength="50" />,
							StartDate = <cfqueryparam cfsqltype="cf_sql_datetime" value="#loc_StartDateTime#" null="#NOT(LEN(loc_StartDateTime))#" />,
							EndDate = <cfqueryparam cfsqltype="cf_sql_datetime" value="#loc_EndDateTime#" null="#NOT(LEN(loc_EndDateTime))#" />,
							<cfif NOT Request.IsFrontEnd>
								Status = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />,
								UserID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.User#" />,
							</cfif>
							DateModified = GETDATE()					
			
					WHERE	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_EventID#" />;
			
					SELECT	#loc_EventID# AS NewID,
							'Event.Updated' AS StatusMessage;
				END
		</cfquery>
		
		<cfset loc_EventID = loc_UpdateEvent.NewID />
		<cfset loc_StatusMessage = loc_UpdateEvent.StatusMessage />
		
		<!--- item image was uploaded --->
		<cfif len(Arguments.Image)>
		
			<cfset loc_ItemUploadPath = Request.Root[loc_ItemKey].Original & loc_EventID & ".jpg" />
			
			<!--- upload user file (as-is) --->
			<cffile action="upload" filefield="Image" destination="#loc_ItemUploadPath#" nameconflict="overwrite" />
			
			<!--- admin initiated above --->
			<cfset loc_Admin.CreateImageVariations( ItemKey:loc_ItemKey, ItemID:loc_EventID ) />
		
		</cfif>
		
		<cfif Request.IsFrontEnd>
			<cfset loc_ReturnUrl = "/event-" & ListLast( loc_StatusMessage, "." ) & "-" & loc_EventID & ".html" />
		<cfelse>
			<cfset loc_ReturnUrl = Arguments.ReturnUrl & "&EventID=" & loc_EventID & "&Message=" & loc_StatusMessage />
		</cfif>
		
		<cflocation url="#loc_ReturnUrl#" addtoken="no" />	
		
	</cffunction> 
	
	<cffunction name="DeleteEvent" access="public" output="false" returntype="void">    
		<cfargument name="EventID" type="numeric" required="yes" />
		
		<cfset var loc_DeleteEvent = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_DeleteEvent">
			DECLARE @AddressID AS Int;

			SET @AddressID = (
				SELECT	AddressID
				FROM	AMP_Events
				WHERE	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.EventID#" />
			);
			
			DELETE
			FROM		AMP_Events
			WHERE		ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.EventID#" />;
			
			IF @AddressID IS NOT NULL
			
				DELETE
				FROM		AMP_Address
				WHERE		ID = @AddressID;
		</cfquery>
		
	</cffunction>
	
	<cffunction name="SendContactRequest" access="public" output="false" returntype="void">    
		<cfargument name="EventID" type="numeric" required="yes" />
		<cfargument name="FirstName" type="string" required="yes" />
		<cfargument name="LastName" type="string" required="yes" />
		<cfargument name="Email" type="string" required="yes" />
		<cfargument name="PhoneNumber" type="string" required="yes" />
		<cfargument name="Comments" type="string" required="yes" />
		
		<cfset var loc_EventDetails = GetEventDetails( EventID:Arguments.EventID ) />
		<cfset var loc_ReturnUrl = "" />
		
		<cfmail		to="#loc_EventDetails.Email#"
					from="#Request.Sender_Email#"
					subject="Event Inquiry from #Request.SiteLabel#">You have recieved an inquiry on your Event.
					
Event: #loc_EventDetails.Title#

Name: #Arguments.FirstName# #Arguments.LastName#

Email: #Arguments.Email#

Phone Number: #Arguments.PhoneNumber#

Comments: #Arguments.Comments#</cfmail>	

		<cfset loc_ReturnUrl = "/event-#Arguments.EventID#/contact-sent.html" />

		<cflocation url="#loc_ReturnUrl#" addtoken="no" />	
		
	</cffunction>
	
</cfcomponent>