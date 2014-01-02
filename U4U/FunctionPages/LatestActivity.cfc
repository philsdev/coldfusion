<cfcomponent extends="MachII.framework.Listener">

	<cfscript>
		this.SectionOptions = ArrayNew(1);
		
		this.SectionOptions[1] = ["","All"];
		this.SectionOptions[2] = ["deals","Deals"];
		this.SectionOptions[3] = ["events","Events"];
		this.SectionOptions[4] = ["marketplace","Marketplace"];
		this.SectionOptions[5] = ["jobs","Jobs"];
		
		this.SortOptions = ArrayNew(1);
		
		this.SortOptions[1] = ["title","Title","Title ASC"];
		this.SortOptions[2] = ["category","Category","Category ASC"];
		this.SortOptions[3] = ["date","Date","DatePosted DESC"];
		
		this.DefaultSearchText = "Search Events";
	</cfscript>
	
	<cffunction name="GetSectionOptions" access="public" output="false" returntype="array"> 
		<cfreturn this.SectionOptions />
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

	<cffunction name="GetUserRecentActivity" access="public" output="no" returntype="query">
		<cfargument name="UserID" type="numeric" required="yes" />
		<cfargument name="StartRow" type="numeric" default="1" />
		<cfargument name="EndRow" type="numeric" default="#Request.RecordsPerPage#" />
		
		<cfset var loc_UserRecentActivity = "" />
		<cfset var loc_UserID = Arguments.UserID />
		
		<cfquery datasource="#request.dsource#" name="loc_UserRecentActivity">	
			SELECT		*
			FROM		(
					  
							SELECT		ROW_NUMBER() OVER ( ORDER BY DateCreated DESC ) AS RowNum,
										COUNT(*) OVER () as Row_Total,
										Section,
										ID,
										Title,
										DateCreated,
										ActionDate
							FROM		(
		
											SELECT		'community' as Section,
														C.ID,
														C.Title,
														P.DateCreated,
														CONVERT( CHAR(10), P.DateCreated, 101 ) AS ActionDate
											FROM		AMP_Communities C
											JOIN		AMP_CommunityPosts P ON C.ID = P.CommunityID
											WHERE		C.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
											AND			P.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
											AND			P.UserID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_UserID#" />
											
											UNION
											
											SELECT		'deals' as Section,
														ID,
														Title,
														DateCreated,
														CONVERT( CHAR(10), DateCreated, 101 ) AS ActionDate
											FROM		AMP_Deals
											WHERE		[Status] = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
											AND			UserID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_UserID#" />

											UNION

											SELECT		'events' as Section,
														ID,
														Title,
														DateCreated,
														CONVERT( CHAR(10), DateCreated, 101 ) AS ActionDate
											FROM		AMP_Events
											WHERE		[Status] = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
											AND			UserID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_UserID#" />

											UNION

											SELECT		'jobs' as Section,
														ID,
														Title,
														DateCreated,
														CONVERT( CHAR(10), DateCreated, 101 ) AS ActionDate
											FROM		AMP_Jobs
											WHERE		[Status] = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
											AND			UserID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_UserID#" />

											UNION

											SELECT		'marketplace' as Section,
														ID,
														Title,
														DateCreated,
														CONVERT( CHAR(10), DateCreated, 101 ) AS ActionDate
											FROM		AMP_Marketplace
											WHERE		[Status] = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
											AND			UserID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_UserID#" />
											
											UNION
											
											SELECT		'studygroup' as Section,
														G.ID,
														G.Title,
														P.DateCreated,
														CONVERT( CHAR(10), P.DateCreated, 101 ) AS ActionDate
											FROM		AMP_StudyGroups G
											JOIN		AMP_StudyGroupPosts P ON G.ID = P.StudyGroupID
											WHERE		G.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
											AND			P.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
											AND			P.UserID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_UserID#" />
											
										) a

						) AS RowConstrainedResult

			WHERE		RowNum >= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.StartRow#" />
			AND			RowNum <= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.EndRow#" />

			ORDER BY 	RowNum
		</cfquery>
		
		<cfreturn loc_UserRecentActivity />
	</cffunction>
	
	<cffunction name="GetLatestActivity" access="public" output="false" returntype="query">    
		<cfargument name="Section" type="string" default="" />
		<cfargument name="SearchTerm" type="string" default="" />
		<cfargument name="StartRow" type="numeric" default="1" />
		<cfargument name="EndRow" type="numeric" default="#Request.RecordsPerPage#" /> 
		<cfargument name="sidx" type="string" required="no" default="#this.SortOptions[3][3]#" />
		<cfargument name="sord" type="string" required="no" default="desc" />
        
		<cfset var loc_Section = Arguments.Section />
		<cfset var loc_ShowAll = IIF( Arguments.Section EQ "", true, false ) />
		<cfset var loc_LatestActivity = "" />
		<cfset var loc_SearchTerm = TRIM( Arguments.SearchTerm ) />
		
		<cfif loc_SearchTerm EQ this.DefaultSearchText>
			<cfset loc_SearchTerm = "" />
		<cfelseif LEN(loc_SearchTerm)>
			<cfset loc_SearchTerm = "%" & Arguments.SearchTerm & "%" />
		</cfif>
        
		<cfquery datasource="#request.dsource#" name="loc_LatestActivity">
			SELECT		*
			FROM		(
					  
							SELECT		ROW_NUMBER() OVER ( ORDER BY #Arguments.sidx# ) AS RowNum,
										COUNT(*) OVER () as Row_Total,
										Section,
										ID,
										Title,
										Description,
										StartDate,
										StartTime,
										EndDate,
										EndTime,
										Price,
										AddressID,
										AddressTitle,
										Street1,
										Street2,
										City,
										State,
										UserID,
										Username,
										CategoryID,
										Category,
										DateCreated,
										DatePosted
							FROM		(
			
										<cfif loc_Section EQ "deals" OR loc_ShowAll>
											SELECT			'DEAL' AS Section,
															D.ID,
															D.Title,
															D.Description,
															D.StartDate,
															NULL AS StartTime,
															D.EndDate,
															NULL AS EndTime,
															NULL AS Price,
															D.AddressID,
															ADDR.Title AS AddressTitle,
															ADDR.Street1,
															ADDR.Street2,
															ADDR.City,
															ADDR.State,
															D.UserID,
															A.Username,
															D.CategoryID,
															DC.Title AS Category,
															CONVERT( CHAR(10), D.DateCreated, 101 ) AS DateCreated,
															D.DateCreated AS DatePosted

											FROM			AMP_Deals D	
											JOIN			AMP_Accounts A ON D.UserID = A.ID
											JOIN			AMP_Address ADDR ON D.AddressID = ADDR.ID			
											JOIN			AMP_DealCategories DC ON D.CategoryID = DC.ID
											LEFT JOIN		(
																SELECT		SUM(Cost) as BudgetUsed,
																			DealID
																FROM		AMP_DealTracking
																GROUP BY	DealID
															) TRACKING ON D.ID = TRACKING.DealID

											WHERE			1=1
											AND				D.Status = 1
											AND				A.Status = 1
											AND				(
																D.StartDate IS NULL 
																OR 
																DATEDIFF( DAY, D.StartDate, GETDATE() ) >= 0
															)
											AND				(
																D.EndDate IS NULL 
																OR 
																DATEDIFF( DAY, D.EndDate, GETDATE() ) <= 0
															)	
											AND				ISNULL(TRACKING.BudgetUsed,0) < D.Budget		
											<cfif LEN( loc_SearchTerm )>
												AND			(
																D.Title LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#loc_SearchTerm#" />		
																OR
																D.Description LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#loc_SearchTerm#" />
															)
											</cfif>											
										</cfif>

										<cfif loc_ShowAll>
											--------------------------------------------------------------------------------
											UNION
											--------------------------------------------------------------------------------
										</cfif>

										<cfif loc_Section EQ "events" OR loc_ShowAll>
											/* EVENTS */
											SELECT			'EVENT' AS Section,
															E.ID,
															E.Title,
															E.Description,
															E.StartDate,
															CONVERT(CHAR(5),E.StartDate,108) AS StartTime,
															E.EndDate,	
															CONVERT(CHAR(5),E.EndDate,108) AS EndTime,
															NULL AS Price,
															E.AddressID,										
															ADDR.Title AS AddressTitle,
															ADDR.Street1,
															ADDR.Street2,
															ADDR.City,
															ADDR.State,
															E.UserID,
															A.Username,
															E.CategoryID,
															EC.Title AS Category,
															CONVERT( CHAR(10), E.DateCreated, 101 ) AS DateCreated,
															E.DateCreated AS DatePosted

											FROM			AMP_Events E
											JOIN			AMP_Address ADDR ON E.AddressID = ADDR.ID		
											JOIN			AMP_Accounts A ON E.UserID = A.ID			
											JOIN			AMP_EventCategories EC ON E.CategoryID = EC.ID

											WHERE			E.Status = 1
											AND			A.Status = 1
											<cfif LEN( loc_SearchTerm )>
												AND			(
																E.Title LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#loc_SearchTerm#" />		
																OR
																E.Description LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#loc_SearchTerm#" />
															)
											</cfif>
										</cfif>

										<cfif loc_ShowAll>
											--------------------------------------------------------------------------------
											UNION
											--------------------------------------------------------------------------------
										</cfif>			
										
										<cfif loc_Section EQ "jobs" OR loc_ShowAll>
											/* JOBS */
											 
											SELECT			'JOB' AS Section,
															J.ID,
															J.Title,
															J.Description,
															NULL AS StartDate,
															NULL AS StartTime,
															NULL AS EndDate,
															NULL AS EndTime,
															NULL AS Price,
															J.AddressID,
															ADDR.Title AS AddressTitle,
															ADDR.Street1,
															ADDR.Street2,
															ADDR.City,
															ADDR.State,
															J.UserID,
															A.Username,
															J.CategoryID,
															JC.Title AS Category,
															CONVERT( CHAR(10), J.DateCreated, 101 ) AS DateCreated,
															J.DateCreated AS DatePosted

											FROM			AMP_Jobs J
											JOIN			AMP_Address ADDR ON J.AddressID = ADDR.ID
											JOIN			AMP_Accounts A ON J.UserID = A.ID	
											JOIN			AMP_JobCategories JC ON J.CategoryID = JC.ID

											WHERE			1=1
											AND			J.Status = 1
											AND			A.Status = 1
											<cfif LEN( loc_SearchTerm )>
												AND			(
																J.Title LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#loc_SearchTerm#" />		
																OR
																J.Description LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#loc_SearchTerm#" />
															)
											</cfif>
										</cfif>
										
										<cfif loc_ShowAll>
											--------------------------------------------------------------------------------
											UNION
											--------------------------------------------------------------------------------
										</cfif>			
										
										<cfif loc_Section EQ "marketplace" OR loc_ShowAll>
											/* MARKETPLACE */
											SELECT			'MARKETPLACE' AS Section,
															M.ID,
															M.Title,
															M.Description,
															CONVERT(CHAR(10),M.StartDate,101) AS StartDate,
															NULL AS StartTime,
															CONVERT(CHAR(10),M.EndDate,101) AS EndDate,
															NULL AS EndTime,
															M.Price,		
															NULL AS AddressID,
															NULL AS AddressTitle,
															NULL AS Street1,
															NULL AS Street2,
															NULL AS City,
															NULL AS State,								
															M.UserID,
															A.Username,
															M.CategoryID,
															MC.Title AS Category,
															CONVERT( CHAR(10), M.DateCreated, 101 ) AS DateCreated,
															M.DateCreated AS DatePosted
											
											FROM			AMP_Marketplace M						
											JOIN			AMP_Accounts A ON M.UserID = A.ID
											JOIN			AMP_MarketplaceCategories MC ON M.CategoryID = MC.ID
											
											WHERE			1=1
											AND				M.Status = 1
											AND				A.Status = 1
											AND				(
																M.StartDate IS NULL 
																OR 
																DATEDIFF( DAY, M.StartDate, GETDATE() ) >= 0
															)
											AND				(
																M.EndDate IS NULL 
																OR 
																DATEDIFF( DAY, M.EndDate, GETDATE() ) <= 0
															)
											<cfif LEN( loc_SearchTerm )>
												AND			(
																M.Title LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#loc_SearchTerm#" />		
																OR
																M.Description LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#loc_SearchTerm#" />
															)
											</cfif>
										</cfif>

											--------------------------------------------------------------------------------
											
										) a

						) AS RowConstrainedResult

			WHERE		RowNum >= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.StartRow#" />
			AND			RowNum <= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.EndRow#" />

			ORDER BY 	RowNum
		</cfquery>
		
		<cfreturn loc_LatestActivity />
	</cffunction>
	
</cfcomponent>