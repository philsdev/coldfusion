<cfcomponent extends="MachII.framework.Listener">

	<cfscript>
		this.SortOptions = ArrayNew(1);
		
		this.SortOptions[1] = ["title","Title","J.Title"];
		this.SortOptions[2] = ["category","Category","JC.Title"];
		this.SortOptions[3] = ["companyname","Company Name","J.CompanyName"];
		this.SortOptions[4] = ["contactname","Contact Name","J.ContactName"];
		this.SortOptions[5] = ["replyemail","Reply E-mail","J.ReplyEmail"];
		this.SortOptions[6] = ["datecreated","Date Created","J.DateCreated"];
		this.SortOptions[7] = ["status","Status","ST.Status"];
		
		this.DefaultSearchText = "Search Jobs";
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
	
	<!--- ///////////////////////////////////////////////////////// --->
	<!--- /////////////////   ADMIN ONLY EVENTS   ///////////////// --->
	<!--- ///////////////////////////////////////////////////////// --->
	
	<cffunction name="GetJobCategories" access="public" output="false" returntype="query">    
        
		<cfset var loc_JobCategories = "" />
        
		<cfquery datasource="#request.dsource#" name="loc_JobCategories">
			SELECT		ID,
						Title
			
			FROM		AMP_JobCategories
			
			ORDER BY	Title
		</cfquery>		
		
		<cfreturn loc_JobCategories />
	</cffunction> 
		
	<cffunction name="GetJobs" access="public" output="false" returntype="query">    
		<cfargument name="StartRow" type="numeric" default="1" />
		<cfargument name="EndRow" type="numeric" default="#Request.RecordsPerPage#" /> 
		<cfargument name="Title" type="string" default="" />
		<cfargument name="CompanyName" type="string" default="" />
		<cfargument name="ContactName" type="string" default="" />
		<cfargument name="ReplyEmail" type="string" default="" />
		<cfargument name="Category" type="string" default="" />
		<cfargument name="User" type="string" default="" />
		<cfargument name="SearchTerm" type="string" default="" />
		<cfargument name="Status" type="string" default="" />
		<cfargument name="sidx" type="string" required="no" default="#this.SortOptions[1][3]#" />
		<cfargument name="sord" type="string" required="no" default="desc" />
        
		<cfset var loc_Jobs = "" />
		<cfset var loc_SearchTerm = TRIM( Arguments.SearchTerm ) />
		
		<cfif loc_SearchTerm EQ this.DefaultSearchText>
			<cfset loc_SearchTerm = "" />
		<cfelseif LEN(loc_SearchTerm)>
			<cfset loc_SearchTerm = "%" & Arguments.SearchTerm & "%" />
		</cfif>
        
		<cfquery datasource="#request.dsource#" name="loc_Jobs">
			SELECT		*
			FROM  (
					  
						SELECT			ROW_NUMBER() OVER ( ORDER BY #Arguments.sidx# ) AS RowNum,
										COUNT(*) OVER () as Row_Total,
										J.ID,
										J.Title,
										J.Description,
										J.CompanyName,
										J.ContactName,
										J.ReplyEmail,
										J.AddressID,
										ADDR.Title AS AddressTitle,
										ADDR.Street1,
										ADDR.Street2,
										ADDR.City,
										ADDR.State,
										CONVERT(CHAR(10),J.DateCreated,101) AS DateCreated,
										J.UserID,
										A.Username,
										J.CategoryID,
										JC.Title AS Category,
										ST.Status
			
						FROM			AMP_Jobs J
						JOIN			AMP_Address ADDR ON J.AddressID = ADDR.ID							
						JOIN			AMP_JobCategories JC ON J.CategoryID = JC.ID
						JOIN			AMP_Accounts A ON J.UserID = A.ID		
						JOIN			AMP_Status ST ON J.Status = ST.ID
						
						WHERE			1=1
					<cfif Len(Arguments.Title)>
							AND			J.Title LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.Title#%" />		
					</cfif>
					<cfif Len(Arguments.CompanyName)>
							AND			J.CompanyName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.CompanyName#%" />		
					</cfif>
					<cfif Len(Arguments.ContactName)>
							AND			J.ContactName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.ContactName#%" />		
					</cfif>
					<cfif Len(Arguments.ReplyEmail)>
							AND			J.ReplyEmail LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.ReplyEmail#%" />		
					</cfif>
					<cfif IsNumeric(Arguments.Category)>
						AND				J.CategoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Category#" />		
					</cfif>
					<cfif IsNumeric(Arguments.User)>
						AND				J.UserID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.User#" />		
					</cfif>					
					<cfif IsBoolean(Arguments.Status)>
						AND				J.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />		
					</cfif>
					
					<cfif LEN( loc_SearchTerm )>
						AND			(
										J.Title LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#loc_SearchTerm#" />		
										OR
										J.Description LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#loc_SearchTerm#" />
									)
					</cfif>
					
					<cfif Request.IsFrontEnd>
						AND				J.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
						AND				A.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
					</cfif>
					
			) AS RowConstrainedResult

			WHERE		RowNum >= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.StartRow#" />
			AND			RowNum <= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.EndRow#" />
			
			ORDER BY 	RowNum	
		</cfquery>
		
		<cfreturn loc_Jobs />
	</cffunction>
	
	<cffunction name="GetJobDetails" access="public" output="false" returntype="query">    
		<cfargument name="JobID" default="0" />
        <cfargument name="User" default="" />
		
		<cfset var loc_Job = "" />
        
		<cfquery datasource="#request.dsource#" name="loc_Job">
			SELECT		J.ID,
						J.Title,
						J.Description,
						J.CompanyName,
						J.ContactName,
						J.ReplyEmail,
						J.CategoryID,
						J.Status,
						J.UserID,
						A.Username,
						A.Email,
						JC.Title AS Category,
						CONVERT(CHAR(10),J.DateCreated,101) AS DateCreated,
						J.AddressID,
						ADDR.Title AS AddressTitle,
						ADDR.Street1,
						ADDR.Street2,
						ADDR.City,
						ADDR.State,
						ADDR.ZipCode,
						ADDR.PhoneNumber,
						ADDR.URL
			
			FROM		AMP_Jobs J
			JOIN		AMP_Address ADDR ON J.AddressID = ADDR.ID
			JOIN		AMP_JobCategories JC ON J.CategoryID = JC.ID
			JOIN		AMP_Accounts A ON J.UserID = A.ID		
			
			WHERE		J.ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.JobID#" />
			
			<cfif Request.IsFrontEnd>
				AND		J.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
				AND		A.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
				<cfif IsNumeric(Arguments.User)>
					AND		J.UserID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.User#" />
				</cfif>
			</cfif>
		</cfquery>		
		
		<cfreturn loc_Job />
	</cffunction> 
	
	<cffunction name="UpdateJob" access="public" output="true" returntype="void">    
		<cfargument name="JobID" default="0" />
		<cfargument name="Category" type="numeric" required="yes" />
		<cfargument name="User" default="" />
		<cfargument name="Title" type="string" default="" />
		<cfargument name="Description" type="string" default="" />
		<cfargument name="CompanyName" type="string" default="" />
		<cfargument name="ContactName" type="string" default="" />
		<cfargument name="ReplyEmail" type="string" default="" />		
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
		
		<cfset var loc_UpdateJob = "" />
		<cfset var loc_JobID = Arguments.JobID />
		<cfset var loc_ItemUploadPath = "" />
		<cfset var loc_Admin = Request.ListenerManager.GetListener( "AdminManager" ) />
		<cfset var loc_ItemKey = "job" />
		<cfset var loc_StatusMessage = "" />
		<cfset var loc_ReturnUrl = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_UpdateJob">
			DECLARE @AddressID AS Int;

			SET @AddressID = (
				SELECT	AddressID
				FROM	AMP_Jobs
				WHERE	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_JobID#" />
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
					
					INSERT INTO AMP_Jobs (
						CategoryID,
						UserID,
						AddressID,
						Title,
						Description,
						CompanyName,
						ContactName,
						ReplyEmail,
						Status,
						DateCreated
					 )
					 VALUES (
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Category#" />,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.User#" />,
						@AddressID,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Title#" maxlength="50" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Description#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CompanyName#" maxlength="50" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ContactName#" maxlength="50" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ReplyEmail#" maxlength="100" />,						
						<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />,
						GetDate()
					 )
						 
					SELECT	@@IDENTITY AS NewID,
							'Job.Added' AS StatusMessage;
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
				
					UPDATE	AMP_Jobs
			
					SET		CategoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Category#" />,
							AddressID = @AddressID,
							Title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Title#" maxlength="50" />,
							Description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Description#" />,
							CompanyName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CompanyName#" maxlength="50" />,
							ContactName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ContactName#" maxlength="50" />,
							ReplyEmail = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ReplyEmail#" maxlength="100" />,
							<cfif NOT Request.IsFrontEnd>
								Status = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />,
								UserID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.User#" />,
							</cfif>
							DateModified = GETDATE()					
			
					WHERE	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_JobID#" />;
			
					SELECT	#loc_JobID# AS NewID,
							'Job.Updated' AS StatusMessage;
				END
		</cfquery>
		
		<cfset loc_JobID = loc_UpdateJob.NewID />
		<cfset loc_StatusMessage = loc_UpdateJob.StatusMessage />
		
		<!--- item image was uploaded --->
		<cfif len(Arguments.Image)>
		
			<cfset loc_ItemUploadPath = Request.Root[loc_ItemKey].Original & loc_JobID & ".jpg" />
			
			<!--- upload user file (as-is) --->
			<cffile action="upload" filefield="Image" destination="#loc_ItemUploadPath#" nameconflict="overwrite" />
			
			<cfset loc_Admin.CreateImageVariations( ItemKey:loc_ItemKey, ItemID:loc_JobID ) />
		
		</cfif>
		
		<cfif Request.IsFrontEnd>
			<cfset loc_ReturnUrl = "/job-" & ListLast( loc_StatusMessage, "." ) & "-" & loc_JobID & ".html" />
		<cfelse>
			<cfset loc_ReturnUrl = Arguments.ReturnUrl & "&JobID=" & loc_JobID & "&Message=" & loc_StatusMessage />
		</cfif>
		
		<cflocation url="#loc_ReturnUrl#" addtoken="no" />	
		
	</cffunction> 
	
	<cffunction name="DeleteJob" access="public" output="false" returntype="void">    
		<cfargument name="JobID" type="numeric" required="yes" />
		
		<cfset var loc_DeleteJob = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_DeleteJob">
			DECLARE @AddressID AS Int;

			SET @AddressID = (
				SELECT	AddressID
				FROM	AMP_Jobs
				WHERE	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.JobID#" />
			);
			
			DELETE
			FROM		AMP_Jobs
			WHERE		ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.JobID#" />;
			
			IF @AddressID IS NOT NULL
			
				DELETE
				FROM		AMP_Address
				WHERE		ID = @AddressID;			
		</cfquery>
		
	</cffunction>
	
	<cffunction name="SendContactRequest" access="public" output="false" returntype="void">  
		<cfargument name="JobID" type="numeric" required="yes" />
		<cfargument name="FirstName" type="string" required="yes" />
		<cfargument name="LastName" type="string" required="yes" />
		<cfargument name="Email" type="string" required="yes" />
		<cfargument name="PhoneNumber" type="string" required="yes" />
		<cfargument name="Comments" type="string" required="yes" />
		
		<cfset var loc_JobDetails = GetJobDetails( JobID:Arguments.JobID ) />
		<cfset var loc_ReturnUrl = "" />
		
		<cfmail		to="#loc_JobDetails.ReplyEmail#"
					from="#Request.Admin_Email#"
					subject="Job Application from #Request.SiteLabel#">#loc_JobDetails.ContactName#,
					
The following application was just submitted:
					
First Name: #Arguments.FirstName#

Last Name: #Arguments.LastName#

E-mail: #Arguments.Email#

Phone Number: #Arguments.PhoneNumber#

Comments: #Arguments.Comments#</cfmail>	

		<cfset loc_ReturnUrl = "/job-#Arguments.JobID#/contact-sent.html" />

		<cflocation url="#loc_ReturnUrl#" addtoken="no" />	
		
	</cffunction>
	
</cfcomponent>