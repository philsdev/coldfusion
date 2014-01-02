<cfcomponent extends="MachII.framework.Listener">

	<cfscript>
		this.SortOptions = ArrayNew(1);
		
		this.SortOptions[1] = ["title","Title","C.Title"];
		this.SortOptions[2] = ["school","School","S.Title"];
		this.SortOptions[3] = ["datecreated","Date Created","C.DateCreated"];
		this.SortOptions[4] = ["status","Status","ST.Status"];
	</cfscript>
	
	<cffunction name="GetSortOptions" access="public" output="false" returntype="array"> 
		<cfreturn this.SortOptions />
	</cffunction>
	
	<cffunction name="GetDisplayCourses" access="public" output="false" returntype="query" hint="FRONT END">
		<cfargument name="School" default="" />
		
		<cfset var loc_DisplayCourses = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_DisplayCourses">
			SELECT			C.ID,
							C.Title

			FROM			AMP_Courses C
			WHERE			C.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
		<cfif IsNumeric( Arguments.School )>
			AND				C.SchoolID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.School#" />
		<cfelse>
			AND				0=1
		</cfif>
			
			ORDER BY 		Title
		</cfquery>		
		
		<cfreturn loc_DisplayCourses />
	</cffunction> 
	
	<cffunction name="GetCourses" access="public" output="false" returntype="query">    
		<cfargument name="StartRow" type="numeric" default="1" />
		<cfargument name="EndRow" type="numeric" default="#Request.RecordsPerPage#" /> 
		<cfargument name="Title" type="string" default="" />
		<cfargument name="School" type="string" default="" />
		<cfargument name="Status" type="string" default="" />
		<cfargument name="sidx" type="string" required="no" default="#this.SortOptions[1][3]#" />
		<cfargument name="sord" type="string" required="no" default="asc" />
        
		<cfset var loc_Courses = "" />
        
		<cfquery datasource="#request.dsource#" name="loc_Courses">
			SELECT		*
			FROM  (
					  
						SELECT			ROW_NUMBER() OVER ( ORDER BY #Arguments.sidx# ) AS RowNum,
										COUNT(*) OVER () as Row_Total,
										C.ID,
										C.Title,
										S.Title AS School,
										CONVERT(CHAR(10),C.DateCreated,101) AS DateCreated,
										ST.Status
						
						FROM			AMP_Courses C
						JOIN			AMP_Schools S ON C.SchoolID = S.ID
						JOIN			AMP_Status ST ON C.Status = ST.ID
						
						WHERE			1=1
					<cfif Len(Arguments.Title)>
							AND			C.Title LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.Title#%" />		
					</cfif>
					<cfif IsNumeric(Arguments.School)>
						AND				C.SchoolID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.School#" />		
					</cfif>
					<cfif IsBoolean(Arguments.Status)>
						AND				C.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />		
					</cfif>
		
			) AS RowConstrainedResult

			WHERE		RowNum >= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.StartRow#" />
			AND			RowNum <= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.EndRow#" />
			
			ORDER BY 	RowNum		
		</cfquery>
		
		<cfreturn loc_Courses />
	</cffunction>
	
	<cffunction name="GetCourseDetails" access="public" output="false" returntype="query">    
		<cfargument name="CourseID" default="0" />
        
		<cfset var loc_Course = "" />
        
		<cfquery datasource="#request.dsource#" name="loc_Course">
			SELECT		C.ID,
						C.Title,
						C.Description,
						C.SchoolID,
						C.Status
			
			FROM		AMP_Courses C
			
			WHERE		C.ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.CourseID#" />
		</cfquery>		
		
		<cfreturn loc_Course />
	</cffunction> 
	
	<cffunction name="UpdateCourse" access="public" output="true" returntype="void">    
		<cfargument name="IsBackEnd" default="no">
		<cfargument name="CourseID" type="numeric" required="yes" />
		<cfargument name="School" type="numeric" required="yes" />
		<cfargument name="Status" default="1" />
		
		<cfset var loc_UpdateCourse = "" />
		<cfset var loc_CourseID = Arguments.CourseID />
		<cfset var loc_StatusMessage = "" />
		<cfset var loc_ReturnUrl = "" />
		
	   	<cfquery datasource="#request.dsource#" name="loc_UpdateCourse">
			DECLARE @CourseID AS Int;

			SET @CourseID = (
				SELECT	ID
				FROM	AMP_Courses
				WHERE	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_CourseID#" />
			);
			
			IF @CourseID IS NULL
			
				BEGIN
				
					SET NOCOUNT ON;
				
					INSERT INTO AMP_Courses (
						SchoolID,
						Title,
						Description,
						Status,
						DateCreated
					 )
					 VALUES (
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.School#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Title#" maxlength="50" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Description#" />,
						<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />,
						GetDate()
					 )
						 
					SELECT	@@IDENTITY AS NewID,
							'Course.Added' AS StatusMessage;
					SET NOCOUNT OFF;
				END
			ELSE
				BEGIN
				
					UPDATE	AMP_Courses
			
					SET		SchoolID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.School#" />,
							Title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Title#" maxlength="50" />,
							Description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Description#" />,
							Status = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />,
							DateModified = GETDATE()					
			
					WHERE	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_CourseID#" />;
			
					SELECT	#loc_CourseID# AS NewID,
							'Course.Updated' AS StatusMessage;
				END
		</cfquery>
		
		<cfset loc_CourseID = loc_UpdateCourse.NewID />
		<cfset loc_StatusMessage = loc_UpdateCourse.StatusMessage />
		
		<cfset loc_ReturnUrl = Arguments.ReturnUrl />
		<cfif Arguments.IsBackEnd>
			<cfset loc_ReturnUrl = loc_ReturnUrl & "&CourseID=" & loc_CourseID & "&Message=" & loc_StatusMessage />
		</cfif>
		
		<cflocation url="#loc_ReturnUrl#" addtoken="no" />	
		
	</cffunction> 
	
	<cffunction name="DeleteCourse" access="public" output="false" returntype="void">    
		<cfargument name="CourseID" type="numeric" required="yes" />
		
		<cfset var loc_DeleteCourse = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_DeleteCourse">
			DELETE
			FROM		AMP_Courses
			WHERE		ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.CourseID#" />
		</cfquery>
		
	</cffunction>
	
</cfcomponent>