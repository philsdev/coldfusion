<cfcomponent hint="This component will handle images" extends="MachII.framework.Listener">
		
	<cffunction name="GetImageUrl" returntype="string" output="no">
		<cfargument name="Filename" type="string" required="yes" hint="filename.jpg|jpeg|gif" />
		<cfargument name="ImageCategory" type="string" required="yes" hint="Product, Category, etc" />
		<cfargument name="ImageType" type="string" required="yes" hint="Thumbnail, Detail, etc" />
		
		<cfset var loc_Filename = Arguments.Filename />
		<cfset var loc_ImageCategory = Arguments.ImageCategory />
		<cfset var loc_ImageType = Arguments.ImageType />
		
		<cfset var loc_ImageUrl = "" />
		<cfset var loc_ImagePrefix = REQUEST.Image[loc_ImageCategory][loc_ImageType].Prefix />
		
		<cfif LEN(loc_Filename)>
			<cfset loc_ImageUrl = REQUEST.Root.Web.Image[loc_ImageCategory] & loc_ImagePrefix & loc_Filename />
		<cfelse>
			<cfset loc_ImageUrl = REQUEST.Root.Web.Image[loc_ImageCategory] & loc_ImagePrefix & "undefined.gif" />
		</cfif>
		
		<cfreturn loc_ImageUrl />	
	</cffunction>
	
	<cffunction name="CreateImageVariations" access="public" output="false" returntype="void" hint="I create the variations based on a user upload"> 
		<cfargument name="Filename" type="string" required="yes" hint="filename.jpg|jpeg|gif" />
		<cfargument name="ImageCategory" type="string" required="yes" hint="Product, Category, etc" />
	
		<cfset var loc_Filename = Arguments.Filename />
		<cfset var loc_ImageCategory = Arguments.ImageCategory />
		<cfset var loc_FilePath = "" />
		<cfset var loc_thisType = "" />
		<cfset var loc_thisPrefix = "" />
		<cfset var loc_OriginalImage = "" />
		<cfset var loc_OriginalImagePath = REQUEST.Root.Server.Image[loc_ImageCategory] & loc_Filename />
		
		<cfif NOT FileExists( loc_OriginalImagePath )>
			<cfthrow message="Source file does not exist" />
		</cfif>
		
		<!--- loop over available types for this category --->
		<cfloop collection="#REQUEST.Image[loc_ImageCategory]#" item="loc_thisType">
		
			<!--- get original image to manipulate --->
			<cfset loc_OriginalImage = ImageRead(loc_OriginalImagePath) />
		
			<!--- determine image prefix --->
			<cfset loc_thisPrefix = REQUEST.Image[loc_ImageCategory][loc_thisType].Prefix />
			
			<!--- get full path of new image --->
			<cfset loc_FilePath = REQUEST.Root.Server.Image[loc_ImageCategory] & loc_thisPrefix & loc_Filename />
			
			<!--- resize image --->
			<cfif ImageGetWidth(loc_OriginalImage) NEQ REQUEST.Image[loc_ImageCategory][loc_thisType].Width>
				<cfset ImageScaleToFit(loc_OriginalImage, REQUEST.Image[loc_ImageCategory][loc_thisType].Width, '') />
			</cfif>
		
			<!--- write new image --->
			<cfset ImageWrite(loc_OriginalImage, loc_FilePath) />
		
		</cfloop>
		
		<!--- delete original image --->
		<cffile action="delete" file="#loc_OriginalImagePath#" />
		
	</cffunction>

</cfcomponent>