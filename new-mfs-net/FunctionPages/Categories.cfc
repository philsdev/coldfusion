<cfcomponent extends="MachII.framework.Listener">

	<cfscript>
		this.SortOptions = ArrayNew(1);
		
		this.SortOptions[1] = ["categoryname","Category Name","C.CategoryName"];
		this.SortOptions[2] = ["status","Status","S.Status"];
		
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

	<cffunction name="GetDisplayCategories" returntype="query">
		<cfargument name="ParentID" default="" />		
    	
		<cfset var loc_DisplayCategories = "" />
	
		<cfquery datasource="#request.dsource#" name="loc_DisplayCategories">					  
			SELECT			C.CategoryID,
							C.CategoryName
			
			FROM			Categories C
			JOIN			Status S ON C.CategoryStatus = S.ID
			
			WHERE			1=1
		<cfif IsNumeric(Arguments.ParentID)>
			AND				C.ParentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ParentID#" />		
		</cfif>
		<cfif Request.IsFrontEnd>
			AND				C.CategoryStatus = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />		
		</cfif>
			
			ORDER BY 		C.DisplayPosition
		</cfquery>
		
		<cfreturn loc_DisplayCategories />		
	</cffunction>
	
	<cffunction name="GetParentCategories" returntype="query">
    	
		<cfset var loc_ParentCategories = "" />
	
		<cfquery datasource="#request.dsource#" name="loc_ParentCategories">					  
			SELECT			C.CategoryID AS ParentCategoryID,
							C.CategoryID,
							C.CategoryName,
							C.DisplayPosition,				
							1 AS IsParent

			FROM			Categories C
			WHERE			C.ParentID = <cfqueryparam cfsqltype="cf_sql_integer" value="0" />	

			UNION

			SELECT			C.ParentID AS ParentCategoryID,
							
							C.CategoryID,
							' --- ' + C.CategoryName AS CategoryName,
							C.DisplayPosition,
							0 AS IsParent

			FROM			Categories C
			WHERE			C.ParentID IN (
								SELECT		CategoryID
								FROM		Categories
								WHERE		ParentID = <cfqueryparam cfsqltype="cf_sql_integer" value="0" />	
							)
						
			ORDER BY		ParentCategoryID,	
							IsParent DESC,
							DisplayPosition
		</cfquery>
		
		<cfreturn loc_ParentCategories />		
	</cffunction>
	
	<cffunction name="GetCategories" access="public" output="no" returntype="query">
		<cfargument name="Status" default="" />	
		<cfset var loc_Categories = "" />
	
		<cfquery datasource="#request.dsource#" name="loc_Categories">					  
			SELECT			C1.CategoryID AS Category1ID,
							C1.CategoryName AS Category1Name,
							S1.Status AS Status1,
							CASE
								WHEN C2.CategoryID IS NOT NULL
								THEN COUNT(C1.CategoryID) OVER(PARTITION BY C1.CategoryID)
								ELSE 0
							END as Level1Count,
							C2.ParentID AS Category2Parent,
							C2.CategoryID AS Category2ID,
							C2.CategoryName AS Category2Name,
							' --- ' + C2.CategoryName AS Category2NameIndent,
							S2.Status AS Status2,
							CASE
								WHEN C3.CategoryID IS NOT NULL
								THEN COUNT(C2.CategoryID) OVER(PARTITION BY C2.CategoryID)
								ELSE 0
							END as Level2Count,
							C3.ParentID AS Category3Parent,
							' ------ ' + C3.CategoryName AS Category3NameIndent,
							C3.CategoryID AS Category3ID,
							C3.CategoryName AS Category3Name,
							S3.Status AS Status3

			FROM			Categories C1
			
			JOIN			[Status] S1 ON C1.CategoryStatus = S1.ID

			LEFT JOIN		Categories C2 ON C1.CategoryID = C2.ParentID
		<cfif IsBoolean( Arguments.Status )>
			AND				C2.CategoryStatus = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />
		</cfif>
		
			LEFT JOIN		[Status] S2 ON C2.CategoryStatus = S2.ID

			LEFT JOIN		Categories C3 ON C2.CategoryID = C3.ParentID
		<cfif IsBoolean( Arguments.Status )>
			AND				C3.CategoryStatus = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />
		</cfif>
			
			LEFT JOIN		[Status] S3 ON C3.CategoryStatus = S3.ID

			WHERE			C1.ParentID = <cfqueryparam cfsqltype="cf_sql_integer" value="0" />
		<cfif IsBoolean( Arguments.Status )>
			AND				C1.CategoryStatus = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />
		</cfif>

			ORDER BY 		C1.CategoryID,
							C2.CategoryID,
							C3.CategoryID
		</cfquery>
		
		<cfreturn loc_Categories />		
	</cffunction>
	
	<cffunction name="GetCategoryDetails" access="public" output="no" returntype="query">
		<cfargument name="CategoryID" default="0" />	
		
		<cfset var loc_CategoryDetails = "" />
	
		<cfquery datasource="#request.dsource#" name="loc_CategoryDetails">					  
			SELECT			CategoryID,
							CategoryName,
							CategoryDesc,
							CategoryStatus,
							ImageName,
							ParentID,
							DisplayPosition

			FROM			Categories

			WHERE			CategoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.CategoryID#" />
		</cfquery>
		
		<cfreturn loc_CategoryDetails />		
	</cffunction>
	
	<cffunction name="UpdateCategory" returntype="void">
		<cfargument name="CategoryID" type="numeric" required="yes" />		
		<cfargument name="CategoryName" type="string" required="yes" />
		<cfargument name="CategoryDescription" type="string" required="yes" />
		<cfargument name="CategoryParent" default="" />
		<cfargument name="DisplayPosition" type="numeric" required="yes" />		
		<cfargument name="CategoryImageUpload" type="string" default="" />
		<cfargument name="Status" type="boolean" required="yes" />		
		<cfargument name="ReturnUrl" type="string" required="yes" />
		
		<cfset var loc_CategoryID = Arguments.CategoryID />
		<cfset var loc_ParentID = Arguments.CategoryParent />
		<cfset var loc_UpdateCategory = "" />
		<cfset var loc_StatusMessage = "" />
		<cfset var loc_ImageFilePath = REQUEST.Root.Server.Image.Category />
		<cfset var loc_ImageFileName = "" />
		<cfset var loc_ImageFileExtension = "" />
		<cfset var loc_ImageFileFullName = "" />
		<cfset var loc_ImageFullPath = "" />
		<cfset var loc_ImageManager = Request.ListenerManager.GetListener( "ImageManager" ) />
		
		<cfif NOT Isnumeric( loc_ParentID )>
			<cfset loc_ParentID = 0 />
		</cfif>
		
		<!--- item image was uploaded --->
		<cfif len(Arguments.CategoryImageUpload)>
			
			<!--- upload user file (as-is) --->
			<cffile action="upload" filefield="CategoryImageUpload" destination="#loc_ImageFilePath#" nameconflict="overwrite" />
			
			<cfset loc_ImageFileName = CFFILE.ClientFileName />
			<cfset loc_ImageFileExtension = CFFILE.ClientFileExt />
			<cfset loc_ImageFileFullName = loc_ImageFileName & "." & loc_ImageFileExtension />
			<cfset loc_ImageFullPath = loc_ImageFilePath & loc_ImageFileFullName />
			
			<!--- delete upload if it's not the proper type (and somehow makes it past front-end validation) --->
			<cfif NOT ListFindNoCase( REQUEST.Image.ValidExtensionList, loc_ImageFileExtension, "|" )>				
				<cffile action="delete" file="#loc_ImageFullPath#" />				
				<cfthrow message="Image type not supported" />						
			</cfif>
		
			<!--- create image variations --->
			<cfset loc_ImageManager.CreateImageVariations(
				Filename:loc_ImageFileFullName,
				ImageCategory:'Category'
			) />
		
		</cfif>		
		
		<cfquery datasource="#request.dsource#" name="loc_UpdateCategory">
			DECLARE @CategoryID AS Int;

			SET @CategoryID = (
				SELECT	CategoryID
				FROM	Categories
				WHERE	CategoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_CategoryID#" />
			);
			
			IF @CategoryID IS NULL
			
				BEGIN
		
					SET NOCOUNT ON
					
					INSERT INTO Categories (
						CategoryName, 
						CategoryDesc, 
						CategoryStatus, 
						ImageName,
						ParentID, 
						DisplayPosition
					) VALUES (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CategoryName#" maxlength="255" />,
						<cfqueryparam cfsqltype="cf_sql_text" value="#Arguments.CategoryDescription#" />,
						<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#loc_ImageFileFullName#" NULL="#NOT(LEN(loc_ImageFileFullName))#" />,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#loc_ParentID#" />,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.DisplayPosition#" />
					)
					 
					SELECT	@@IDENTITY AS NewID,
							'Category.Added' AS StatusMessage
					SET NOCOUNT OFF
				END
			ELSE
				BEGIN
		
					UPDATE	Categories
					
					SET		CategoryName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CategoryName#" maxlength="255" />,
							CategoryDesc = <cfqueryparam cfsqltype="cf_sql_text" value="#Arguments.CategoryDescription#" />, 
							CategoryStatus = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />, 
						<cfif LEN(loc_ImageFileFullName)>
							ImageName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#loc_ImageFileFullName#" />,
						</cfif>
							ParentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_ParentID#" />,
							DisplayPosition = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.DisplayPosition#" />
							
					WHERE	CategoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_CategoryID#" />;
					
					SELECT	#loc_CategoryID# AS NewID,
							'Category.Updated' AS StatusMessage
				END
		</cfquery>
		
		<cfset loc_CategoryID = loc_UpdateCategory.NewID />
		<cfset loc_StatusMessage = loc_UpdateCategory.StatusMessage />
		
		<cflocation url="#Arguments.ReturnUrl#&Message=#loc_StatusMessage#&CategoryID=#loc_CategoryID#" addtoken="no" />
    
    </cffunction>
	
	<cffunction name="DeleteCategory" access="public" output="false" returntype="void">    
		<cfargument name="CategoryID" type="numeric" required="yes" />		
		
		<cfset var loc_DeleteCategory = "" />		
		
		<cfquery datasource="#request.dsource#" name="loc_DeleteCategory">
			DELETE
			FROM		Categories
			WHERE		CategoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.CategoryID#" />
		</cfquery>
		
	</cffunction>

	<cffunction name="GetCategoryAssociation" access="public" output="no" returntype="query">    
		<cfargument name="ProductID" type="numeric" required="yes" />		
		
		<cfset var loc_GetCategoryAssociation = "" />		
		
		<cfquery datasource="#request.dsource#" name="loc_GetCategoryAssociation">
			SELECT 	CP.CategoryID,CA.CategoryName
			FROM 	CategoryProductAssoc CP Left Join Categories CA
			ON 		CP.CategoryID = CA.CategoryID
			WHERE	productID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ProductID#" />
		</cfquery>
		
		<cfreturn loc_GetCategoryAssociation />	
		
	</cffunction>
	
	<cffunction name="GetCategoryProducts" access="public" output="no" returntype="query">    
		<cfargument name="CategoryID" type="numeric" required="yes" />		
		
		<cfset var loc_GetCategoryProducts = "" />		
		
		<cfquery datasource="#request.dsource#" name="loc_GetCategoryProducts">
		
			SELECT 	CP.CategoryID, P.ProductID, P.ProductName
			FROM 	CategoryProductAssoc CP Left Join Products P
			ON 		CP.ProductID = P.ProductID
			WHERE	CP.CategoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.CategoryID#" /> 
			ORDER BY P.ProductName
		</cfquery>
		
		<cfreturn loc_GetCategoryProducts />	
		
	</cffunction>
	
	<cffunction name="GetCategoryFeatured" access="public" output="no" returntype="query">    
		<cfargument name="CategoryID" type="numeric" required="yes" />		
		
		<cfset var loc_GetCategoryFeatured = "" />		
		
		<cfquery datasource="#request.dsource#" name="loc_GetCategoryFeatured">
			SELECT 		CF.CategoryFeaturedID, CF.CategoryID, CF.ProductID, CF.DisplayPosition, P.ProductName
			FROM 		CategoryFeatured CF Left Join Products P
			ON	 		CF.ProductID = P.ProductID
			WHERE 		CF.CategoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.CategoryID#" /> 
			ORDER BY 	CF.DisplayPosition
		</cfquery>
		
		<cfreturn loc_GetCategoryFeatured />	
		
	</cffunction>
	
	<cffunction name="UpdateProductFeatures" returntype="void" output="no">		
		<cfargument name="CategoryID" type="numeric" required="yes" />
		<cfargument name="SelectedProductID" type="string" required="yes" />
		<cfargument name="ReturnUrl" type="string" required="no" />
		
		<cfset var loc_AvailableProducts = "" />
		<cfset var loc_CategoryID = Arguments.CategoryID />
		<cfset var loc_ProductIDList = "" />
		<cfset var loc_ThisProductID = "" />
		<cfset var loc_ThisProductCount = 0 />
		
		<!--- reduce possible dupes --->
		<cfloop list="#Arguments.SelectedProductID#" index="loc_ThisProductID">
			<cfif NOT ListFind( loc_ProductIDList, loc_ThisProductID )>
				<cfset loc_ProductIDList = ListAppend( loc_ProductIDList, loc_ThisProductID ) />
			</cfif>
		</cfloop>
		
		<cfquery datasource="#request.dsource#" name="loc_AvailableProducts">
			DELETE
			FROM		CategoryFeatured
			WHERE		CategoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_CategoryID#" />;
		
			<cfloop list="#loc_ProductIDList#" index="loc_ThisProductID">
				<cfset loc_ThisProductCount = IncrementValue( loc_ThisProductCount ) />
				
				INSERT INTO CategoryFeatured (
					CategoryID,
					ProductID,
					DisplayPosition
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#loc_CategoryID#" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#loc_ThisProductID#" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#loc_ThisProductCount#" />
				);
			</cfloop>
		</cfquery>
		
		
		<cfset loc_StatusMessage = "Feature.Updated" />
		
				
		<cflocation url="#Arguments.ReturnUrl#&Message=#loc_StatusMessage#&CategoryID=#loc_CategoryID#" addtoken="no" />
		
	</cffunction>
	
	
	<cffunction name="GetHomePageCategoryFeatures" returntype="query" output="no">
	
		<cfset var loc_CategoryFeatures = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_CategoryFeatures">
			SELECT 		FC.FeatureID, 
						FC.CategoryID, 
						FC.DisplayPosition, 
						C.CategoryName,
						C.ImageName
			FROM 		HomepageFeaturedCategory FC 
			LEFT JOIN 	Categories C ON FC.CategoryID = C.CategoryID
			ORDER BY 	FC.DisplayPosition
		</cfquery>
		
		<cfreturn loc_CategoryFeatures />	
	</cffunction>
	
</cfcomponent>