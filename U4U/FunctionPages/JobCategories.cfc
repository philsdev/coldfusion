<cfcomponent extends="MachII.framework.Listener">

	<cfscript>		
		this.SortOptions = ArrayNew(1);
		
		this.SortOptions[1] = ["title","Title","JC.Title"];		
		this.SortOptions[2] = ["datecreated","Date Created","JC.DateCreated"];
		this.SortOptions[3] = ["status","Status","ST.Status"];
	</cfscript>
	
	<cffunction name="GetSortOptions" access="public" output="false" returntype="array"> 
		<cfreturn this.SortOptions />
	</cffunction>
	
	<cffunction name="GetDisplayCategories" access="public" output="false" returntype="query" hint="FRONT END">
		<cfset var loc_DisplayCategories = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_DisplayCategories">
			SELECT			JC.ID,
							JC.Title

			FROM			AMP_JobCategories JC
			WHERE			JC.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
			
			ORDER BY 		Title
		</cfquery>		
		
		<cfreturn loc_DisplayCategories />
	</cffunction> 
	
	<cffunction name="GetJobCategories" access="public" output="false" returntype="query">    
        <cfargument name="StartRow" type="numeric" default="1" />
		<cfargument name="EndRow" type="numeric" default="#Request.RecordsPerPage#" /> 
		<cfargument name="Title" type="string" default="" />
		<cfargument name="DateCreated" type="string" default="" />
		<cfargument name="Status" type="string" default="" />
		<cfargument name="sidx" type="string" required="no" default="#this.SortOptions[1][3]#" />
		<cfargument name="sord" type="string" required="no" default="asc" />
		
		<cfset var loc_JobCategories = "" />
        
		<cfquery datasource="#request.dsource#" name="loc_JobCategories">
			SELECT		*
			FROM  (
					  
						SELECT			ROW_NUMBER() OVER ( ORDER BY #Arguments.sidx# ) AS RowNum,
										COUNT(*) OVER () as Row_Total,
										JC.ID,
										JC.Title,
										CONVERT(CHAR(10),JC.DateCreated,101) AS DateCreated,
										ST.Status
			
						FROM			AMP_JobCategories JC
						JOIN			AMP_Status ST ON JC.Status = ST.ID
					<cfif Len(Arguments.Title)>
						AND				JC.Title LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.Title#%" />		
					</cfif>
					<cfif IsDate(Arguments.DateCreated)>
						AND				JC.DateCreated = <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.DateCreated#" />		
					</cfif>
					<cfif IsBoolean(Arguments.Status)>
						AND				JC.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />		
					</cfif>
			
			) AS RowConstrainedResult

			WHERE		RowNum >= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.StartRow#" />
			AND			RowNum <= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.EndRow#" />
			
			ORDER BY 	RowNum		
		</cfquery>		
		
		<cfreturn loc_JobCategories />
	</cffunction> 
	
	<cffunction name="GetJobCategoryDetails" access="public" output="false" returntype="query">    
		<cfargument name="JobCategoryID" default="0" />
        
		<cfset var loc_JobCategory = "" />
        
		<cfquery datasource="#request.dsource#" name="loc_JobCategory">
			SELECT		ID,
						Title,
						Description,
						CONVERT(CHAR(10),DateCreated,101) AS DateCreated,
						Status
			
			FROM		AMP_JobCategories
			
			WHERE		ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.JobCategoryID#" />
		</cfquery>		
		
		<cfreturn loc_JobCategory />
	</cffunction> 
	
	<cffunction name="UpdateJobCategory" access="public" output="true" returntype="void">    
		<cfargument name="IsBackEnd" default="no">
		<cfargument name="JobCategoryID" type="numeric" required="yes" />	
		<cfargument name="Title" type="string" default="" />
		<cfargument name="Description" type="string" default="" />
		<cfargument name="Status" default="1" />
		
		<cfset var loc_UpdateJobCategory = "" />
		<cfset var loc_JobCategoryID = Arguments.JobCategoryID />
		<cfset var loc_StatusMessage = "" />
		<cfset var loc_ReturnUrl = "" />
		
	   	<cfquery datasource="#request.dsource#" name="loc_UpdateJobCategory">
			DECLARE @JobCategoryID AS Int;

			SET @JobCategoryID = (
				SELECT	ID
				FROM	AMP_JobCategories
				WHERE	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_JobCategoryID#" />
			);
			
			IF @JobCategoryID IS NULL
			
				BEGIN
				
					SET NOCOUNT ON;
			
					INSERT INTO AMP_JobCategories (
						Title,
						Description,
						Status,
						DateCreated
					 )
					 VALUES (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Title#" maxlength="50" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Description#" />,
						<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />,
						GetDate()
					 )
						 
					SELECT	@@IDENTITY AS NewID,
							'JobCategory.Added' AS StatusMessage;
					SET NOCOUNT OFF;
				END
			ELSE
				BEGIN
								
					UPDATE	AMP_JobCategories
			
					SET		Title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Title#" maxlength="50" />,
							Description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Description#" />,
							Status = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />,
							DateModified = GETDATE()					
			
					WHERE	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_JobCategoryID#" />;
			
					SELECT	#loc_JobCategoryID# AS NewID,
							'JobCategory.Updated' AS StatusMessage;
				END
		</cfquery>
		
		<cfset loc_JobCategoryID = loc_UpdateJobCategory.NewID />
		<cfset loc_StatusMessage = loc_UpdateJobCategory.StatusMessage />
		
		<cfset loc_ReturnUrl = Arguments.ReturnUrl />
		<cfif Arguments.IsBackEnd>
			<cfset loc_ReturnUrl = loc_ReturnUrl & "&JobCategoryID=" & loc_JobCategoryID & "&Message=" & loc_StatusMessage />
		</cfif>
		
		<cflocation url="#loc_ReturnUrl#" addtoken="no" />	
		
	</cffunction> 
	
	<cffunction name="DeleteJobCategory" access="public" output="false" returntype="void">    
		<cfargument name="JobCategoryID" type="numeric" required="yes" />
		
		<cfset var loc_DeleteJobCategory = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_DeleteJobCategory">
			DELETE
			FROM		AMP_JobCategories
			WHERE		ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.JobCategoryID#" />
		</cfquery>
		
	</cffunction>
	
</cfcomponent>