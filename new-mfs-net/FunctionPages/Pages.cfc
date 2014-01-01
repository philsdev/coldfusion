<cfcomponent extends="MachII.framework.Listener">

	<cfscript>
		this.SortOptions = ArrayNew(1);
		
		this.SortOptions[1] = ["pagetitle","Page Title","P.PageTitle"];
		this.SortOptions[2] = ["searchtitle","Search Title","P.SearchTitle"];
		this.SortOptions[3] = ["datecreated","Date Created","P.DateCreated"];
		this.SortOptions[4] = ["status","Status","ST.Status"];
		
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
	
	<cffunction name="GetPages" access="public" output="false" returntype="query">    
		<cfargument name="StartRow" type="numeric" default="1" />
		<cfargument name="EndRow" type="numeric" default="#Request.RecordsPerPage#" /> 
		<cfargument name="PageTitle" type="string" default="" />
		<cfargument name="SearchTitle" type="string" default="" />
		<cfargument name="Status" type="string" default="" />
		<cfargument name="sidx" type="string" required="no" default="#this.SortOptions[1][3]#" />
		<cfargument name="sord" type="string" required="no" default="#this.DefaultSord#" />
        
		<cfset var loc_Pages = "" />
        
		<cfquery datasource="#request.dsource#" name="loc_Pages">
			SELECT		*
			FROM  (
					  
						SELECT			ROW_NUMBER() OVER ( ORDER BY #Arguments.sidx# #Arguments.sord# ) AS RowNum,
										COUNT(*) OVER () as Row_Total,
										P.ID,
										P.PageTitle,
										P.SearchTitle,
										CONVERT(CHAR(10),P.DateCreated,101) AS DateCreated,
										ST.Status
						
						FROM			Pages P
						JOIN			Status ST ON P.Status = ST.ID
						
						WHERE			1=1
					<cfif Len(Arguments.PageTitle)>
							AND			P.PageTitle LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.PageTitle#%" />		
					</cfif>
					<cfif Len(Arguments.SearchTitle)>
							AND			P.SearchTitle LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.SearchTitle#%" />		
					</cfif>
					<cfif IsBoolean(Arguments.Status)>
						AND				P.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />		
					</cfif>
		
			) AS RowConstrainedResult

			WHERE		RowNum >= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.StartRow#" />
			AND			RowNum <= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.EndRow#" />
			
			ORDER BY 	RowNum		
		</cfquery>
		
		<cfreturn loc_Pages />
	</cffunction>
	
	<cffunction name="GetDisplayPages" returntype="query">
		
		
		<cfset var loc_DisplayPages = "" />
	
		<cfquery datasource="#request.dsource#" name="loc_DisplayPages">
		SELECT			ID,						
						PageTitle,
						SearchTitle,
						PageDescription, 
						Status
            FROM		Pages
            WHERE 		Status = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
		</cfquery>
		
		<cfreturn loc_DisplayPages />		
		
	</cffunction>
	
    <cffunction name="GetPageDetail" access="public" output="false" returntype="query">    	
    	<cfargument name="PageID" default="0" />
        <cfargument name="PageName" default="" />
        
        <cfset var loc_PageName = Arguments.PageName />
		<cfset var loc_PageDetail = "" />
		
		<cfset loc_PageName = ReReplace( loc_PageName, '[^A-Za-z0-9]', '', 'All' ) />
        
        <cfquery datasource="#request.dsource#" name="loc_PageDetail">
        	SELECT		ID,						
						PageTitle,
						SearchTitle,
						PageDescription, 
						PageBody, 
						MetaTitle, 
						MetaDescription,
						Status
            FROM		Pages
            WHERE 		1=1
			AND 		Status = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
		
		<cfif IsNumeric(Arguments.PageID) AND Arguments.PageID GT 0>
			AND			ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PageID#" />
		<cfelseif LEN(Arguments.PageName)>
			AND			SearchTitle = <cfqueryparam cfsqltype="cf_sql_varchar" value="#loc_PageName#" />                 
		</cfif>        
		</cfquery>
    
    	<cfreturn loc_PageDetail />
        
    </cffunction>  
	
	<cffunction name="GetPageDetails" access="public" output="false" returntype="query">    	
    	<cfargument name="PageID" default="0" />
        
		<cfset var loc_PageDetails = "" />
        
        <cfquery datasource="#request.dsource#" name="loc_PageDetails">
        	SELECT		ID,						
						PageTitle,
						SearchTitle,
						PageDescription, 
						PageBody, 
						MetaTitle, 
						MetaDescription,
						Status
            FROM		Pages
            WHERE 		1=1
			AND			ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PageID#" />
		</cfquery>
    
    	<cfreturn loc_PageDetails />        
    </cffunction>  
	
	<cffunction name="UpdatePage" access="public" output="true" returntype="void">    
		<cfargument name="IsBackEnd" default="no">
		<cfargument name="PageID" type="numeric" required="yes" />
		<cfargument name="PageTitle" type="string" default="" />
		<cfargument name="PageDescription" type="string" default="" />
		<cfargument name="PageBody" type="string" default="" />
		<cfargument name="SearchTitle" type="string" default="" />
		<cfargument name="MetaTitle" type="string" default="" />
		<cfargument name="MetaDescription" type="string" default="" />
		<cfargument name="Status" default="1" />
		
		<cfset var loc_UpdatePage = "" />
		<cfset var loc_PageID = Arguments.PageID />
		<cfset var loc_StatusMessage = "" />
		<cfset var loc_ReturnUrl = "" />
		
	   	<cfquery datasource="#request.dsource#" name="loc_UpdatePage">
			DECLARE @PageID AS Int;

			SET @PageID = (
				SELECT	ID
				FROM	Pages
				WHERE	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_PageID#" />
			);
			
			IF @PageID IS NULL
			
				BEGIN
				
					INSERT INTO Pages (
						PageTitle,
						PageDescription,
						PageBody,
						SearchTitle,
						MetaTitle,
						MetaDescription,
						Status,
						DateCreated
					 )
					 VALUES (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.PageTitle#" maxlength="255" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.PageDescription#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.PageBody#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.SearchTitle#" maxlength="255" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.MetaTitle#" maxlength="255" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.MetaDescription#" maxlength="1000" />,
						<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />,
						GETDATE()
					 )
						 
					SELECT	@@IDENTITY AS NewID,
							'Page.Added' AS StatusMessage;
					SET NOCOUNT OFF;
				END
			ELSE
				BEGIN
				
					UPDATE	Pages
			
					SET		PageTitle = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.PageTitle#" maxlength="255" />,
							PageDescription = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.PageDescription#" />,
							PageBody = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.PageBody#" />,
							SearchTitle = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.SearchTitle#" maxlength="255" />,
							MetaTitle = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.MetaTitle#" maxlength="255" />,
							MetaDescription = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.MetaDescription#" maxlength="1000" />,
							Status = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />,
							DateModified = GETDATE()					
			
					WHERE	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_PageID#" />;
			
					SELECT	#loc_PageID# AS NewID,
							'Page.Updated' AS StatusMessage;
				END
		</cfquery>
		
		<cfset loc_PageID = loc_UpdatePage.NewID />
		<cfset loc_StatusMessage = loc_UpdatePage.StatusMessage />
		
		<cfset loc_ReturnUrl = Arguments.ReturnUrl />
		<cfif Arguments.IsBackEnd>
			<cfset loc_ReturnUrl = loc_ReturnUrl & "&PageID=" & loc_PageID & "&Message=" & loc_StatusMessage />
		</cfif>
		
		<cflocation url="#loc_ReturnUrl#" addtoken="no" />	
		
	</cffunction> 
	
	<cffunction name="DeletePage" access="public" output="false" returntype="void">    
		<cfargument name="PageID" type="numeric" required="yes" />
		
		<cfset var loc_DeletePage = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_DeletePage">
			DELETE
			FROM		Pages
			WHERE		ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PageID#" />
		</cfquery>
		
	</cffunction>
	
	<cffunction name="GetPageMetaTitle" access="public" output="false" returntype="string">    
		<cfargument name="MetaTitle" type="string" required="yes" />
		
		<cfreturn Arguments.MetaTitle />		
	</cffunction>
	
	<cffunction name="GetPageMetaDescription" access="public" output="false" returntype="string">    
		<cfargument name="MetaDescription" type="string" required="yes" />
		
		<cfreturn Arguments.MetaDescription />		
	</cffunction>

</cfcomponent>
