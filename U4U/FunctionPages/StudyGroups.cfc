<cfcomponent extends="MachII.framework.Listener">

	<cfscript>
		this.SortOptions = ArrayNew(1);
		
		this.SortOptions[1] = ["title","Title","G.Title"];
		this.SortOptions[2] = ["course","Course","C.Title"];
		this.SortOptions[3] = ["school","School","S.Title"];
		this.SortOptions[4] = ["username","Username","A.Username"];
		this.SortOptions[5] = ["posts","Posts","ISNULL(SGP.Total,0)"];
		this.SortOptions[6] = ["datecreated","Date Created","G.DateCreated"];
		this.SortOptions[7] = ["status","Status","ST.Status"];
		
		this.DefaultSearchText = "Search Study Groups";
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
			
	<cffunction name="GetStudyGroups" access="public" output="false" returntype="query">  
		<cfargument name="StartRow" type="numeric" default="1" />
		<cfargument name="EndRow" type="numeric" default="#Request.RecordsPerPage#" /> 
		<cfargument name="Title" type="string" default="" />
		<cfargument name="DateCreated" type="string" default="" />
		<cfargument name="Course" type="string" default="" />
		<cfargument name="School" type="string" default="" />
		<cfargument name="Username" type="string" default="" />
		<cfargument name="User" type="string" default="" />
		<cfargument name="Status" type="string" default="" />
		<cfargument name="SearchTerm" type="string" default="" />
		<cfargument name="sidx" type="string" required="no" default="#this.SortOptions[1][3]#" />
		<cfargument name="sord" type="string" required="no" default="desc" />
        
		<cfset var loc_StudyGroups = "" />
		<cfset var loc_SearchTerm = TRIM( Arguments.SearchTerm ) />
		
		<cfif loc_SearchTerm EQ this.DefaultSearchText>
			<cfset loc_SearchTerm = "" />
		<cfelseif LEN(loc_SearchTerm)>
			<cfset loc_SearchTerm = "%" & Arguments.SearchTerm & "%" />
		</cfif>
        
		<cfquery datasource="#request.dsource#" name="loc_StudyGroups">
			SELECT		*
			FROM  (
		
						SELECT			ROW_NUMBER() OVER ( ORDER BY #Arguments.sidx# ) AS RowNum,
										COUNT(*) OVER () as Row_Total,
										G.ID,
										G.Title,
										G.CourseID,
										C.Title AS Course,
										S.Title AS School,
										CONVERT(CHAR(10),G.DateCreated,101) AS DateCreated,
										A.Username,
										ISNULL(SGP.Total,0) AS Posts,
										SGP2.ID AS RecentPostID,
										CASE
											WHEN LEN(SGP2.Description) >= #REQUEST.ShortDescriptionLength# THEN LEFT(SGP2.Description,#REQUEST.ShortDescriptionLength#) + '...'
											ELSE SGP2.Description
										END AS RecentPostTitle,
										SGP2.UserID AS RecentPostUserID,
										A2.Username AS RecentPostUsername,
										ST.Status
							
						FROM			AMP_StudyGroups G
						JOIN			AMP_Courses C ON G.CourseID = C.ID
						JOIN			AMP_Schools S ON C.SchoolID = S.ID
						JOIN			AMP_Accounts A ON G.UserID = A.ID
						JOIN			AMP_Status ST ON C.Status = ST.ID
							
						LEFT JOIN		(
											SELECT		P.StudyGroupID,
														COUNT(P.ID) AS Total,
														MAX(P.ID) AS MaxID
											FROM		AMP_StudyGroupPosts P
											JOIN		AMP_StudyGroups G ON P.StudyGroupID = G.ID
											JOIN		AMP_Accounts A ON P.UserID = A.ID
											WHERE		P.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
											AND			G.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
											GROUP BY	P.StudyGroupID
										) SGP ON G.ID = SGP.StudyGroupID
			
						LEFT JOIN		AMP_StudyGroupPosts SGP2 ON SGP.MaxID = SGP2.ID
						LEFT JOIN		AMP_Accounts A2 ON SGP2.UserID = A2.ID
						
						WHERE			1=1
					<cfif IsNumeric(Arguments.Course)>
						AND				G.CourseID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Course#" />		
					</cfif>
					<cfif IsNumeric(Arguments.School)>
						AND				C.SchoolID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.School#" />		
					</cfif>
					<cfif IsNumeric(Arguments.Username)>
						AND				G.UserID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Username#" />		
					</cfif>
					<cfif IsNumeric(Arguments.User)>
						AND				G.ID IN (
											SELECT		StudyGroupID
											FROM		AMP_StudyGroupPosts
											WHERE		UserID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.User#" />		
											GROUP BY	StudyGroupID
										)
					</cfif>
					<cfif LEN( loc_SearchTerm )>
						AND				(
											G.Title LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#loc_SearchTerm#" />		
											OR
											G.Description LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#loc_SearchTerm#" />
										)
					</cfif>
					
					<cfif Request.IsFrontEnd>
						AND				G.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />	
						AND				C.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />	
						
						<!--- HACK: don't return records unless school AND course are selected --->
						<cfif NOT IsNumeric(Arguments.Course) OR NOT IsNumeric(Arguments.School)>
						AND				0 = 1
						</cfif>
					</cfif>
			
			) AS RowConstrainedResult

			WHERE		RowNum >= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.StartRow#" />
			AND			RowNum <= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.EndRow#" />
			
			ORDER BY 	RowNum	
		</cfquery>
		
		<cfreturn loc_StudyGroups />
	</cffunction>
	
	<cffunction name="GetStudyGroupDetails" access="public" output="false" returntype="query">    
		<cfargument name="StudyGroupID" default="0" />
		 <cfargument name="User" default="" />
        
		<cfset var loc_StudyGroup = "" />
        
		<cfquery datasource="#request.dsource#" name="loc_StudyGroup">
			SELECT		G.ID,
						G.Title,
						G.Description,
						G.UserID,
						G.CourseID,
						C.SchoolID,
						C.Title AS Course,
						G.Status
			
			FROM		AMP_StudyGroups G
			JOIN		AMP_Courses C ON G.CourseID = C.ID
			JOIN		AMP_Accounts A ON G.UserID = A.ID
			
			WHERE		G.ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.StudyGroupID#" />
			
			<cfif Request.IsFrontEnd>
				AND		G.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
				AND		C.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
				AND		A.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
				<cfif IsNumeric(Arguments.User)>
					AND		G.UserID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.User#" />
				</cfif>
			</cfif>
		</cfquery>		
		
		<cfreturn loc_StudyGroup />
	</cffunction> 
	
	<cffunction name="UpdateStudyGroup" access="public" output="true" returntype="void">    
		<cfargument name="StudyGroupID" default="0" />
		<cfargument name="Title" type="string" default="" />
		<cfargument name="Description" type="string" default="" />
		<cfargument name="Course" type="string" default="" />
		<cfargument name="User" type="string" default="" />
		<cfargument name="Status" default="1" />
		
		<cfset var loc_UpdateStudyGroup = "" />
		<cfset var loc_StudyGroupID = Arguments.StudyGroupID />
		<cfset var loc_LinkManager = "" />
		<cfset var loc_StatusMessage = "" />
		<cfset var loc_ReturnUrl = "" />
		
	   	<cfquery datasource="#request.dsource#" name="loc_UpdateStudyGroup">
			DECLARE @StudyGroupID AS Int;

			SET @StudyGroupID = (
				SELECT	ID
				FROM	AMP_StudyGroups
				WHERE	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_StudyGroupID#" />
			);
			
			IF @StudyGroupID IS NULL
			
				BEGIN
				
					SET NOCOUNT ON;
					
					INSERT INTO AMP_StudyGroups (
						Title,
						Description,
						CourseID,
						UserID,
						Status,
						DateCreated
					 )
					 VALUES (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Title#" maxlength="50" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Description#" />,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Course#" />,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.User#" />,
						<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />,
						GetDate()
					 )
						 
					SELECT	@@IDENTITY AS NewID,
							'StudyGroup.Added' AS StatusMessage;
					SET NOCOUNT OFF;
				END
			ELSE
				BEGIN
							
					UPDATE	AMP_StudyGroups
			
					SET		Title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Title#" maxlength="50" />,
							Description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Description#" />,
							CourseID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Course#" />,
							UserID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.User#" />,
							Status = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />,
							DateModified = GETDATE()					
			
					WHERE	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_StudyGroupID#" />;
			
					SELECT	#loc_StudyGroupID# AS NewID,
							'StudyGroup.Updated' AS StatusMessage;
				END
		</cfquery>
		
		<cfset loc_StudyGroupID = loc_UpdateStudyGroup.NewID />
		<cfset loc_StatusMessage = loc_UpdateStudyGroup.StatusMessage />
		
		<cfif Request.IsFrontEnd>			
			<cfset loc_LinkManager = Request.ListenerManager.GetListener( "LinkManager" ) />
			<cfset loc_ReturnUrl = loc_LinkManager.GetStudyGroupLink( StudyGroupID:loc_StudyGroupID, StudyGroupTitle:Arguments.Title ) />
		<cfelse>
			<cfset loc_ReturnUrl = Arguments.ReturnUrl & "&StudyGroupID=" & loc_StudyGroupID & "&Message=" & loc_StatusMessage />
		</cfif>
		
		<cflocation url="#loc_ReturnUrl#" addtoken="no" />	
		
	</cffunction> 
	
	<cffunction name="DeleteStudyGroup" access="public" output="false" returntype="void">    
		<cfargument name="StudyGroupID" type="numeric" required="yes" />
		
		<cfset var loc_DeleteStudyGroup = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_DeleteStudyGroup">
			DELETE
			FROM		AMP_StudyGroups
			WHERE		ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.StudyGroupID#" />
		</cfquery>
		
	</cffunction>
	
</cfcomponent>