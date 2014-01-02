<cfcomponent extends="MachII.framework.Listener">

	<cfscript>		
		this.SortOptions = ArrayNew(1);
		
		this.SortOptions[1] = ["title","Title","MC.Title"];		
		this.SortOptions[2] = ["datecreated","Date Created","MC.DateCreated"];
		this.SortOptions[3] = ["status","Status","ST.Status"];
	</cfscript>
	
	<cffunction name="GetSortOptions" access="public" output="false" returntype="array"> 
		<cfreturn this.SortOptions />
	</cffunction>
	
	<cffunction name="GetDisplayCategories" access="public" output="false" returntype="query" hint="FRONT END">
		<cfset var loc_DisplayCategories = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_DisplayCategories">
			SELECT			MC.ID,
							MC.Title

			FROM			AMP_MarketplaceCategories MC
			WHERE			MC.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
			
			ORDER BY 		Title
		</cfquery>		
		
		<cfreturn loc_DisplayCategories />
	</cffunction> 
	
	<cffunction name="GetMarketplaceCategories" access="public" output="false" returntype="query">    
        <cfargument name="StartRow" type="numeric" default="1" />
		<cfargument name="EndRow" type="numeric" default="#Request.RecordsPerPage#" /> 
		<cfargument name="Title" type="string" default="" />
		<cfargument name="DateCreated" type="string" default="" />
		<cfargument name="Status" type="string" default="" />
		<cfargument name="sidx" type="string" required="no" default="#this.SortOptions[1][3]#" />
		<cfargument name="sord" type="string" required="no" default="asc" />
		
		<cfset var loc_MarketplaceCategories = "" />
        
		<cfquery datasource="#request.dsource#" name="loc_MarketplaceCategories">
			SELECT		*
			FROM  (
					  
						SELECT			ROW_NUMBER() OVER ( ORDER BY #Arguments.sidx# ) AS RowNum,
										COUNT(*) OVER () as Row_Total,
										MC.ID,
										MC.Title,
										CONVERT(CHAR(10),MC.DateCreated,101) AS DateCreated,
										ST.Status
			
						FROM			AMP_MarketplaceCategories MC
						JOIN			AMP_Status ST ON MC.Status = ST.ID
					<cfif Len(Arguments.Title)>
						AND				MC.Title LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.Title#%" />		
					</cfif>
					<cfif IsDate(Arguments.DateCreated)>
						AND				MC.DateCreated = <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.DateCreated#" />		
					</cfif>
					<cfif IsBoolean(Arguments.Status)>
						AND				MC.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />		
					</cfif>
			
			) AS RowConstrainedResult

			WHERE		RowNum >= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.StartRow#" />
			AND			RowNum <= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.EndRow#" />
			
			ORDER BY 	RowNum		
		</cfquery>		
		
		<cfreturn loc_MarketplaceCategories />
	</cffunction> 
	
	<cffunction name="GetMarketplaceCategoryDetails" access="public" output="false" returntype="query">    
		<cfargument name="MarketplaceCategoryID" default="0" />
        
		<cfset var loc_MarketplaceCategory = "" />
        
		<cfquery datasource="#request.dsource#" name="loc_MarketplaceCategory">
			SELECT		ID,
						Title,
						Description,
						CONVERT(CHAR(10),DateCreated,101) AS DateCreated,
						Status
			
			FROM		AMP_MarketplaceCategories
			
			WHERE		ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MarketplaceCategoryID#" />
		</cfquery>		
		
		<cfreturn loc_MarketplaceCategory />
	</cffunction> 
	
	<cffunction name="UpdateMarketplaceCategory" access="public" output="true" returntype="void">    
		<cfargument name="MarketplaceCategoryID" type="numeric" required="yes" />	
		<cfargument name="Title" type="string" default="" />
		<cfargument name="Description" type="string" default="" />
		<cfargument name="Status" default="1" />
		
		<cfset var loc_UpdateMarketplaceCategory = "" />
		<cfset var loc_MarketplaceCategoryID = Arguments.MarketplaceCategoryID />
		<cfset var loc_StatusMessage = "" />
		<cfset var loc_ReturnUrl = "" />
		
	   	<cfquery datasource="#request.dsource#" name="loc_UpdateMarketplaceCategory">
			DECLARE @MarketplaceCategoryID AS Int;

			SET @MarketplaceCategoryID = (
				SELECT	ID
				FROM	AMP_MarketplaceCategories
				WHERE	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_MarketplaceCategoryID#" />
			);
			
			IF @MarketplaceCategoryID IS NULL
			
				BEGIN
				
					SET NOCOUNT ON;
			
					INSERT INTO AMP_MarketplaceCategories (
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
							'MarketplaceCategory.Added' AS StatusMessage;
					SET NOCOUNT OFF;
				END
			ELSE
				BEGIN
								
					UPDATE	AMP_MarketplaceCategories
			
					SET		Title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Title#" maxlength="50" />,
							Description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Description#" />,
							Status = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />,
							DateModified = GETDATE()					
			
					WHERE	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_MarketplaceCategoryID#" />;
			
					SELECT	#loc_MarketplaceCategoryID# AS NewID,
							'MarketplaceCategory.Updated' AS StatusMessage;
				END
		</cfquery>
		
		<cfset loc_MarketplaceCategoryID = loc_UpdateMarketplaceCategory.NewID />
		<cfset loc_StatusMessage = loc_UpdateMarketplaceCategory.StatusMessage />
		
		<cfset loc_ReturnUrl = Arguments.ReturnUrl />
		<cfif Arguments.IsBackEnd>
			<cfset loc_ReturnUrl = loc_ReturnUrl & "&MarketplaceCategoryID=" & loc_MarketplaceCategoryID & "&Message=" & loc_StatusMessage />
		</cfif>
		
		<cflocation url="#loc_ReturnUrl#" addtoken="no" />	
		
	</cffunction> 
	
	<cffunction name="DeleteMarketplaceCategory" access="public" output="false" returntype="void">    
		<cfargument name="MarketplaceCategoryID" type="numeric" required="yes" />
		
		<cfset var loc_DeleteMarketplaceCategory = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_DeleteMarketplaceCategory">
			DELETE
			FROM		AMP_MarketplaceCategories
			WHERE		ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MarketplaceCategoryID#" />
		</cfquery>
		
	</cffunction>
	
</cfcomponent>