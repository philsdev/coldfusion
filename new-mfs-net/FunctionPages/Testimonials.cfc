<cfcomponent hint="This component will handle editing site administrators" extends="MachII.framework.Listener">

	<cfscript>
		this.SortOptions = ArrayNew(1);
		
		this.SortOptions[1] = ["firstname","First Name","FirstName"];
		this.SortOptions[2] = ["lastname","Last Name","LastName"];		
		this.SortOptions[3] = ["datecreated","Date Created","DateCreated"];
		this.SortOptions[4] = ["Location","Location","Location"];
		this.SortOptions[5] = ["isapproved","Approved","IsApproved"];
		
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

	<cffunction name="GetAccounts" returntype="query">
	
		<cfset var loc_Accts = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_Accts">
			SELECT			A.BillFirstName,
							A.BillLastName,
							A.AccountID
			
			FROM			Accounts A
			
			WHERE			A.BillLastName <> ''
			
			ORDER BY		A.BillLastName
		</cfquery>
		
		<cfreturn loc_Accts />	
	</cffunction>

	<cffunction name="GetDisplayTestimonials" returntype="query">
		<cfargument name="TopCount" type="numeric" default="5" />
		
		<cfset var loc_Testimonials = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_Testimonials">
			SELECT			TOP #Arguments.TopCount# TestimonialID,
							FirstName AS FirstName,
							LastName AS LastName,
							Description
			
			FROM			Testimonials 
			
			WHERE			IsApproved = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
			
			ORDER BY		DateCreated DESC
		</cfquery>
		
		<cfreturn loc_Testimonials />	
	</cffunction>


	<cffunction name="GetTestimonials" returntype="query">
		<cfargument name="StartRow" type="numeric" default="1" />
		<cfargument name="EndRow" type="numeric" default="#REQUEST.Settings.RecordsPerPage#" /> 
		<cfargument name="FirstName" type="string" default="" />
		<cfargument name="LastName" type="string" default="" />
		<cfargument name="Location" type="string" default="" />
		<cfargument name="DateCreated" type="string" default="" />
		<cfargument name="IsApproved" type="any" required="no" default="" />
		<cfargument name="sidx" type="string" required="no" default="#this.SortOptions[1][3]#" />
		<cfargument name="sord" type="string" required="no" default="#this.DefaultSord#" />
    	
		<cfset var loc_Testimonials = "" />
	
		<cfquery datasource="#request.dsource#" name="loc_Testimonials">
			SELECT		*
			FROM  (
					  
						SELECT			ROW_NUMBER() OVER ( ORDER BY #Arguments.sidx# #Arguments.sord# ) AS RowNum,
										COUNT(*) OVER () as Row_Total,
										FirstName, 
										LastName,
										TestimonialID, 
										IsApproved, 
										DateCreated,
										Location						
						FROM			Testimonials
						
						WHERE			1=1
						
					<CFIF Len(Arguments.FirstName)>
						AND				FirstName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.FirstName#%" />		
					</CFIF>
					<CFIF Len(Arguments.LastName)>
						AND				LastName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.LastName#%" />		
					</CFIF>
					<CFIF IsBoolean(Arguments.IsApproved)>
						AND				IsApproved = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.IsApproved#" />		
					</CFIF>
							
			) AS RowConstrainedResult

			WHERE		RowNum >= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.StartRow#" />
			AND			RowNum <= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.EndRow#" />
			
			ORDER BY 	RowNum		
		</cfquery>
		
		<cfreturn loc_Testimonials />
		
	</cffunction>
    
	<cffunction name="GetTestimonialDetails" returntype="query" output="no" hint="I return the selected Testimonial details">
		<cfargument name="TestimonialID" type="numeric" default="0" />
		
		<cfset var loc_TestimonialDetails = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_TestimonialDetails">
			SELECT	FirstName, 
					LastName,
					AccountID, 
					TestimonialID, 
					Description, 
					IsApproved, 
					DateCreated, 
					DateModified,
					Location	
			FROM	Testimonials
			WHERE 	TestimonialID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.TestimonialID#" />
			
		</cfquery>
		
		<cfreturn loc_TestimonialDetails />
	
	</cffunction>
	
	
	<cffunction name="UpdateTestimonial" returntype="void">
		<cfargument name="TestimonialID" type="numeric" required="yes" />		
		<cfargument name="Description" type="string" required="yes" />
		<cfargument name="IsApproved" type="boolean" required="yes" />		
		<cfargument name="ReturnUrl" type="string" required="yes" />
		<cfargument name="FirstName" type="string" default="yes" />
		<cfargument name="LastName" type="string" default="yes" />
		<cfargument name="Location" type="string" default="no" />
		<cfargument name="FrontEnd" type="boolean" default="0" />
		
		<cfset var loc_TestimonialID = Arguments.TestimonialID />
		<cfset var loc_UpdateTestimonial = "" />
		<cfset var loc_StatusMessage = "" />
		
			
		<cfquery datasource="#request.dsource#" name="loc_UpdateTestimonial">
			DECLARE @TestimonialID AS Int;

			SET @TestimonialID = (
				SELECT	TestimonialID
				FROM	Testimonials
				WHERE	TestimonialID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_TestimonialID#" />
			);
			
			IF @TestimonialID IS NULL
			
				BEGIN
		
					SET NOCOUNT ON
					
					INSERT INTO Testimonials (
						Description, 
						IsApproved,
						DateCreated,
						FirstName, 	
						LastName,
						Location
					) VALUES (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Description#" />,
						<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.IsApproved#" />,
						GetDate(),
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.FirstName#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.LastName#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Location#">
						)
					 
					SELECT	@@IDENTITY AS NewID,
							'Testimonial.Added' AS StatusMessage
					SET NOCOUNT OFF
				END
			ELSE
				BEGIN
		
					UPDATE	Testimonials
					
					SET		Description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Description#" />,
							IsApproved = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.IsApproved#" />, 
							DateModified = GetDate(),
							FirstName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.FirstName#">,
							LastName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.LastName#">,
							Location = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Location#">
					WHERE	TestimonialID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_TestimonialID#" />;
					
					SELECT	#loc_TestimonialID# AS NewID,
							'Testimonial.Updated' AS StatusMessage
				END
		</cfquery>
		
		<cfset loc_TestimonialID = loc_UpdateTestimonial.NewID />
		<cfset loc_StatusMessage = loc_UpdateTestimonial.StatusMessage />
	
		<cfif FrontEnd NEQ 1>
			<cflocation url="#Arguments.ReturnUrl#&Message=#loc_StatusMessage#&TestimonialID=#loc_TestimonialID#" addtoken="no" />
    	</cfif>	

	</cffunction>

	
	<cffunction name="DeleteTestimonial" returntype="void">
		<cfargument name="TestimonialID" type="numeric" required="yes" />	
		
			<cfquery datasource="#request.dsource#" name="loc_UpdateTestimonial">
				DELETE 
				FROM Testimonials
				WHERE	TestimonialID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.TestimonialID#" />
			</cfquery>
	
			<cfset loc_StatusMessage = "Testimonial.Delete" />
			
			<cflocation url="#Arguments.ReturnUrl#&Message=#loc_StatusMessage#" addtoken="no" />
	</cffunction>
</cfcomponent>