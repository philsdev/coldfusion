<cfcomponent hint="This component will handle editing site administrators" extends="MachII.framework.Listener">

	<cfscript>
		this.SortOptions = ArrayNew(1);
		
		this.SortOptions[1] = ["vendorname","Vendor Name","V.VendorName"];
		this.SortOptions[2] = ["productcount","Products","ISNULL(TOTALS.SubTotal,0)"];
		this.SortOptions[3] = ["status","Status","S.Status"];
		
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
	
	<cffunction name="GetDisplayVendors" access="public" output="no" returntype="query">
		<cfargument name="CategoryID" default="" />
    	
		<cfset var loc_DisplayVendors = "" />
	
		<cfquery datasource="#request.dsource#" name="loc_DisplayVendors">					  
			SELECT			V.VendorID,
							V.VendorName
			
			FROM			Vendors V			
			JOIN			Status S ON V.VendorStatus = S.ID			
		
			WHERE			1=1
			<cfif Request.IsFrontEnd>
				AND			V.VendorStatus = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />		
			</cfif>
			<cfif IsNumeric( Arguments.CategoryID )>
				AND			V.VendorID IN (
								SELECT		VendorID
								FROM		Products
								WHERE		ProductDeleted = 0
								AND			ProductStatus = 1
								AND			ProductID IN (
												SELECT			ProductID
												FROM			CategoryProductAssoc
												WHERE			CategoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.CategoryID#" />
											)
							)
			</cfif>
			
			ORDER BY 		V.VendorName
		</cfquery>
		
		<cfreturn loc_DisplayVendors />
		
	</cffunction>
	
	<cffunction name="GetVendors" returntype="query">
		<cfargument name="StartRow" type="numeric" default="1" />
		<cfargument name="EndRow" type="numeric" default="#REQUEST.Settings.RecordsPerPage#" /> 
		<cfargument name="VendorName" type="string" default="" />
		<cfargument name="VendorStatus" type="any" required="no" default="" />
		<cfargument name="sidx" type="string" required="no" default="#this.SortOptions[1][3]#" />
		<cfargument name="sord" type="string" required="no" default="#this.DefaultSord#" />
    	
		<cfset var loc_Vendors = "" />
	
		<cfquery datasource="#request.dsource#" name="loc_Vendors">
			SELECT		*
			FROM  (
					  
						SELECT			ROW_NUMBER() OVER ( ORDER BY #Arguments.sidx# #Arguments.sord# ) AS RowNum,
										COUNT(*) OVER () as Row_Total,
										V.VendorID,
										V.VendorName,	
										ISNULL(TOTALS.SubTotal,0) AS ProductCount,
										S.Status
						
						FROM			Vendors V
						JOIN			Status S ON V.VendorStatus = S.ID
						LEFT JOIN		(
											SELECT		VendorID,
														COUNT(*) AS SubTotal
											FROM		Products
											GROUP BY	VendorID
						
										) TOTALS ON V.VendorID = TOTALS.VendorID
						
						WHERE			1=1
						
					<CFIF Len(Arguments.VendorName)>
						AND				V.VendorName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.VendorName#%" />		
					</CFIF>
					<CFIF IsBoolean(Arguments.VendorStatus)>
						AND				P.VendorStatus = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.VendorStatus#" />		
					</CFIF>
			
			) AS RowConstrainedResult

			WHERE		RowNum >= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.StartRow#" />
			AND			RowNum <= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.EndRow#" />
			
			ORDER BY 	RowNum		
		</cfquery>
		
		<cfreturn loc_Vendors />
		
	</cffunction>
	
	<cffunction name="GetVendorDetails" returntype="query" output="no">
		<cfargument name="VendorID" type="numeric" default="0" />
		
		<cfset var loc_VendorDetails = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_VendorDetails">
			SELECT		VendorID,
						VendorName, 
						VendorStatus
			FROM		Vendors
			WHERE		VendorID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.VendorID#" />
		</cfquery>
		
		<cfreturn loc_VendorDetails />
	
	</cffunction>
	
	<cffunction name="UpdateVendor" returntype="void">
		<cfargument name="VendorID" default="0" />		
		<cfargument name="VendorName" type="string" required="yes" />
		<cfargument name="Status" type="boolean" required="yes" />
		<cfargument name="ReturnUrl" type="string" required="yes" />
		
		<cfset var loc_VendorID = Arguments.VendorID />
		<cfset var loc_UpdateVendor = "" />
		<cfset var loc_StatusMessage = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_UpdateVendor">
			DECLARE @VendorID AS Int;

			SET @VendorID = (
				SELECT	VendorID
				FROM	Vendors
				WHERE	VendorID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_VendorID#" />
			);
			
			IF @VendorID IS NULL
			
				BEGIN
		
					SET NOCOUNT ON
					
					INSERT INTO Vendors (
						VendorName, 
						VendorStatus
					) VALUES (
						 <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.VendorName#" />,
						 <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />
					)
					 
					SELECT	@@IDENTITY AS NewID,
							'Vendor.Added' AS StatusMessage
					SET NOCOUNT OFF
				END
			ELSE
				BEGIN
		
					UPDATE	Vendors
					
					SET		VendorName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.VendorName#" />,
							VendorStatus = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />
							
					WHERE	VendorID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_VendorID#" />;
					
					SELECT	#loc_VendorID# AS NewID,
							'Vendor.Updated' AS StatusMessage
				END
		</cfquery>
		
		<cfset loc_VendorID = loc_UpdateVendor.NewID />
		<cfset loc_StatusMessage = loc_UpdateVendor.StatusMessage />
		
		<cflocation url="#Arguments.ReturnUrl#&Message=#loc_StatusMessage#&VendorID=#loc_VendorID#" addtoken="no" />
    
    </cffunction>
	
	<cffunction name="DeleteVendor" access="public" output="false" returntype="void">    
		<cfargument name="VendorID" type="numeric" required="yes" />		
		
		<cfset var loc_DeleteVendor = "" />		
		
		<cfquery datasource="#request.dsource#" name="loc_DeleteVendor">
			DELETE
			FROM		Vendors
			WHERE		VendorID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.VendorID#" />
		</cfquery>
		
	</cffunction>

</cfcomponent>