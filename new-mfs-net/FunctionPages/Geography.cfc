<cfcomponent hint="This component will handle geographic functions" extends="MachII.framework.Listener">

	<cfscript>		
		this.RowMax = 100;
	</cfscript>
	
	<!--- http://en.wikipedia.org/wiki/Provinces_and_territories_of_Canada --->
	<cffunction name="GetStates" access="public" returntype="query" output="no">
		<cfargument name="Country" type="string" required="no" default="" />
	
		<cfset var loc_States = "" />
	
		<cfquery name="loc_States" datasource="#request.dsource#" cachedwithin="#CreateTimeSpan(0,2,0,0)#">
			SELECT		ISO AS ID,
						[Name] AS Label,
						Country
						
			FROM		States
			
			WHERE		1=1
		<!--- TODO: convert ship/bill countries to 2-letter codes --->
		<!---CFIF Len(Arguments.Country)>
			AND			Country = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Country#" />
		<CFELSE>
			AND			Country = <cfqueryparam cfsqltype="cf_sql_varchar" value="US" />
		</CFIF--->
			ORDER BY	Country DESC,
						Label ASC
		</cfquery>
		
		<cfreturn loc_States />
	</cffunction>
	
	<cffunction name="GetCountries" access="public" returntype="query" output="no">
		<cfargument name="ShowAll" type="boolean" required="no" default="true" />
	
		<cfset var loc_Countries = "" />
	
		<cfquery name="loc_Countries" datasource="#request.dsource#" cachedwithin="#CreateTimeSpan(0,2,0,0)#">
			SELECT		ISO AS ID,
						Printable_Name AS Label
						
			FROM		Countries
			
			WHERE		1=1
		<CFIF NOT Arguments.ShowAll>
			AND			ISO IN ('US','CA')
		</CFIF>
			
			ORDER BY	Printable_Name
		</cfquery>
		
		<cfreturn loc_Countries />
	</cffunction>	
		
</cfcomponent>
