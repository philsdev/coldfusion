<cfcomponent extends="MachII.framework.Listener">

	<cfscript>		
		this.SortOptions = ArrayNew(1);
		
		this.SortOptions[1] = ["title","Title","DC.Title"];		
		this.SortOptions[2] = ["datecreated","Date Created","DC.DateCreated"];
		this.SortOptions[3] = ["status","Status","ST.Status"];
	</cfscript>
	
	<cffunction name="GetSortOptions" access="public" output="false" returntype="array"> 
		<cfreturn this.SortOptions />
	</cffunction>
	
	<cffunction name="GetDisplayCategories" access="public" output="false" returntype="query" hint="FRONT END">
		<cfset var loc_DisplayCategories = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_DisplayCategories">
			SELECT			DC.ID,
							DC.Title

			FROM			AMP_DealCategories DC
			WHERE			DC.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
			
			ORDER BY 		Title
		</cfquery>		
		
		<cfreturn loc_DisplayCategories />
	</cffunction> 
	
	<cffunction name="GetDealCategories" access="public" output="false" returntype="query">    
        <cfargument name="StartRow" type="numeric" default="1" />
		<cfargument name="EndRow" type="numeric" default="#Request.RecordsPerPage#" /> 
		<cfargument name="Title" type="string" default="" />
		<cfargument name="DateCreated" type="string" default="" />
		<cfargument name="Status" type="string" default="" />
		<cfargument name="sidx" type="string" required="no" default="#this.SortOptions[1][3]#" />
		<cfargument name="sord" type="string" required="no" default="asc" />
		
		<cfset var loc_DealCategories = "" />
        
		<cfquery datasource="#request.dsource#" name="loc_DealCategories">
			SELECT		*
			FROM  (
					  
						SELECT			ROW_NUMBER() OVER ( ORDER BY #Arguments.sidx# ) AS RowNum,
										COUNT(*) OVER () as Row_Total,
										DC.ID,
										DC.Title,
										CONVERT(CHAR(10),DC.DateCreated,101) AS DateCreated,
										ST.Status
			
						FROM			AMP_DealCategories DC
						JOIN			AMP_Status ST ON DC.Status = ST.ID
					<cfif Len(Arguments.Title)>
						AND				DC.Title LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.Title#%" />		
					</cfif>
					<cfif IsDate(Arguments.DateCreated)>
						AND				DC.DateCreated = <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.DateCreated#" />		
					</cfif>
					<cfif IsBoolean(Arguments.Status)>
						AND				DC.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />		
					</cfif>
			
			) AS RowConstrainedResult

			WHERE		RowNum >= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.StartRow#" />
			AND			RowNum <= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.EndRow#" />
			
			ORDER BY 	RowNum		
		</cfquery>		
		
		<cfreturn loc_DealCategories />
	</cffunction> 
	
	<cffunction name="GetDealCategoryDetails" access="public" output="false" returntype="query">    
		<cfargument name="DealCategoryID" default="0" />
        
		<cfset var loc_DealCategory = "" />
        
		<cfquery datasource="#request.dsource#" name="loc_DealCategory">
			SELECT		ID,
						Title,
						Description,
						CONVERT(CHAR(10),DateCreated,101) AS DateCreated,
						Status
			
			FROM		AMP_DealCategories
			
			WHERE		ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.DealCategoryID#" />
		</cfquery>		
		
		<cfreturn loc_DealCategory />
	</cffunction> 
	
	<cffunction name="UpdateDealCategory" access="public" output="true" returntype="void">    
		<cfargument name="DealCategoryID" type="numeric" required="yes" />	
		<cfargument name="Title" type="string" default="" />
		<cfargument name="Description" type="string" default="" />
		<cfargument name="Status" default="1" />
		
		<cfset var loc_UpdateDealCategory = "" />
		<cfset var loc_DealCategoryID = Arguments.DealCategoryID />
		<cfset var loc_StatusMessage = "" />
		<cfset var loc_ReturnUrl = "" />
		
	   	<cfquery datasource="#request.dsource#" name="loc_UpdateDealCategory">
			DECLARE @DealCategoryID AS Int;

			SET @DealCategoryID = (
				SELECT	ID
				FROM	AMP_DealCategories
				WHERE	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_DealCategoryID#" />
			);
			
			IF @DealCategoryID IS NULL
			
				BEGIN
				
					SET NOCOUNT ON;
			
					INSERT INTO AMP_DealCategories (
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
							'DealCategory.Added' AS StatusMessage;
					SET NOCOUNT OFF;
				END
			ELSE
				BEGIN
								
					UPDATE	AMP_DealCategories
			
					SET		Title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Title#" maxlength="50" />,
							Description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Description#" />,
							Status = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />,
							DateModified = GETDATE()					
			
					WHERE	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_DealCategoryID#" />;
			
					SELECT	#loc_DealCategoryID# AS NewID,
							'DealCategory.Updated' AS StatusMessage;
				END
		</cfquery>
		
		<cfset loc_DealCategoryID = loc_UpdateDealCategory.NewID />
		<cfset loc_StatusMessage = loc_UpdateDealCategory.StatusMessage />
		
		<cfset loc_ReturnUrl = Arguments.ReturnUrl />
		<cfif Arguments.IsBackEnd>
			<cfset loc_ReturnUrl = loc_ReturnUrl & "&DealCategoryID=" & loc_DealCategoryID & "&Message=" & loc_StatusMessage />
		</cfif>
		
		<cflocation url="#loc_ReturnUrl#" addtoken="no" />	
		
	</cffunction> 
	
	<cffunction name="DeleteDealCategory" access="public" output="false" returntype="void">    
		<cfargument name="DealCategoryID" type="numeric" required="yes" />
		
		<cfset var loc_DeleteDealCategory = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_DeleteDealCategory">
			DELETE
			FROM		AMP_DealCategories
			WHERE		ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.DealCategoryID#" />
		</cfquery>
		
	</cffunction>
	
</cfcomponent>