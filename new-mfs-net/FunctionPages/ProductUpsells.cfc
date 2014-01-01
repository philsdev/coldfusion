<cfcomponent extends="MachII.framework.Listener">

	<cffunction name="GetProductUpsellTitle" returntype="string" output="no">
		<cfargument name="ProductID" type="numeric" required="yes" />
		<cfargument name="ProductTitle" type="string" required="yes" />
		<cfargument name="VendorName" type="string" required="yes" />
		<cfargument name="ProductItemNumber" type="string" required="yes" />
			
		<cfset var loc_ProductUpsellTitle = "" />
		<cfset var loc_LinkManager = Request.ListenerManager.GetListener( "LinkManager" ) />
		
		<cfscript>
			loc_ProductUpsellTitle = loc_ProductUpsellTitle & "(" & Arguments.ProductID & ") ";
			loc_ProductUpsellTitle = loc_ProductUpsellTitle & loc_LinkManager.GetDisplayName( Arguments.ProductTitle ) & " ";
			
			loc_ProductUpsellTitle = loc_ProductUpsellTitle & "[";
			
			if ( LEN(Arguments.VendorName) ) {
				loc_ProductUpsellTitle = loc_ProductUpsellTitle & loc_LinkManager.GetDisplayName( Arguments.VendorName );
			} else {
				loc_ProductUpsellTitle = loc_ProductUpsellTitle & "N/A";
			}
			
			loc_ProductUpsellTitle = loc_ProductUpsellTitle & ": ";
			
			if ( LEN(Arguments.ProductItemNumber) ) {
				loc_ProductUpsellTitle = loc_ProductUpsellTitle & Arguments.ProductItemNumber;
			} else {
				loc_ProductUpsellTitle = loc_ProductUpsellTitle & "N/A";
			}
			
			loc_ProductUpsellTitle = loc_ProductUpsellTitle & "]";
		</cfscript>
		
		<cfreturn loc_ProductUpsellTitle />	
	</cffunction>
	
	<cffunction name="GetDisplayProductUpsells" returntype="query" output="no">		
		<cfargument name="ProductID" type="numeric" default="0" />
		
		<cfset var loc_DisplayProductUpsells = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_DisplayProductUpsells">
			SELECT			P.ProductID,
							P.ProductName,							
							P.ProductItemNumber,
							P.ProductOurPrice,
							P.ProductDiscountPrice,
							PI.ImageName
							
			FROM			ProductUpsells U
			JOIN			Products P ON U.AssocProductID = P.ProductID
			JOIN			ProductImages PI ON P.ProductID = PI.ProductID AND PI.ImageTypeID = 1
				
			WHERE			U.MainProductID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ProductID#" />
			
			ORDER BY 		U.DisplayPosition ASC
		</cfquery>
		
		<cfreturn loc_DisplayProductUpsells />	
	</cffunction>
	
	<cffunction name="GetProductUpsells" returntype="query" output="no">		
		<cfargument name="ProductID" type="numeric" default="0" />
		
		<cfset var loc_ProductUpsells = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_ProductUpsells">
			SELECT			P.ProductID,
							P.ProductName,							
							P.ProductItemNumber,
							V.VendorName
							
			FROM			ProductUpsells U
			JOIN			Products P ON U.AssocProductID = P.ProductID
			LEFT JOIN		Vendors V ON P.VendorID = V.VendorID
				
			WHERE			U.MainProductID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ProductID#" />
			
			ORDER BY 		U.DisplayPosition ASC
		</cfquery>
		
		<cfreturn loc_ProductUpsells />	
	</cffunction>
	
	<cffunction name="GetAvailableProducts" returntype="query" output="no">		
		<cfargument name="SearchBy" type="string" required="yes" />
		<cfargument name="FirstCharacter" type="string" required="yes" />
		
		<cfset var loc_AvailableProducts = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_AvailableProducts">
			SELECT			P.ProductID,
							P.ProductName,							
							P.ProductItemNumber,
							V.VendorName
							
			FROM			Products P
			LEFT JOIN		Vendors V ON P.VendorID = V.VendorID
				
			WHERE			1=1			
			<cfswitch expression="#Arguments.SearchBy#">
				<cfcase value="ProductID">
					AND		LEFT(P.ProductID,1) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.FirstCharacter#" />
				</cfcase>
				<cfcase value="ProductName">
					AND		LEFT(P.ProductName,1) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.FirstCharacter#" />
				</cfcase>
				<cfcase value="VendorName">
					AND		LEFT(V.VendorName,1) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.FirstCharacter#" />
				</cfcase>
				<cfcase value="ProductItemNumber">
					AND		LEFT(P.ProductItemNumber,1) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.FirstCharacter#" />
				</cfcase>
			</cfswitch>							
			
			ORDER BY 		P.ProductName ASC
		</cfquery>
		
		<cfreturn loc_AvailableProducts />	
	</cffunction>
	
	<cffunction name="UpdateProductUpsells" returntype="void" output="no">		
		<cfargument name="ProductID" type="numeric" required="yes" />
		<cfargument name="SelectedProductID" type="string" required="yes" />
		
		<cfset var loc_AvailableProducts = "" />
		<cfset var loc_ProductID = Arguments.ProductID />
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
			FROM		ProductUpsells
			WHERE		MainProductID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_ProductID#" />;
		
			<cfloop list="#loc_ProductIDList#" index="loc_ThisProductID">
				<cfset loc_ThisProductCount = IncrementValue( loc_ThisProductCount ) />
				
				INSERT INTO ProductUpsells (
					MainProductID,
					AssocProductID,
					DisplayPosition
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#loc_ProductID#" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#loc_ThisProductID#" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#loc_ThisProductCount#" />
				);
			</cfloop>
		</cfquery>
		
		<cfset loc_ReturnUrl = Arguments.ReturnUrl & "&message=Product.Upsell.Updated" />
		
		<cflocation url="#loc_ReturnUrl#" addtoken="no" />	
		
	</cffunction>

</cfcomponent>
