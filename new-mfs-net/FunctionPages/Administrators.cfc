<cfcomponent hint="This component will handle editing site administrators" extends="MachII.framework.Listener">

	<cfscript>
		this.SortOptions = ArrayNew(1);
		
		this.SortOptions[1] = ["firstname","First Name","A.FirstName"];
		this.SortOptions[2] = ["lastname","Last Name","A.LastName"];
		this.SortOptions[3] = ["datecreated","Date Created","A.DateCreated"];
		this.SortOptions[4] = ["status","Status","S.Status"];
		this.SortOptions[5] = ["permissions","Permissions","ISNULL(COUNT(P.SectionID),0)"];
		
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

	<cffunction name="GetAdmins" returntype="query">
		<cfargument name="StartRow" type="numeric" default="1" />
		<cfargument name="EndRow" type="numeric" default="#REQUEST.Settings.RecordsPerPage#" /> 
		<cfargument name="FirstName" type="string" default="" />
		<cfargument name="LastName" type="string" default="" />
		<cfargument name="status" type="any" required="no" default="" />
		<cfargument name="sidx" type="string" required="no" default="#this.SortOptions[1][3]#" />
		<cfargument name="sord" type="string" required="no" default="#this.DefaultSord#" />
    	
		<cfset var loc_Admins = "" />
	
		<cfquery datasource="#request.dsource#" name="loc_Admins">
			SELECT		*
			FROM  (
					  
						SELECT			ROW_NUMBER() OVER ( ORDER BY #Arguments.sidx# ) AS RowNum,
										COUNT(*) OVER () as Row_Total,
										A.ID,
										A.FirstName, 
										A.LastName,
										CONVERT(CHAR(10),A.DateCreated,101) AS DateCreated,
										S.Status,
										ISNULL(COUNT(P.SectionID),0) AS SectionCount,
										SS.Total AS SectionTotal
						
						FROM			SiteAdmins A	
						JOIN			Status S ON A.Status = S.ID
						LEFT JOIN		SiteAdminPermissions P ON A.ID = P.AdminID
						LEFT JOIN		(SELECT COUNT(*) AS Total FROM SiteAdminSections) SS ON 1=1
						
						WHERE			1=1
					<CFIF Len(Arguments.FirstName)>
						AND				A.FirstName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.FirstName#%" />		
					</CFIF>
					<CFIF Len(Arguments.LastName)>
						AND				A.LastName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.LastName#%" />		
					</CFIF>
					<CFIF IsBoolean(Arguments.Status)>
						AND				A.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />		
					</CFIF>
					
						GROUP BY		A.ID,
										A.FirstName, 
										A.LastName,
										A.DateCreated,
										S.Status,
										SS.Total
			
			) AS RowConstrainedResult

			WHERE		RowNum >= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.StartRow#" />
			AND			RowNum <= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.EndRow#" />
			
			ORDER BY 	RowNum		
		</cfquery>
		
		<cfreturn loc_Admins />
		
	</cffunction>
    
	<cffunction name="GetAdminDetails" returntype="query" output="no" hint="I return the selected admin details">
		<cfargument name="AdminID" type="numeric" default="0" />
		
		<cfset var loc_AdminDetails = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_AdminDetails">
			SELECT		ID,
						FirstName, 
						LastName, 
						Username,
						Status
			FROM		SiteAdmins
			WHERE		ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AdminID#" />
		</cfquery>
		
		<cfreturn loc_AdminDetails />
	
	</cffunction>
	
	<cffunction name="UpdateAdmin" returntype="void">
		<cfargument name="AdminID" type="numeric" required="yes" />		
		<cfargument name="FirstName" type="string" required="yes" />
		<cfargument name="LastName" type="string" required="yes" />
		<cfargument name="Username" type="string" required="yes" />
		<cfargument name="Password" type="string" required="yes" />
		<cfargument name="Status" type="boolean" required="yes" />
		<cfargument name="Section" type="string" required="no" default="" />
		<cfargument name="ReturnUrl" type="string" required="yes" />
		
		<cfset var loc_AdminID = Arguments.AdminID />
		<cfset var loc_UpdateAdmin = "" />
		<cfset var loc_PW = Arguments.Password />
		<cfset var loc_HasNewPW = false />
		<cfset var loc_InsertSections = "" />
		<cfset var loc_thisSection = "" />
		<cfset var loc_StatusMessage = "" />
		
		<cfif LEN( loc_PW )>
			<cfset loc_HasNewPW = true />
		</cfif>
		
		<cfquery datasource="#request.dsource#" name="loc_UpdateAdmin">
			DECLARE @AdminID AS Int;

			SET @AdminID = (
				SELECT	ID
				FROM	SiteAdmins
				WHERE	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_AdminID#" />
			);
			
			IF @AdminID IS NULL
			
				BEGIN
		
					SET NOCOUNT ON
					
					INSERT INTO SiteAdmins (
						FirstName, 
						LastName, 
						Status, 
						Username, 
						Password,
						DateCreated
					) VALUES (
						 <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.FirstName#" />,
						 <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.LastName#" />,
						 <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />,
						 <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Username#" />,
						 <cfqueryparam cfsqltype="cf_sql_char" value="#loc_PW#" />,
						 GetDate()
						)
					 
					SELECT	@@IDENTITY AS NewID,
							'Administrator.Added' AS StatusMessage
					SET NOCOUNT OFF
				END
			ELSE
				BEGIN
		
					UPDATE	SiteAdmins
					
					SET		FirstName = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.FirstName#" />,
							LastName = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.LastName#" />,
							Status = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />,
							Username = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Username#" />,
							<cfif loc_HasNewPW>
								Password = <cfqueryparam cfsqltype="cf_sql_char" value="#loc_PW#" />,
							</cfif>
							DateModified = GetDate()					
							
					WHERE	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_AdminID#" />;
					
					SELECT	#loc_AdminID# AS NewID,
							'Administrator.Updated' AS StatusMessage
				END
		</cfquery>
		
		<cfset loc_AdminID = loc_UpdateAdmin.NewID />
		<cfset loc_StatusMessage = loc_UpdateAdmin.StatusMessage />
		
		<cfset DeleteAdminPermissions( AdminID:Arguments.AdminID ) />
		
		<cfif Len( Arguments.Section )>
			<cfquery datasource="#request.dsource#" name="loc_InsertSections">
				<cfloop list="#Arguments.Section#" index="loc_thisSection">
					INSERT INTO SiteAdminPermissions (
						AdminID,
						SectionID
					) VALUES (
						<cfqueryparam cfsqltype="cf_sql_integer" value="#loc_AdminID#" /> ,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#loc_thisSection#" /> 
					);
				</cfloop>
			</cfquery>
		</cfif>
		
		<cflocation url="#Arguments.ReturnUrl#&Message=#loc_StatusMessage#&AdminID=#loc_AdminID#" addtoken="no" />
    
    </cffunction>
    
    <cffunction name="DeleteAdmin" access="public" output="false" returntype="void">    
		<cfargument name="AdminID" type="numeric" required="yes" />		
		
		<cfset var loc_DeleteAdmin = "" />		
		<cfset DeleteAdminPermissions( AdminID:Arguments.AdminID ) />		
		
		<cfquery datasource="#request.dsource#" name="loc_DeleteAdmin">
			DELETE
			FROM		SiteAdmins
			WHERE		ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AdminID#" />
		</cfquery>
		
	</cffunction>
	
	<cffunction name="DeleteAdminPermissions" access="private" output="false" returntype="void">
		<cfargument name="AdminID" type="numeric" required="yes" />
		
		<cfset var loc_DeleteAdminPermissions = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_DeleteAdminPermissions">
			DELETE
			FROM		SiteAdminPermissions
			WHERE		AdminID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AdminID#" />
		</cfquery>		
	</cffunction>

</cfcomponent>