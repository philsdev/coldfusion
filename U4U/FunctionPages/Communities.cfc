<cfcomponent extends="MachII.framework.Listener">

	<cfscript>
		this.SortOptions = ArrayNew(1);
		
		this.SortOptions[1] = ["title","Title","C.Title"];
		this.SortOptions[2] = ["category","Category","CAT.Title"];
		this.SortOptions[3] = ["user","User","A.LastName"];
		this.SortOptions[4] = ["posts","Posts","ISNULL(CP.Total,0)"];
		this.SortOptions[5] = ["datecreated","Date Created","C.DateCreated"];
		this.SortOptions[6] = ["status","Status","ST.Status"];
		
		this.DefaultSearchText = "Search Marketplace";
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
	
	<cffunction name="GetDisplayCommunities" access="public" output="yes" returntype="query"> 
        
		<cfset var loc_DisplayCommunities = "" />
        
		<cfquery datasource="#request.dsource#" name="loc_DisplayCommunities">
			SELECT		C.ID,
						C.Title
						
			FROM		AMP_Communities C
			
			ORDER BY 	Title
		</cfquery>
		
		<cfreturn loc_DisplayCommunities />
	</cffunction>
		
	<cffunction name="GetCommunities" access="public" output="yes" returntype="query">    
		<cfargument name="StartRow" type="numeric" default="1" />
		<cfargument name="EndRow" type="numeric" default="#Request.RecordsPerPage#" /> 
		<cfargument name="Title" type="string" default="" />
		<cfargument name="DateCreated" type="string" default="" />
		<cfargument name="Category" type="string" default="" />
		<cfargument name="User" type="string" default="" />
		<cfargument name="Status" type="string" default="" />
		<cfargument name="sidx" type="string" required="no" default="#this.SortOptions[1][3]#" />
		<cfargument name="sord" type="string" required="no" default="desc" />
        
		<cfset var loc_Communities = "" />
        
		<cfquery datasource="#request.dsource#" name="loc_Communities">
			SELECT		*
			FROM  (
					  
						SELECT			ROW_NUMBER() OVER ( ORDER BY #Arguments.sidx# ) AS RowNum,
										COUNT(*) OVER () as Row_Total,
										C.ID,
										C.Title,
										CONVERT(CHAR(10),C.DateCreated,101) AS DateCreated,
										C.CategoryID,
										CAT.Title AS Category,
										A.Username,
										ISNULL(CP.Total,0) AS Posts,
										CP2.ID AS RecentPostID,
										CASE
											WHEN LEN(CP2.Description) >= #REQUEST.ShortDescriptionLength# THEN LEFT(CP2.Description,#REQUEST.ShortDescriptionLength#) + '...'
											ELSE CP2.Description
										END AS RecentPostTitle,
										CP2.UserID AS RecentPostUserID,
										A2.Username AS RecentPostUsername,
										ST.Status
						
						FROM			AMP_Communities C						
						JOIN			AMP_Accounts A ON C.UserID = A.ID
						JOIN			AMP_CommunityCategories CAT ON C.CategoryID = CAT.ID
						JOIN			AMP_Status ST ON C.Status = ST.ID
										
						LEFT JOIN		(
											SELECT		P.CommunityID,
														COUNT(P.ID) AS Total,
														MAX(P.ID) AS MaxID
											FROM		AMP_CommunityPosts P
											JOIN		AMP_Communities C ON P.CommunityID = C.ID
											JOIN		AMP_Accounts A ON P.UserID = A.ID
											WHERE		P.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
											AND			C.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
											GROUP BY	P.CommunityID
										) CP ON C.ID = CP.CommunityID
										
						LEFT JOIN		AMP_CommunityPosts CP2 ON CP.MaxID = CP2.ID
						LEFT JOIN		AMP_Accounts A2 ON CP2.UserID = A2.ID
						
						WHERE			1=1
					<cfif Len(Arguments.Title)>
							AND			C.Title LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.Title#%" />		
					</cfif>
					<cfif IsDate(Arguments.DateCreated)>
							AND			C.DateCreated = <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.DateCreated#" />		
					</cfif>
					<cfif IsNumeric(Arguments.Category)>
						AND				C.CategoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Category#" />		
					</cfif>
					<cfif IsNumeric(Arguments.User)>
						AND				(
											C.UserID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.User#" />		
											OR
											C.ID IN (
														SELECT		CommunityID
														FROM		AMP_CommunityPosts
														WHERE		UserID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.User#" />		
														GROUP BY	CommunityID
											)
										)
					</cfif>
					<cfif IsBoolean(Arguments.Status)>
						AND				C.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />		
					</cfif>
					<cfif Request.IsFrontEnd>
						AND				C.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />		
					</cfif>
					
			) AS RowConstrainedResult

			WHERE		RowNum >= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.StartRow#" />
			AND			RowNum <= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.EndRow#" />
			
			ORDER BY 	RowNum	
		</cfquery>
		
		<cfreturn loc_Communities />
	</cffunction>
	
	<cffunction name="GetCommunityDetails" access="public" output="false" returntype="query">    
		<cfargument name="CommunityID" default="0" />
        
		<cfset var loc_Community = "" />
        
		<cfquery datasource="#request.dsource#" name="loc_Community">
			SELECT		C.ID,
						C.Title,
						C.Description,
						C.CategoryID,
						CAT.Title AS Category,
						C.UserID,
						C.Status
			
			FROM		AMP_Communities C
			JOIN		AMP_CommunityCategories CAT ON C.CategoryID = CAT.ID
			
			WHERE		C.ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.CommunityID#" />
			<cfif Request.IsFrontEnd>
						AND				C.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />		
			</cfif>
		</cfquery>		
		
		<cfreturn loc_Community />
	</cffunction> 
	
	<cffunction name="UpdateCommunity" access="public" output="true" returntype="void">    
		<cfargument name="CommunityID" default="0" />
		<cfargument name="User" type="numeric" required="yes" />
		<cfargument name="Category" type="numeric" required="yes" />
		<cfargument name="Title" type="string" default="" />
		<cfargument name="Description" type="string" default="" />
		<cfargument name="Status" default="1" />
		
		<cfset var loc_UpdateCommunity = "" />
		<cfset var loc_CommunityID = Arguments.CommunityID />
		<cfset var loc_LinkManager = "" />
		<cfset var loc_StatusMessage = "" />
		<cfset var loc_ReturnUrl = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_UpdateCommunity">
			DECLARE @CommunityID AS Int;

			SET @CommunityID = (
				SELECT	ID
				FROM	AMP_Communities
				WHERE	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_CommunityID#" />
			);
			
			IF @CommunityID IS NULL
			
				BEGIN
				
					INSERT INTO AMP_Communities (
						UserID,
						CategoryID,
						Title,
						Description,
						Status,
						DateCreated
					 )
					 VALUES (
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.User#" />,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Category#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Title#" maxlength="50" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Description#" />,		
						<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />,
						GETDATE()
					 );
						 
					SELECT	@@IDENTITY AS NewID,
							'Community.Added' AS StatusMessage;
					SET NOCOUNT OFF;
				END
			ELSE
				BEGIN
				
					UPDATE	AMP_Communities
			
					SET		UserID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.User#" />,
							CategoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Category#" />,
							Title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Title#" maxlength="50" />,
							Description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Description#" />,
							Status = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />,
							DateModified = GETDATE()					
			
					WHERE	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_CommunityID#" />;
			
					SELECT	#loc_CommunityID# AS NewID,
							'Community.Updated' AS StatusMessage;
				END
		</cfquery>
		
		<cfset loc_CommunityID = loc_UpdateCommunity.NewID />
		<cfset loc_StatusMessage = loc_UpdateCommunity.StatusMessage />	
		
		<cfif Request.IsFrontEnd>			
			<cfset loc_LinkManager = Request.ListenerManager.GetListener( "LinkManager" ) />
			<cfset loc_ReturnUrl = loc_LinkManager.GetCommunityLink( CommunityID:loc_CommunityID, CommunityTitle:Arguments.Title ) />
		<cfelse>
			<cfset loc_ReturnUrl = Arguments.ReturnUrl & "&CommunityID=" & loc_CommunityID & "&Message=" & loc_StatusMessage />
		</cfif>
		
		<cflocation url="#loc_ReturnUrl#" addtoken="no" />	
		
	</cffunction> 
	
	<cffunction name="DeleteCommunity" access="public" output="false" returntype="void">    
		<cfargument name="CommunityID" type="numeric" required="yes" />
		
		<cfset var loc_DeleteCommunity = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_DeleteItem">
			DELETE
			FROM		AMP_Communities
			WHERE		ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.CommunityID#" />;
			
			DELETE
			FROM		AMP_CommunityPosts
			WHERE		CommunityID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.CommunityID#" />;
		</cfquery>
		
	</cffunction>
	
</cfcomponent>