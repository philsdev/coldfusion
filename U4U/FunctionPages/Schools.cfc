<cfcomponent extends="MachII.framework.Listener">

	<cfscript>
		this.SortOptions = ArrayNew(1);
		
		this.SortOptions[1] = ["title","Title","S.Title"];
		this.SortOptions[2] = ["city","City","A.City"];
		this.SortOptions[3] = ["state","State","A.State"];
		this.SortOptions[4] = ["datecreated","Date Created","C.DateCreated"];
		this.SortOptions[5] = ["status","Status","ST.Status"];
	</cfscript>
	
	<cffunction name="GetSortOptions" access="public" output="false" returntype="array"> 
		<cfreturn this.SortOptions />
	</cffunction>
	
	<cffunction name="GetDisplaySchools" access="public" output="false" returntype="query" hint="FRONT END">
		<cfset var loc_DisplaySchools = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_DisplaySchools">
			SELECT			S.ID,
							S.Title

			FROM			AMP_Schools S
			WHERE			S.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
			
			ORDER BY 		Title
		</cfquery>		
		
		<cfreturn loc_DisplaySchools />
	</cffunction> 
	
	<cffunction name="GetSchools" access="public" output="false" returntype="query">    
		<cfargument name="StartRow" type="numeric" default="1" />
		<cfargument name="EndRow" type="numeric" default="#Request.RecordsPerPage#" /> 
		<cfargument name="Title" type="string" default="" />
		<cfargument name="City" type="string" default="" />
		<cfargument name="State" type="string" default="" />
		<cfargument name="Status" type="string" default="" />
		<cfargument name="sidx" type="string" required="no" default="#this.SortOptions[1][3]#" />
		<cfargument name="sord" type="string" required="no" default="asc" />
        
		<cfset var loc_Schools = "" />
 
		<cfquery datasource="#request.dsource#" name="loc_Schools">
			SELECT		*
			FROM  (
					  
						SELECT			ROW_NUMBER() OVER ( ORDER BY #Arguments.sidx# ) AS RowNum,
										COUNT(*) OVER () as Row_Total,										
										S.ID,
										S.Title,
										L.Title AS Location,
										A.City,
										A.State,
										CONVERT(CHAR(10),S.DateCreated,101) AS DateCreated,
										ST.Status
						
						FROM			AMP_Schools S
						JOIN			AMP_Locations L ON S.LocationID = L.ID
						JOIN			AMP_Address A ON S.AddressID = A.ID	
						JOIN			AMP_Status ST ON S.Status = ST.ID
						
						WHERE			1=1
					<cfif Len(Arguments.Title)>
							AND			S.Title LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.Title#%" />		
					</cfif>
					<cfif Len(Arguments.City)>
							AND			A.City LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.City#%" />		
					</cfif>
					<cfif Len(Arguments.State)>
							AND			A.State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.State#" />		
					</cfif>
					<cfif IsBoolean(Arguments.Status)>
						AND				S.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />		
					</cfif>
					
			) AS RowConstrainedResult

			WHERE		RowNum >= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.StartRow#" />
			AND			RowNum <= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.EndRow#" />
			
			ORDER BY 	RowNum		
		</cfquery>
		
		<cfreturn loc_Schools />
	</cffunction>
	
	<cffunction name="GetSchoolDetails" access="public" output="false" returntype="query">    
		<cfargument name="SchoolID" default="0" />
        
		<cfset var loc_School = "" />
        
		<cfquery datasource="#request.dsource#" name="loc_School">
			SELECT		S.ID,
						S.Title,
						S.Status,
						S.LocationID,
						ADDR.Title AS AddressTitle,
						ADDR.Street1,
						ADDR.Street2,
						ADDR.City,
						ADDR.State,
						ADDR.ZipCode,
						ADDR.PhoneNumber,
						ADDR.URL
			
			FROM		AMP_Schools S
			JOIN		AMP_Address ADDR ON S.AddressID = ADDR.ID
			
			WHERE		S.ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.SchoolID#" />
		</cfquery>		
		
		<cfreturn loc_School />
	</cffunction> 
	
	<cffunction name="UpdateSchool" access="public" output="true" returntype="void">    
		<cfargument name="IsBackEnd" default="no">
		<cfargument name="SchoolID" type="numeric" required="yes" />
		<cfargument name="Location" type="numeric" required="yes" />
		<cfargument name="Title" type="string" required="yes" />
		<cfargument name="Status" default="1" />
		<cfargument name="AddressTitle" type="string" default="" />
		<cfargument name="Street1" type="string" default="" />
		<cfargument name="Street2" type="string" default="" />
		<cfargument name="City" type="string" default="" />
		<cfargument name="State" type="string" default="" />
		<cfargument name="ZipCode" type="string" default="" />
		<cfargument name="PhoneNumber" type="string" default="" />
		<cfargument name="Url" type="string" default="" />
		
		<cfset var loc_UpdateSchool = "" />
		<cfset var loc_SchoolID = Arguments.SchoolID />
		<cfset var loc_StatusMessage = "" />
		<cfset var loc_ReturnUrl = "" />
		
	   	<cfquery datasource="#request.dsource#" name="loc_UpdateSchool">
			DECLARE @AddressID AS Int;

			SET @AddressID = (
				SELECT	AddressID
				FROM	AMP_Schools
				WHERE	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_SchoolID#" />
			);
			
			IF @AddressID IS NULL
			
				BEGIN
				
					SET NOCOUNT ON;
					
					INSERT INTO AMP_Address (
						Title,
						Street1,
						Street2,
						City,
						State,
						ZIPCode,
						PhoneNumber,
						URL,
						DateCreated
					) VALUES (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.AddressTitle#" maxlength="50" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Street1#" maxlength="50" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Street2#" maxlength="50" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.City#" maxlength="50" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.State#" maxlength="2" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ZipCode#" maxlength="10" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.PhoneNumber#" maxlength="20" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Url#" maxlength="200" />,
						GETDATE()	
					);
			
					SET @AddressID = @@IDENTITY;
				
					INSERT INTO AMP_Schools (
						AddressID,
						LocationID,
						Title,
						Status,
						DateCreated
					 )
					 VALUES (
						@AddressID,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Location#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Title#" maxlength="50" />,
						<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />,
						GetDate()
					 )
						 
					SELECT	@@IDENTITY AS NewID,
							'School.Added' AS StatusMessage;
					SET NOCOUNT OFF;
				END
			ELSE
				BEGIN
				
					UPDATE	AMP_Address
			
					SET		Title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.AddressTitle#" maxlength="50" />,
							Street1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Street1#" maxlength="50" />,
							Street2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Street2#" maxlength="50" />,
							City = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.City#" maxlength="50" />,
							State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.State#" maxlength="2" />,
							ZIPCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ZipCode#" maxlength="10" />,
							PhoneNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.PhoneNumber#" maxlength="20" />,
							URL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Url#" maxlength="200" />,
							DateModified = GETDATE()
			
					WHERE	ID = @AddressID;
				
					UPDATE	AMP_Schools
			
					SET		AddressID = @AddressID,
							LocationID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Location#" />,
							Title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Title#" maxlength="50" />,
							Status = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />,
							DateModified = GETDATE()					
			
					WHERE	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_SchoolID#" />;
			
					SELECT	#loc_SchoolID# AS NewID,
							'School.Updated' AS StatusMessage;
				END
		</cfquery>
		
		<cfset loc_SchoolID = loc_UpdateSchool.NewID />
		<cfset loc_StatusMessage = loc_UpdateSchool.StatusMessage />
		
		<cfset loc_ReturnUrl = Arguments.ReturnUrl />
		<cfif Arguments.IsBackEnd>
			<cfset loc_ReturnUrl = loc_ReturnUrl & "&SchoolID=" & loc_SchoolID & "&Message=" & loc_StatusMessage />
		</cfif>
		
		<cflocation url="#loc_ReturnUrl#" addtoken="no" />	
		
	</cffunction> 
	
	<cffunction name="DeleteSchool" access="public" output="false" returntype="void">    
		<cfargument name="SchoolID" type="numeric" required="yes" />
		
		<cfset var loc_DeleteSchool = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_DeleteSchool">
			DECLARE @AddressID AS Int;

			SET @AddressID = (
				SELECT	AddressID
				FROM	AMP_Schools
				WHERE	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.SchoolID#" />
			);
			
			DELETE
			FROM		AMP_Schools
			WHERE		ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.SchoolID#" />;
			
			IF @AddressID IS NOT NULL
			
				DELETE
				FROM		AMP_Address
				WHERE		ID = @AddressID;
		</cfquery>
		
	</cffunction>
	
</cfcomponent>