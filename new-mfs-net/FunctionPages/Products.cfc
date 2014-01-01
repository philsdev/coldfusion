<cfcomponent hint="This component will handle editing site administrators" extends="MachII.framework.Listener">

	<cfscript>
		this.SortOptions = ArrayNew(1);
		
		this.SortOptions[1] = ["productname","Product Name","P.ProductName"];
		this.SortOptions[2] = ["productitemnumber","Item Number","P.ProductItemNumber"];
		this.SortOptions[3] = ["vendorname","Vendor","V.VendorName"];
		this.SortOptions[4] = ["datecreated","Date Created","P.DateInserted"];
		this.SortOptions[5] = ["status","Status","S.Status"];
		
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

	<cffunction name="GetProducts" returntype="query">
		<cfargument name="StartRow" type="numeric" default="1" />
		<cfargument name="EndRow" type="numeric" default="#REQUEST.Settings.RecordsPerPage#" /> 
		<cfargument name="ProductName" type="string" default="" />
		<cfargument name="ProductItemNumber" type="string" default="" />
		<cfargument name="ProductCategory" type="string" default="" />
		<cfargument name="ProductFeaturedCategory" type="string" default="" />
		<cfargument name="ProductVendor" type="string" default="" />
		<cfargument name="ProductPriceID" type="string" default="" />		
		<cfargument name="Description" type="string" default="" />
		<cfargument name="ProductKeywords" type="string" default="" />
		<cfargument name="SearchString" type="string" default="" />
		<cfargument name="Status" type="any" required="no" default="" />
		<cfargument name="ImageTypeID" type="string" default="1" />
		
		<cfargument name="sidx" type="string" required="no" default="#this.SortOptions[1][3]#" />
		<cfargument name="sord" type="string" required="no" default="#this.DefaultSord#" />
    	
		<cfset var loc_Products = "" />
		<cfset var loc_CategoryIndex = "" />
		<cfset var loc_ThisSelection = "" />		
		<cfset var loc_CategorySelectionList = Arguments.ProductCategory />
		<cfset var loc_CategorySelectionListLength = ListLen( loc_CategorySelectionList ) />		
		<cfset var loc_CategorySelection = "" />
		
		<cfloop from="#loc_CategorySelectionListLength#" to="1" step="-1" index="loc_CategoryIndex">
			<cfset loc_ThisSelection = ListGetAt( loc_CategorySelectionList, loc_CategoryIndex ) />
			<cfif IsNumeric( loc_ThisSelection )>
				<cfset loc_CategorySelection = loc_ThisSelection />
				<cfbreak />
			</cfif>
		</cfloop>
	
		<cfquery datasource="#request.dsource#" name="loc_Products">
			SELECT		*
			FROM  (
					  
						SELECT			ROW_NUMBER() OVER ( ORDER BY #Arguments.sidx# #Arguments.sord# ) AS RowNum,
										COUNT(*) OVER () as Row_Total,
										P.ProductID,
										P.ProductName, 
										P.ProductItemNumber,
										P.ProductOurPrice,
										P.ProductDiscountPrice,
										CASE
											WHEN P.ProductDiscountPrice > 0 
											THEN P.ProductDiscountPrice
											ELSE P.ProductOurPrice
										END AS ProductPrice,
										CONVERT(CHAR(10),P.DateInserted,101) AS DateCreated,
										V.VendorName,
										PI.ImageName,
										S.Status
						
						FROM			Products P
						JOIN			Status S ON P.ProductStatus = S.ID
						LEFT JOIN		Vendors V ON P.VendorID = V.VendorID
						LEFT JOIN		ProductImages PI ON P.ProductID = PI.ProductID
						<!---AND				PI.ImageTypeID  IN (#Arguments.ImageTypeID#)--->
						
						WHERE			1=1
						AND				P.ProductDeleted = 0		
						
					<CFIF Len(Arguments.ProductName)>
						AND				P.ProductName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.ProductName#%" />		
					</CFIF>
					<CFIF Len(Arguments.ProductItemNumber)>
						AND				P.ProductItemNumber LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.ProductItemNumber#%" />		
					</CFIF>
					<CFIF IsNumeric(loc_CategorySelection)>
						AND				P.ProductID IN (
											SELECT			ProductID
											FROM			CategoryProductAssoc
											WHERE			CategoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_CategorySelection#" />
										)
					</CFIF>
					<CFIF IsNumeric(Arguments.ProductFeaturedCategory)>
						AND				P.ProductID IN (
											SELECT			ProductID
											FROM			CategoryFeatured
											WHERE			CategoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ProductFeaturedCategory#" />
										)
					</CFIF>
					<CFIF IsNumeric(Arguments.ProductVendor)>
						AND				P.VendorID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ProductVendor#" />		
					</CFIF>
					<CFIF IsNumeric(Arguments.ProductPriceID)>
						AND				(
											CASE 
												WHEN P.ProductDiscountPrice > 0 
												THEN P.ProductDiscountPrice 
												ELSE P.ProductOurPrice 
											END BETWEEN 
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#REQUEST.PriceRange[Arguments.ProductPriceID].PriceMin#" scale="2" />
											AND
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#REQUEST.PriceRange[Arguments.ProductPriceID].PriceMax#" scale="2" />
										)
					</CFIF>
					<CFIF Len(Arguments.Description)>
						AND				(
											P.ProductLongDesc LIKE <cfqueryparam cfsqltype="cf_sql_text" value="%#Arguments.Description#%" />		
											OR
											P.ProductShortDesc LIKE <cfqueryparam cfsqltype="cf_sql_text" value="%#Arguments.Description#%" />												
										)
					</CFIF>
					<CFIF Len(Arguments.ProductKeywords)>
						AND				P.ProductKeywords LIKE <cfqueryparam cfsqltype="cf_sql_text" value="%#Arguments.ProductKeywords#%" />
					</CFIF>
					<CFIF Len(Arguments.SearchString)>
						AND				(
											P.ProductLongDesc LIKE <cfqueryparam cfsqltype="cf_sql_text" value="%#Arguments.SearchString#%" />		
											OR
											P.ProductShortDesc LIKE <cfqueryparam cfsqltype="cf_sql_text" value="%#Arguments.SearchString#%" />	
											OR
											P.ProductItemNumber LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.SearchString#%" />
										)
					</CFIF>
					<CFIF Request.IsFrontEnd>
						AND				P.ProductStatus = 1
					<CFELSEIF IsBoolean(Arguments.Status)>
						AND				P.ProductStatus = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />		
					</CFIF>
			
			) AS RowConstrainedResult

			WHERE		RowNum >= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.StartRow#" />
			AND			RowNum <= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.EndRow#" />
			
			ORDER BY 	RowNum		
		</cfquery>
		
		<cfreturn loc_Products />		
	</cffunction>
    
	<cffunction name="GetProductDetails" returntype="query" output="no">
		<cfargument name="ProductID" type="numeric" default="0" />
		
		<cfset var loc_ProductDetails = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_ProductDetails">
			SELECT		ProductID,
						ProductName,
						ProductItemNumber,
						ProductListPrice,
						ProductOurPrice,
						ProductDiscountPrice,	
						CASE
							WHEN ProductDiscountPrice > 0 
							THEN ProductDiscountPrice
							ELSE ProductOurPrice
						END AS ProductPrice,
						ProductTaxable,
						ProductOversize,
						ProductForSaleOnline,
						Engrave,
						GoldStamp,
						Memorial,
						ProductOutOfStock,
						ProductStatus,
						OutOfStockMessage,
						ProductWeight,
						VendorID
			FROM		Products P
			WHERE		P.ProductID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ProductID#" />
		</cfquery>
		
		<cfreturn loc_ProductDetails />	
	</cffunction>	
	
	<cffunction name="UpdateProductInformation" returntype="void">
		<cfargument name="ProductID" default="0" />		
		<cfargument name="ProductName" type="string" required="yes" />
		<cfargument name="ProductNumber" type="string" required="yes" />
		<cfargument name="Status" type="boolean" required="yes" />
		<cfargument name="ProductTaxable" type="boolean" required="yes" />
		<cfargument name="ProductOversize" type="boolean" required="yes" />
		<cfargument name="ProductForSaleOnline" type="boolean" required="yes" />
		<cfargument name="ProductEngrave" type="boolean" required="yes" />
		<cfargument name="ProductGoldStamp" type="boolean" required="yes" />
		<cfargument name="ProductMemorial" type="boolean" required="yes" />
		<cfargument name="ProductOutOfStock" type="boolean" required="yes" />
		<cfargument name="ProductOutOfStockMessage" type="string" required="yes" />
		<cfargument name="ProductWeight" type="numeric" required="yes" />
		<cfargument name="ProductVendor" type="numeric" required="yes" />
		<cfargument name="ProductListPrice" type="numeric" required="yes" />
		<cfargument name="ProductOurPrice" type="numeric" required="yes" />
		<cfargument name="ProductDiscountPrice" type="numeric" required="yes" />		
		<cfargument name="ReturnUrl" type="string" required="yes" />
		
		<cfset var loc_ProductID = Arguments.ProductID />
		<cfset var loc_UpdateProduct = "" />
		<cfset var loc_StatusMessage = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_UpdateProduct">
			DECLARE @ProductID AS Int;

			SET @ProductID = (
				SELECT	ProductID
				FROM	Products
				WHERE	ProductID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_ProductID#" />
			);
			
			IF @ProductID IS NULL
			
				BEGIN
		
					SET NOCOUNT ON
					
					INSERT INTO Products (
						ProductName, 
						ProductItemNumber,
						ProductStatus,
						ProductTaxable,
						ProductOversize,
						ProductForSaleOnline,
						Engrave,
						GoldStamp,
						Memorial,
						ProductOutOfStock,
						OutOfStockMessage,
						ProductWeight,
						VendorID,
						ProductListPrice,
						ProductOurPrice,
						ProductDiscountPrice,
						DateInserted
					) VALUES (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ProductName#" maxlength="255" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ProductNumber#" maxlength="100" />,						
						<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />,
						<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.ProductTaxable#" />,
						<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.ProductOversize#" />,
						<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.ProductForSaleOnline#" />,
						<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.ProductEngrave#" />,
						<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.ProductGoldStamp#" />,
						<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.ProductMemorial#" />,
						<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.ProductOutOfStock#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ProductOutOfStockMessage#" maxlength="200" />,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ProductWeight#" />,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ProductVendor#" />,
						<cfqueryparam cfsqltype="cf_sql_float" value="#Arguments.ProductListPrice#" />,
						<cfqueryparam cfsqltype="cf_sql_float" value="#Arguments.ProductOurPrice#" />,
						<cfqueryparam cfsqltype="cf_sql_float" value="#Arguments.ProductDiscountPrice#" />,	
						GetDate()
					)
					 
					SELECT	@@IDENTITY AS NewID,
							'Product.Added' AS StatusMessage
					SET NOCOUNT OFF
				END
			ELSE
				BEGIN
		
					UPDATE	Products
					
					SET		ProductName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ProductName#" maxlength="255" />,
							ProductItemNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ProductNumber#" maxlength="100" />,						
							ProductStatus = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />,
							ProductTaxable = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.ProductTaxable#" />,
							ProductOversize = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.ProductOversize#" />,
							ProductForSaleOnline = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.ProductForSaleOnline#" />,
							Engrave = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.ProductEngrave#" />,
							GoldStamp = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.ProductGoldStamp#" />,
							Memorial = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.ProductMemorial#" />,
							ProductOutOfStock = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.ProductOutOfStock#" />,
							OutOfStockMessage = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ProductOutOfStockMessage#" maxlength="200" />,
							ProductWeight = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ProductWeight#" />,
							VendorID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ProductVendor#" />,
							ProductListPrice = <cfqueryparam cfsqltype="cf_sql_float" value="#Arguments.ProductListPrice#" />,
							ProductOurPrice = <cfqueryparam cfsqltype="cf_sql_float" value="#Arguments.ProductOurPrice#" />,
							ProductDiscountPrice = <cfqueryparam cfsqltype="cf_sql_float" value="#Arguments.ProductDiscountPrice#" />
							
					WHERE	ProductID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_ProductID#" />;
					
					SELECT	#loc_ProductID# AS NewID,
							'Product.Updated' AS StatusMessage
				END
		</cfquery>
		
		<cfset loc_ProductID = loc_UpdateProduct.NewID />
		<cfset loc_StatusMessage = loc_UpdateProduct.StatusMessage />
		
		<cflocation url="#Arguments.ReturnUrl#&Message=#loc_StatusMessage#&ProductID=#loc_ProductID#" addtoken="no" />
    
    </cffunction>

</cfcomponent>