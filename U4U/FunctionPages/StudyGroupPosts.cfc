<cfcomponent extends="MachII.framework.Listener">

	<cfscript>
		this.SortOptions = ArrayNew(1);
		
		this.SortOptions[1] = ["datecreated","Date Created","P.DateCreated"];
		this.SortOptions[2] = ["title","Description","P.Description"];
		this.SortOptions[3] = ["studygroup","Study Group","G.Title"];
		this.SortOptions[4] = ["course","Course","C.Title"];
		this.SortOptions[5] = ["school","School","S.Title"];
		this.SortOptions[6] = ["username","Username","A.Username"];		
		this.SortOptions[7] = ["status","Status","ST.Status"];
	</cfscript>
	
	<cffunction name="GetSortOptions" access="public" output="false" returntype="array"> 
		<cfreturn this.SortOptions />
	</cffunction>
	
	<cffunction name="GetStudyGroupPosts" access="public" output="false" returntype="query">    
		<cfargument name="Description" type="string" default="" />
		<cfargument name="School" type="string" default="" />
		<cfargument name="Course" type="string" default="" />
		<cfargument name="StudyGroup" type="string" default="" />
		<cfargument name="Username" type="string" default="" />
		<cfargument name="Status" type="string" default="" />
		<cfargument name="sidx" type="string" required="no" default="#this.SortOptions[1][3]#" />
		<cfargument name="sord" type="string" required="no" default="desc" />
        
		<cfset var loc_StudyGroupPosts = "" />
        
		<cfquery datasource="#request.dsource#" name="loc_StudyGroupPosts">
			SELECT		*
			FROM  (
					  
						SELECT			ROW_NUMBER() OVER ( ORDER BY #Arguments.sidx# ) AS RowNum,
										COUNT(*) OVER () as Row_Total,
										P.ID,
										CASE
											WHEN LEN(P.Description) >= #REQUEST.ShortDescriptionLength# THEN LEFT(P.Description,#REQUEST.ShortDescriptionLength#) + '...'
											ELSE P.Description
										END AS Title,
										P.Description,
										P.StudyGroupID,
										G.Title AS StudyGroup,
										G.CourseID,
										C.Title AS Course,
										C.SchoolID,
										S.Title AS School,
										P.UserID,
										A.Username,
										A.Signature,
										ISNULL(POSTS.Total,0) AS UserPostCount,
										PR.Description AS QuoteDescription,
										CONVERT(CHAR(10),P.DateCreated,101) AS DateCreated,
										P.DateCreated AS DatePosted,
										ST.Status
						
						FROM			AMP_StudyGroupPosts P
						JOIN			AMP_StudyGroups G ON P.StudyGroupID = G.ID
						JOIN			AMP_Courses C ON G.CourseID = C.ID
						JOIN			AMP_Schools S ON C.SchoolID = S.ID
						JOIN			AMP_Accounts A ON P.UserID = A.ID
						JOIN			AMP_Status ST ON P.Status = ST.ID
						
						LEFT JOIN		(
											SELECT		COUNT(*) AS Total,
														UserID
											FROM		AMP_StudyGroupPosts
											GROUP BY	UserID
										) POSTS ON P.UserID = POSTS.UserID
						
						LEFT JOIN		AMP_StudyGroupPosts PR ON P.ReplyPostID = PR.ID
						
						WHERE			1=1
					<cfif Len(Arguments.Description)>
							AND			P.Description LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.Description#%" />		
					</cfif>
					<cfif IsNumeric(Arguments.Username)>
						AND				P.UserID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Username#" />		
					</cfif>
					<cfif IsNumeric(Arguments.Course)>
						AND				G.CourseID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Course#" />		
					</cfif>
					<cfif IsNumeric(Arguments.StudyGroup)>
						AND				P.StudyGroupID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.StudyGroup#" />		
					</cfif>
					<cfif IsNumeric(Arguments.School)>
						AND				C.SchoolID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.School#" />		
					</cfif>
					<cfif IsBoolean(Arguments.Status)>
						AND				P.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />		
					</cfif>
					
					<cfif Request.IsFrontEnd>
						AND				P.StudyGroupID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.StudyGroupID#" />		
						AND				P.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
						AND				G.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
						AND				C.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
						<!--- AND				A.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="1" /> --->
					</cfif>
			
			) AS RowConstrainedResult

			WHERE		RowNum >= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.StartRow#" />
			AND			RowNum <= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.EndRow#" />
			
			ORDER BY 	RowNum		
		</cfquery>
		
		<cfreturn loc_StudyGroupPosts />
	</cffunction>
	
	<cffunction name="GetStudyGroupPostDetails" access="public" output="false" returntype="query">    
		<cfargument name="StudyGroupPostID" default="0" />
        
		<cfset var loc_Post = "" />
        
		<cfquery datasource="#request.dsource#" name="loc_Post">
			SELECT		P.ID,
						P.Description,
						P.Status,
						A.Username
			
			FROM		AMP_StudyGroupPosts P
			JOIN		AMP_Accounts A ON P.UserID = A.ID
			
			WHERE		P.ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.StudyGroupPostID#" />
		</cfquery>		
		
		<cfreturn loc_Post />
	</cffunction> 
	
	<cffunction name="ReplyToStudyGroupPost" access="public" output="false" returntype="void">    
		<cfargument name="StudyGroupID" type="numeric" required="yes" />
		<cfargument name="StudyGroupPostID" default="" />
		<cfargument name="User" type="numeric" required="yes" />
		<cfargument name="Description" type="string" default="" />
				
		<cfset var loc_Reply = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_Reply">
			INSERT INTO AMP_StudyGroupPosts(
				StudyGroupID,
				UserID,
				ReplyPostID,
				Description,
				Status,
				DateCreated				
			) VALUES (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.StudyGroupID#" />,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.User#" />,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.StudyGroupPostID#" null="#NOT( IsNumeric( Arguments.StudyGroupPostID ) )#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Description#" />,
				<cfqueryparam cfsqltype="cf_sql_bit" value="1" />,
				GETDATE()
			)
		</cfquery>
		
	</cffunction>
	
	<cffunction name="UpdateStudyGroupPost" access="public" output="true" returntype="void">    
		<cfargument name="StudyGroupPostID" default="0" />
		<cfargument name="Description" type="string" default="" />		
		<cfargument name="Status" default="1" />
		<cfargument name="ReturnUrl" type="string" required="yes" />
		
		<cfset var loc_UpdateStudyGroupPost = "" />
		<cfset var loc_StudyGroupPostID = Arguments.StudyGroupPostID />
		<cfset var loc_StatusMessage = "" />
		<cfset var loc_ReturnUrl = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_UpdateStudyGroupPost">
			DECLARE @StudyGroupPostID AS Int;

			SET @StudyGroupPostID = (
				SELECT	ID
				FROM	AMP_StudyGroupPosts
				WHERE	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_StudyGroupPostID#" />
			);
			
			IF @StudyGroupPostID IS NOT NULL
			
				UPDATE	AMP_StudyGroupPosts
			
				SET		Description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Description#" />,
						Status = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />,
						DateModified = GETDATE()
			
				WHERE	ID = @StudyGroupPostID;
		</cfquery>
		
		<cfset loc_StatusMessage = "StudyGroupPost.Updated" />
		
		<cfset loc_ReturnUrl = Arguments.ReturnUrl & "&StudyGroupPostID=" & loc_StudyGroupPostID & "&Message=" & loc_StatusMessage />
		
		<cflocation url="#loc_ReturnUrl#" addtoken="no" />	
		
	</cffunction> 
	
	<cffunction name="DeleteStudyGroupPost" access="public" output="false" returntype="void">    
		<cfargument name="StudyGroupPostID" type="numeric" required="yes" />
		
		<cfset var loc_DeletePost = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_DeletePost">
			DELETE
			FROM		AMP_StudyGroupPosts
			WHERE		ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.StudyGroupPostID#" />
		</cfquery>
		
	</cffunction>
	
</cfcomponent>