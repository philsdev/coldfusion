<cfcomponent hint="This component will handle editing product options" extends="MachII.framework.Listener">
	
	<cffunction name="GetProductOptions" returntype="query" output="no">		
		<cfargument name="ProductID" type="numeric" default="0" />
				
		<cfset var loc_ProductOptions = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_ProductOptions">
			SELECT			POA.ProductID,
							POA.OptionID,
							POA.OutOfStock,
							POA.Price,
							POA.AddPrice,
							POA.Required,
							PO.OptionName,								
							PO.OptionNumber,
							PO.OptionImage,
							PO.GroupID,
							
							PA.ProductAttributeName

			FROM        	ProductOptionsAssoc POA
			JOIN        	ProductOptions PO ON POA.OptionID = PO.OptionID
			JOIN        	ProductAttributes PA ON PO.GroupID = PA.ProductAttributeID

			WHERE       	POA.ProductID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ProductID#" />			
			<cfif Request.IsFrontEnd>
				AND			PA.ProductAttributeStatus = 1
			</cfif>

			ORDER BY		GroupID,
							Price,
							AddPrice,
							OptionID
		</cfquery>
		
		<cfreturn loc_ProductOptions />	
	</cffunction>		
	
	<cffunction name="GetProductOptionsGrid" returntype="query" output="no">		
		<cfargument name="ProductID" type="numeric" default="0" />
		<cfargument name="StartRow" type="numeric" default="1" />
		<cfargument name="EndRow" type="numeric" default="#REQUEST.Settings.RecordsPerPage#" /> 
	
		<cfset var loc_ProductOptions = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_ProductOptions">
		
			SELECT		COUNT(*) OVER () as Row_Total,
						POA.ProductID,
						POA.OptionID,
						POA.OutOfStock,
						POA.Price,
						POA.AddPrice,
						POA.Required,
						PO.OptionName,								
						PO.OptionNumber,
						PO.OptionImage,
						PO.GroupID,
						PA.ProductAttributeName,
						PA.ProductAttributeStatus,
						PA.ProductAttributeID

		FROM        	ProductOptionsAssoc POA
		JOIN        	ProductOptions PO ON POA.OptionID = PO.OptionID
		JOIN        	ProductAttributes PA ON PO.GroupID = PA.ProductAttributeID

		WHERE       	POA.ProductID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ProductID#" />			
		<cfif Request.IsFrontEnd>
			AND			PA.ProductAttributeStatus = 1
		</cfif>
					
		ORDER BY ProductAttributeName, OptionName
			
		</cfquery>
			
		<cfreturn loc_ProductOptions />	
	</cffunction>	
	
	<cffunction name="GetOptionAssociation" returntype="query" output="no">		
		<cfargument name="ProductID" type="numeric" default="0" />
		<cfargument name="OptionID" type="numeric" default="0" />
				
		<cfset var loc_ProductOptions = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_ProductOptions">
		SELECT			POA.ProductID,POA.OptionID, POA.OutOfStock,
							POA.Price,
							POA.AddPrice,
							POA.Required,
							PO.OptionName,
							PO.OptionNumber,
							PO.OptionImage,
							PO.GroupID
		FROM			ProductOptionsAssoc POA
		JOIN			ProductOptions PO ON POA.OptionID = PO.OptionID
		WHERE			POA.ProductID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ProductID#" />		
		AND				POA.OptionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.OptionID#" />			
		</cfquery>
		
		<cfreturn loc_ProductOptions />	
	</cffunction>	
	
	
	<cffunction name="UpdateProductOption" returntype="void" output="no">
		<cfargument name="ProductID" type="numeric" required="yes" />
		<cfargument name="OptionID" type="numeric" default="0" />
		<!--- <cfargument name="OptionImageUpload" type="string" default="" />  --->
		<cfargument name="Optionname" type="string" required="yes">
		<cfargument name="OptionNumber" type="string" required="no">
		<cfargument name="Price" type="numeric" required="no" default="0">
		<cfargument name="AddPrice" type="numeric" required="no" default="0">
		<cfargument name="OutOfStock" type="boolean" required="yes">
		<cfargument name="ReturnUrl" type="string" required="yes" /> 
		
				
		<cfset var loc_OptionID = Arguments.OptionID />
		<cfset var loc_ProductID = Arguments.ProductID />
		<cfset var loc_UpdateOption = "" />
		<cfset var loc_StatusMessage = "" />
		
	
	
		 <cfquery datasource="#request.dsource#" name="loc_UpdateOption">
		
			DECLARE @OptionID AS Int;

			SET @OptionID = (
				SELECT	OptionID
				FROM	ProductOptions
				WHERE	OptionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_OptionID#" />
			);
			
			IF @OptionID IS NULL
			
				BEGIN
		
					SET NOCOUNT ON
					
					INSERT INTO ProductOptions (
					OptionName,
					
					<!--- OptionImage, --->
					GroupID,
					OptionNumber
					) VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.OptionName#" maxlength="200" />,
					<!--- <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.OptionImage#" maxlength="255" />, --->
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.GroupID#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.OptionNumber#" maxlength="200" />
					)
					
					
					SELECT	@@IDENTITY AS NewID,
							'Option.Added' AS StatusMessage
							
					SET NOCOUNT OFF;
					
					INSERT INTO ProductOptionsAssoc (
					OptionID,
					ProductID,
					OutOfStock,
					Price,
					AddPrice,
					Required
					) VALUES (
					@@IDENTITY,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#loc_ProductID#" />,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.OutOfStock#" />,
					<cfqueryparam cfsqltype="cf_sql_float" value="#Arguments.Price#" />,
					<cfqueryparam cfsqltype="cf_sql_float" value="#Arguments.AddPrice#" />,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Required#" />
					)
					 
					
				END
			ELSE
				BEGIN
		
					UPDATE	ProductOptions
					SET		OptionName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.OptionName#" maxlength="200" />,
							<!--- OptionImage = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.OptionImage#" maxlength="255" />, --->
							GroupID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.GroupID#" />,
							OptionNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.OptionNumber#" maxlength="200" />
					WHERE 	OptionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_OptionID#" />;
					
					UPDATE	ProductOptionsAssoc
					SET		OutofStock = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.OutofStock#" />,
							Price = <cfqueryparam cfsqltype="cf_sql_float" value="#Arguments.Price#"  />, 
							AddPrice = <cfqueryparam cfsqltype="cf_sql_float" value="#Arguments.AddPrice#" />, 
							Required = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Required#" />
					WHERE 	OptionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_OptionID#" />
					AND		ProductID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_ProductID#" />;
				
					SELECT	#loc_OptionID# AS NewID,
							'Option.Updated' AS StatusMessage
				END
		</cfquery>  
		
		
		<cfset loc_OptionID = loc_UpdateOption.NewID />
		<cfset loc_StatusMessage = loc_UpdateOption.StatusMessage />
		
		<cflocation url="#Arguments.ReturnUrl#&Message=#loc_StatusMessage#&OptionID=#loc_OptionID#&ProductID=#Arguments.ProductID#" addtoken="no" />
		
	</cffunction>
	
	<cffunction name="DeleteProductOption" returntype="void" output="no">
			<cfargument name="OptionID" type="numeric" required="yes" />
			<cfargument name="ProductID" type="numeric" required="yes" />
			
			<cfquery datasource="#request.dsource#" name="loc_DeleteOption">
			DELETE
			FROM ProductOptions
			WHERE 	OptionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.OptionID#" />
			</cfquery>
			
			<cfquery datasource="#request.dsource#" name="loc_DeleteOptionAssoc">
			DELETE
			FROM ProductOptionsAssoc
			WHERE 	OptionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.OptionID#" />
			AND		ProductID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ProductID#" />
			</cfquery>
			
		</cffunction>
	
	<cffunction name="GetAttributes" returntype="query" output="no">		
		
		<cfset var loc_Attributes = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_Attributes">
			SELECT			ProductAttributeID,
							ProductAttributeName
							
			FROM			ProductAttributes
			
			ORDER BY		ProductAttributeName ASC
		</cfquery>
		
		<cfreturn loc_Attributes />	
	</cffunction>
	
</cfcomponent>