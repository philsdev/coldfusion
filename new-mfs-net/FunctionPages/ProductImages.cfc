<cfcomponent hint="This component will handle editing product images" extends="MachII.framework.Listener">
	
	<cffunction name="GetImageTypes" returntype="query" output="no">		
		
		<cfset var loc_ImageTypes = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_ImageTypes">
			SELECT			ImageTypeID,
							ImageType
							
			FROM			ImageTypes
			
			ORDER BY		SortOrder ASC
		</cfquery>
		
		<cfreturn loc_ImageTypes />	
	</cffunction>
	
	<cffunction name="GetProductImages" returntype="query" output="no">		
		<cfargument name="ProductID" type="numeric" default="0" />
		
		<cfset var loc_ProductImages = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_ProductImages">
			SELECT			I.ImageID,
							I.ImageName,
							I.Thumbnail,
							IT.ImageType
							
			FROM			ProductImages I
			JOIN			ImageTypes IT ON I.ImageTypeID = IT.ImageTypeID
				
			WHERE			I.ProductID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ProductID#" />
			
			ORDER BY		Thumbnail DESC,
							ImageName ASC
		</cfquery>
		
		<cfreturn loc_ProductImages />	
	</cffunction>	
	
	<cffunction name="GetProductImageDetails" returntype="query" output="no">
		<cfargument name="ImageID" type="numeric" default="0" />
		
		<cfset var loc_ImageDetails = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_ImageDetails">
			SELECT		ImageID,
						ImageName,
						ImageTypeID
						
			FROM		ProductImages I
			
			WHERE		I.ImageID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ImageID#" />
		</cfquery>
		
		<cfreturn loc_ImageDetails />	
	</cffunction>
	
	<cffunction name="UpdateProductImage" returntype="void" output="no">
		<cfargument name="ProductID" type="numeric" required="yes">
		<cfargument name="ImageID" default="0" />
		<cfargument name="ProductImageType" type="numeric" required="yes" />		
		<cfargument name="ProductImageUpload" type="string" default="" />
		<cfargument name="ReturnUrl" type="string" required="yes" />
		
		<cfset var loc_ImageID = Arguments.ImageID />
		<cfset var loc_ProductID = Arguments.ProductID />
		<cfset var loc_UpdateImage = "" />
		<cfset var loc_StatusMessage = "" />
		<cfset var loc_ImageFilePath = REQUEST.Root.Server.Image.Product />
		<cfset var loc_ImageFileName = "" />
		<cfset var loc_ImageFileExtension = "" />
		<cfset var loc_ImageFileFullName = "" />
		<cfset var loc_ImageFullPath = "" />
		<cfset var loc_ImageManager = Request.ListenerManager.GetListener( "ImageManager" ) />
		
		<!--- item image was uploaded --->
		<cfif len(Arguments.ProductImageUpload)>
			
			<!--- upload user file (as-is) --->
			<cffile action="upload" filefield="ProductImageUpload" destination="#loc_ImageFilePath#" nameconflict="overwrite" />
			
			<cfset loc_ImageFileName = CFFILE.ClientFileName />
			<cfset loc_ImageFileExtension = CFFILE.ClientFileExt />
			<cfset loc_ImageFileFullName = loc_ImageFileName & "." & loc_ImageFileExtension />
			<cfset loc_ImageFullPath = loc_ImageFilePath & loc_ImageFileFullName />
			
			<cfoutput>loc_ImageFullPath: #loc_ImageFullPath#
			<br>
			loc_ImageFilePath: #loc_ImageFilePath#<br>
			loc_ImageFileFullName: #loc_ImageFileFullName#
			<br>
			REQUEST.Image.ValidExtensionList: #REQUEST.Image.ValidExtensionList#
			<br>
			 NULL="#NOT(LEN(loc_ImageFileFullName))#"
			</cfoutput>
			
			 <!--- <cfabort> --->
			<!--- delete upload if it's not the proper type (and somehow makes it past front-end validation) --->
			<cfif NOT ListFindNoCase( REQUEST.Image.ValidExtensionList, loc_ImageFileExtension, "|" )>				
				<cffile action="delete" file="#loc_ImageFullPath#" />				
				<cfthrow message="Image type not supported" />						
			</cfif>
		
			<!--- create image variations --->
			<cfset loc_ImageManager.CreateImageVariations(
				Filename:loc_ImageFileFullName,
				ImageCategory:'Product'
			) />
		
		</cfif>		
		
		<cfquery datasource="#request.dsource#" name="loc_UpdateImage">
			DECLARE @ImageID AS Int;

			SET @ImageID = (
				SELECT	ImageID
				FROM	ProductImages
				WHERE	ImageID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_ImageID#" />
			);
			
			IF @ImageID IS NULL
			
				BEGIN
		
					SET NOCOUNT ON
					
					INSERT INTO ProductImages (
						ProductID, 
						ImageName,
						ImageTypeID
					) VALUES (
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_ProductID#" />,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#loc_ImageFileFullName#" NULL="#NOT(LEN(loc_ImageFileFullName))#" />,
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ProductImageType#" />
					);
					 
					SELECT	@@IDENTITY AS NewID,
							'Image.Added' AS StatusMessage
					SET NOCOUNT OFF
				END
			ELSE
				BEGIN
		
					UPDATE	ProductImages
					
					SET		ImageName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#loc_ImageFileFullName#" NULL="#NOT(LEN(loc_ImageFileFullName))#" />,
							ImageTypeID = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.ProductImageType#" />
							
					WHERE	ImageID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_ImageID#" />
					AND		ProductID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_ProductID#" />;
					
					SELECT	#loc_ImageID# AS NewID,
							'Image.Updated' AS StatusMessage
				END
		</cfquery>
		
		<cfset loc_ImageID = loc_UpdateImage.NewID />
		<cfset loc_StatusMessage = loc_UpdateImage.StatusMessage />
		
		<cflocation url="#Arguments.ReturnUrl#&Message=#loc_StatusMessage#&ImageID=#loc_ImageID#&ProductID=#loc_ProductID#" addtoken="no" />
		
	</cffunction>
	
	<cffunction name="GetProductImageUrl" returntype="string" output="no">
		<cfargument name="Filename" type="string" required="yes" />
		<cfargument name="ImageType" type="string" required="yes" />
		
		<cfset var loc_ImageType = Arguments.ImageType />
		<cfset var loc_ImageUrl = "" />
		<cfset var loc_ImagePrefix = REQUEST.Image.Product[loc_ImageType].Prefix />
		
		<cfif LEN(Arguments.Filename)>
			<cfset loc_ImageUrl = REQUEST.Root.Web.Image.Product & loc_ImagePrefix & Arguments.Filename />
		</cfif>
		
		<cfreturn loc_ImageUrl />	
	</cffunction>

</cfcomponent>