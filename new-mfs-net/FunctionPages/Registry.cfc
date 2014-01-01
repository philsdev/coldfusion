<cfcomponent extends="MachII.framework.Listener">

	<cfscript>
		this.SortOptions = ArrayNew(1);
		
		this.SortOptions[1] = ["BillFirstname","First Name","A.BillFirstname"];
		this.SortOptions[2] = ["BillLastName","Last Name","A.BillLastName"];		
		this.SortOptions[3] = ["Create_Date","Date Created","R.Create_Date"];
		this.SortOptions[4] = ["event_date","Event Date","R.event_date"];
		this.SortOptions[5] = ["registry_code","Registry Code","R.registry_code"];
		
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

	<cffunction name="GetRegistry" returntype="query">
		<cfargument name="StartRow" type="numeric" default="1" />
		<cfargument name="EndRow" type="numeric" default="#REQUEST.Settings.RecordsPerPage#" /> 
		<cfargument name="FirstName" type="string" default="" />
		<cfargument name="LastName" type="string" default="" />
		<cfargument name="Registry_Code" type="string" default="" />
		<cfargument name="Create_Date" type="string" default="" />
		<cfargument name="Event_Date" type="string" default="" />
		<cfargument name="sidx" type="string" required="no" default="#this.SortOptions[2][3]#" />
		<cfargument name="sord" type="string" required="no" default="#this.DefaultSord#" />
    	
		<cfset var loc_Registry = "" />

		<cfquery datasource="#request.dsource#" name="loc_Registry">
			SELECT		*
			FROM  (
					  
						SELECT			ROW_NUMBER() OVER ( ORDER BY #Arguments.sidx# #Arguments.sord# ) AS RowNum,
										COUNT(*) OVER () as Row_Total,
										R.Registry_ID as RegistryID,
										A.BillFirstname,
										A.BillLastName,
										R.registry_code,
										R.Create_Date,
										R.event_date,
										R.Registry_Type_catalog_ID,
										C.catalog_code AS registry_type_code,
										R.Registry_name,
										R.Active_Flag
						
						FROM			AMP_registry R Left Join Accounts A
						ON 				R.AccountID = A.AccountID
						LEFT JOIN		AMP_CATALOG C ON R.registry_type_catalog_id = C.catalog_id

						
						WHERE			1=1		
						
					<CFIF Len(Arguments.FirstName)>
						AND				BillFirstname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.BillFirstname#%" />		
					</CFIF>
					<CFIF Len(Arguments.LastName)>
						AND				BillLastName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.BillLastName#%" />		
					</CFIF>
					<CFIF Len(Arguments.Registry_Code)>
						AND				Registry_Code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Registry_Code#" />		
					</CFIF>
					<cfif LEN( Arguments.Create_Date )>
						AND				R.Create_Date  >  <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Create_Date#">
						AND				R.Create_Date  <  <cfqueryparam cfsqltype="cf_sql_date" value="#dateAdd('d',  '1',  Arguments.Create_Date)#">
					</cfif>
					<cfif LEN( Arguments.Event_Date )>
						AND				R.Event_Date  >  <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Event_Date#">
						AND				R.Event_Date  <  <cfqueryparam cfsqltype="cf_sql_date" value="#dateAdd('d',  '1',  Arguments.Event_Date)#">
					</cfif>
			
			) AS RowConstrainedResult

			WHERE		RowNum >= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.StartRow#" />
			AND			RowNum <= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.EndRow#" />
			
			ORDER BY 	RowNum		
		</cfquery>
		
		<cfreturn loc_Registry />
		
	</cffunction>
	
	
	<cffunction name="GetRegistryDetails" returntype="query" output="no" hint="I return the selected Registry details">
		<cfargument name="RegistryID" type="numeric" default="0" />
		
		<cfset var loc_RegistryDetails = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_RegistryDetails">
						SELECT		A.BillFirstname,
									A.BillLastName,
									A.EmailAddress,
									R.Registry_ID as RegistryID,
									R.registry_code,
									R.Create_Date,
									R.event_date,
									R.Registry_Name,
									R.Registry_Type_catalog_ID,
									C.catalog_code AS registry_type_code
							
						
						FROM		AMP_registry R Left Join Accounts A
						ON 			R.AccountID = A.AccountID
						LEFT JOIN		AMP_CATALOG C ON R.registry_type_catalog_id = C.catalog_id
						WHERE		R.REGISTRY_ID = <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.RegistryID#" />
		
		</cfquery>
		
		<cfreturn loc_RegistryDetails />
	
	</cffunction>
	
	<cffunction name="GetRegistryByAccount" returntype="query" output="no" hint="I return list of Registries for specific accounts">
		<cfargument name="UserID" type="numeric" default="0" />
		
		<cfset var loc_RegistryDetails = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_RegistryDetails">
						SELECT		R.Registry_ID as Registry_ID,
									R.registry_code,
									R.Create_Date,
									R.event_date,
									R.Registry_Name,
									R.Registry_Type_catalog_ID
							
						
						FROM		AMP_registry R Left Join Accounts A
						ON 			R.AccountID = A.AccountID
						WHERE		A.AccountID = <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.UserID#" />
		
		</cfquery>
		
		<cfreturn loc_RegistryDetails />
	
	</cffunction>
	
	<cffunction name="GetRegistryItems" returntype="query" output="no" hint="I return list of Items for specific registry">
		<cfargument name="RegistryID" type="numeric" default="0" />
		
		<cfset var loc_RegistryDetails = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_RegistryDetails">
		SELECT 	R.Registry_ID, 
				R.accountID, 
				RI.Registry_Item_ID, 
				RI.Registry_ID, 
				RI.ProductID, 
				RI.qty_want, 
				RI.qty_have, 
				RI.Create_date, 
				RIO.registry_item_option_ID, 
				P.ProductName, 
				P.ProductOurPrice,
				RIO.Option_groupID,
				PIM.ImageName, 
				PO.OptionName,
				PA.ProductAttributeName
		FROM 	AMP_registry R Left JOIN 
				AMP_registry_item RI 
				ON R.Registry_ID = RI.Registry_ID
		LEFT JOIN AMP_registry_item_option RIO
		ON 		RI.registry_item_ID = RIO.registry_item_ID
		JOIN 	Products P 
		ON 		RI.ProductID = P.ProductID
		LEFT JOIN productImages PIM 
		ON 		P.ProductID = PIM.ProductID
		LEFT JOIN productOptions PO
		ON 		RIO.optionID = PO.OptionID
		LEFT JOIN ProductAttributes PA
		ON 		RIO.Option_groupID = PA.ProductAttributeID
		where 	R.Registry_ID = <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.RegistryID#" />
		order by RI.Registry_Item_ID
		</cfquery>
		
		<cfreturn loc_RegistryDetails />
	
	</cffunction>
</cfcomponent>