<cfcomponent extends="MachII.framework.Listener">
	
	<cffunction name="GetDisplayLocations" access="public" output="false" returntype="query">    
        
		<cfset var loc_DisplayLocations = "" />
        
		<cfquery datasource="#request.dsource#" name="loc_DisplayLocations">
			SELECT		ID,
						Title
			
			FROM		AMP_Locations
			
			WHERE		Status = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
			
			ORDER BY	Title
		</cfquery>		
		
		<cfreturn loc_DisplayLocations />
	</cffunction> 
	
</cfcomponent>