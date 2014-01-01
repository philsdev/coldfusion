<cfcomponent extends="MachII.framework.Listener">
	
	<cffunction name="GetFonts" returntype="query" output="no">		
				
		<cfset var loc_Fonts = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_Fonts">
			SELECT			FontID,
							FontName,
							FontImageName

			FROM        	Fonts
		</cfquery>
		
		<cfreturn loc_Fonts />	
	</cffunction>	
	
</cfcomponent>