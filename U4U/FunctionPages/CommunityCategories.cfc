<cfcomponent extends="MachII.framework.Listener">

	<cfscript>		
		this.SortOptions = ArrayNew(1);
		
		this.SortOptions[1] = ["title","Title","CC.Title"];		
		this.SortOptions[2] = ["datecreated","Date Created","CC.DateCreated"];
		this.SortOptions[3] = ["status","Status","ST.Status"];
	</cfscript>
	
	<cffunction name="GetSortOptions" access="public" output="false" returntype="array"> 
		<cfreturn this.SortOptions />
	</cffunction>
	
	<cffunction name="GetDisplayCategories" access="public" output="false" returntype="query" hint="FRONT END">
		<cfset var loc_DisplayCategories = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_DisplayCategories">
			SELECT			CC.ID,
							CC.Title

			FROM			AMP_CommunityCategories CC
			WHERE			CC.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
			
			ORDER BY 		Title
		</cfquery>		
		
		<cfreturn loc_DisplayCategories />
	</cffunction> 
	
	<cffunction name="GetCommunityCategories" access="public" output="false" returntype="query">    
        <cfargument name="StartRow" type="numeric" default="1" />
		<cfargument name="EndRow" type="numeric" default="#Request.RecordsPerPage#" /> 
		<cfargument name="Title" type="string" default="" />
		<cfargument name="DateCreated" type="string" default="" />
		<cfargument name="Status" type="string" default="" />
		<cfargument name="sidx" type="string" required="no" default="#this.SortOptions[1][3]#" />
		<cfargument name="sord" type="string" required="no" default="asc" />
		
		<cfset var loc_CommunityCategories = "" />
        
		<cfquery datasource="#request.dsource#" name="loc_CommunityCategories">
			SELECT		*
			FROM  (
					  
						SELECT			ROW_NUMBER() OVER ( ORDER BY #Arguments.sidx# ) AS RowNum,
										COUNT(*) OVER () as Row_Total,
										CC.ID,
										CC.Title,
										CONVERT(CHAR(10),CC.DateCreated,101) AS DateCreated,
										ST.Status
			
						FROM			AMP_CommunityCategories CC
						JOIN			AMP_Status ST ON CC.Status = ST.ID
					<cfif Len(Arguments.Title)>
							AND			CC.Title LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.Title#%" />		
					</cfif>
					<cfif IsDate(Arguments.DateCreated)>
							AND			CC.DateCreated = <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.DateCreated#" />		
					</cfif>
					<cfif IsBoolean(Arguments.Status)>
						AND				CC.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />		
					</cfif>
			
			) AS RowConstrainedResult

			WHERE		RowNum >= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.StartRow#" />
			AND			RowNum <= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.EndRow#" />
			
			ORDER BY 	RowNum		
		</cfquery>		
		
		<cfreturn loc_CommunityCategories />
	</cffunction> 
	
	<cffunction name="GetCommunityCategoryDetails" access="public" output="false" returntype="query">    
		<cfargument name="CommunityCategoryID" default="0" />
        
		<cfset var loc_CommunityCategory = "" />
        
		<cfquery datasource="#request.dsource#" name="loc_CommunityCategory">
			SELECT		ID,
						Title,
						Description,
						CONVERT(CHAR(10),DateCreated,101) AS DateCreated,
						Status
			
			FROM		AMP_CommunityCategories
			
			WHERE		ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.CommunityCategoryID#" />
		</cfquery>		
		
		<cfreturn loc_CommunityCategory />
	</cffunction> 
	
	<cffunction name="UpdateCommunityCategory" access="public" output="true" returntype="void">    
		<cfargument name="IsBackEnd" default="no">
		<cfargument name="CommunityCategoryID" type="numeric" required="yes" />	
		<cfargument name="Title" type="string" default="" />
		<cfargument name="Description" type="string" default="" />
		<cfargument name="Status" default="1" />
		
		<cfset var loc_UpdateCommunityCategory = "" />
		<cfset var loc_CommunityCategoryID = Arguments.CommunityCategoryID />
		<cfset var loc_StatusMessage = "" />
		<cfset var loc_ReturnUrl = "" />
		
	   	<cfquery datasource="#request.dsource#" name="loc_UpdateCommunityCategory">
			DECLARE @CommunityCategoryID AS Int;

			SET @CommunityCategoryID = (
				SELECT	ID
				FROM	AMP_CommunityCategories
				WHERE	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_CommunityCategoryID#" />
			);
			
			IF @CommunityCategoryID IS NULL
			
				BEGIN
				
					SET NOCOUNT ON;
			
					INSERT INTO AMP_CommunityCategories (
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
							'CommunityCategory.Added' AS StatusMessage;
					SET NOCOUNT OFF;
				END
			ELSE
				BEGIN
								
					UPDATE	AMP_CommunityCategories
			
					SET		Title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Title#" maxlength="50" />,
							Description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Description#" />,
							Status = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />,
							DateModified = GETDATE()					
			
					WHERE	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_CommunityCategoryID#" />;
			
					SELECT	#loc_CommunityCategoryID# AS NewID,
							'CommunityCategory.Updated' AS StatusMessage;
				END
		</cfquery>
		
		<cfset loc_CommunityCategoryID = loc_UpdateCommunityCategory.NewID />
		<cfset loc_StatusMessage = loc_UpdateCommunityCategory.StatusMessage />
		
		<cfset loc_ReturnUrl = Arguments.ReturnUrl />
		<cfif Arguments.IsBackEnd>
			<cfset loc_ReturnUrl = loc_ReturnUrl & "&CommunityCategoryID=" & loc_CommunityCategoryID & "&Message=" & loc_StatusMessage />
		</cfif>
		
		<cflocation url="#loc_ReturnUrl#" addtoken="no" />	
		
	</cffunction> 
	
	<cffunction name="DeleteCommunityCategory" access="public" output="false" returntype="void">    
		<cfargument name="CommunityCategoryID" type="numeric" required="yes" />
		
		<cfset var loc_DeleteCommunityCategory = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_DeleteCommunityCategory">
			DELETE
			FROM		AMP_CommunityCategories
			WHERE		ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.CommunityCategoryID#" />
		</cfquery>
		
	</cffunction>
	
</cfcomponent>