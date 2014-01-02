<cfcomponent extends="MachII.framework.Listener">

	<cfscript>		
		this.SortOptions = ArrayNew(1);
		
		this.SortOptions[1] = ["title","Title","EC.Title"];		
		this.SortOptions[2] = ["datecreated","Date Created","EC.DateCreated"];
		this.SortOptions[3] = ["status","Status","ST.Status"];
	</cfscript>
	
	<cffunction name="GetSortOptions" access="public" output="false" returntype="array"> 
		<cfreturn this.SortOptions />
	</cffunction>
	
	<cffunction name="GetDisplayCategories" access="public" output="false" returntype="query" hint="FRONT END">
		<cfset var loc_DisplayCategories = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_DisplayCategories">
			SELECT			EC.ID,
							EC.Title

			FROM			AMP_EventCategories EC
			WHERE			EC.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
			
			ORDER BY 		Title
		</cfquery>		
		
		<cfreturn loc_DisplayCategories />
	</cffunction> 
	
	<cffunction name="GetEventCategories" access="public" output="false" returntype="query">    
        <cfargument name="StartRow" type="numeric" default="1" />
		<cfargument name="EndRow" type="numeric" default="#Request.RecordsPerPage#" /> 
		<cfargument name="Title" type="string" default="" />
		<cfargument name="DateCreated" type="string" default="" />
		<cfargument name="Status" type="string" default="" />
		<cfargument name="sidx" type="string" required="no" default="#this.SortOptions[1][3]#" />
		<cfargument name="sord" type="string" required="no" default="asc" />
		
		<cfset var loc_EventCategories = "" />
        
		<cfquery datasource="#request.dsource#" name="loc_EventCategories">
			SELECT		*
			FROM  (
					  
						SELECT			ROW_NUMBER() OVER ( ORDER BY #Arguments.sidx# ) AS RowNum,
										COUNT(*) OVER () as Row_Total,
										EC.ID,
										EC.Title,
										CONVERT(CHAR(10),EC.DateCreated,101) AS DateCreated,
										ST.Status
			
						FROM			AMP_EventCategories EC
						JOIN			AMP_Status ST ON EC.Status = ST.ID
					<cfif Len(Arguments.Title)>
						AND				EC.Title LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.Title#%" />		
					</cfif>
					<cfif IsDate(Arguments.DateCreated)>
						AND				EC.DateCreated = <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.DateCreated#" />		
					</cfif>
					<cfif IsBoolean(Arguments.Status)>
						AND				EC.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />		
					</cfif>
			
			) AS RowConstrainedResult

			WHERE		RowNum >= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.StartRow#" />
			AND			RowNum <= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.EndRow#" />
			
			ORDER BY 	RowNum		
		</cfquery>		
		
		<cfreturn loc_EventCategories />
	</cffunction> 
	
	<cffunction name="GetEventCategoryDetails" access="public" output="false" returntype="query">    
		<cfargument name="EventCategoryID" default="0" />
        
		<cfset var loc_Event = "" />
        
		<cfquery datasource="#request.dsource#" name="loc_Event">
			SELECT		ID,
						Title,
						Description,
						CONVERT(CHAR(10),DateCreated,101) AS DateCreated,
						Status
			
			FROM		AMP_EventCategories
			
			WHERE		ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.EventCategoryID#" />
		</cfquery>		
		
		<cfreturn loc_Event />
	</cffunction> 
	
	<cffunction name="UpdateEventCategory" access="public" output="true" returntype="void">    
		<cfargument name="IsBackEnd" default="no">
		<cfargument name="EventCategoryID" type="numeric" required="yes" />	
		<cfargument name="Title" type="string" default="" />
		<cfargument name="Description" type="string" default="" />
		<cfargument name="Status" default="1" />
		
		<cfset var loc_UpdateEvent = "" />
		<cfset var loc_EventCategoryID = Arguments.EventCategoryID />
		<cfset var loc_StatusMessage = "" />
		<cfset var loc_ReturnUrl = "" />
		
	   	<cfquery datasource="#request.dsource#" name="loc_UpdateEvent">
			DECLARE @EventCategoryID AS Int;

			SET @EventCategoryID = (
				SELECT	ID
				FROM	AMP_EventCategories
				WHERE	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_EventCategoryID#" />
			);
			
			IF @EventCategoryID IS NULL
			
				BEGIN
				
					SET NOCOUNT ON;
			
					INSERT INTO AMP_EventCategories (
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
							'EventCategory.Added' AS StatusMessage;
					SET NOCOUNT OFF;
				END
			ELSE
				BEGIN
								
					UPDATE	AMP_EventCategories
			
					SET		Title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Title#" maxlength="50" />,
							Description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Description#" />,
							Status = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />,
							DateModified = GETDATE()					
			
					WHERE	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_EventCategoryID#" />;
			
					SELECT	#loc_EventCategoryID# AS NewID,
							'EventCategory.Updated' AS StatusMessage;
				END
		</cfquery>
		
		<cfset loc_EventID = loc_UpdateEvent.NewID />
		<cfset loc_StatusMessage = loc_UpdateEvent.StatusMessage />
		
		<cfset loc_ReturnUrl = Arguments.ReturnUrl />
		<cfif Arguments.IsBackEnd>
			<cfset loc_ReturnUrl = loc_ReturnUrl & "&EventCategoryID=" & loc_EventCategoryID & "&Message=" & loc_StatusMessage />
		</cfif>
		
		<cflocation url="#loc_ReturnUrl#" addtoken="no" />	
		
	</cffunction> 
	
	<cffunction name="DeleteEventCategory" access="public" output="false" returntype="void">    
		<cfargument name="EventCategoryID" type="numeric" required="yes" />
		
		<cfset var loc_DeleteEventCategory = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_DeleteEvent">
			DELETE
			FROM		AMP_EventCategories
			WHERE		ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.EventCategoryID#" />
		</cfquery>
		
	</cffunction>
	
</cfcomponent>