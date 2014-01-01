<cfcomponent extends="MachII.framework.Listener">

	<cfscript>
		this.SortOptions = ArrayNew(1);
		
		this.SortOptions[1] = ["word","Word","LTRIM(RTRIM(W.WordSearched))"];
		this.SortOptions[2] = ["searchcount","Times Searched","ISNULL(SUM(W.TimesSearched),0)"];
		this.SortOptions[3] = ["resultcount","Results Returned","ISNULL(SUM(W.ResultsRetuned),0)"];
		this.SortOptions[4] = ["datelastsearched","Date Last Searched","MAX(W.LastSearchedOn)"];
		
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

	<cffunction name="GetWords" returntype="query">
		<cfargument name="StartRow" type="numeric" default="1" />
		<cfargument name="EndRow" type="numeric" default="#REQUEST.Settings.RecordsPerPage#" /> 
		<cfargument name="Word" type="string" default="" />
		<cfargument name="sidx" type="string" required="no" default="#this.SortOptions[1][3]#" />
		<cfargument name="sord" type="string" required="no" default="#this.DefaultSord#" />
    	
		<cfset var loc_WordsSearched = "" />
	
		<cfquery datasource="#request.dsource#" name="loc_WordsSearched">
			SELECT		*
			FROM  (
					  
						SELECT			ROW_NUMBER() OVER ( ORDER BY #Arguments.sidx# #Arguments.sord# ) AS RowNum,
										COUNT(*) OVER () as Row_Total,
										LTRIM(RTRIM(W.WordSearched)) AS Word,
										ISNULL(SUM(W.TimesSearched),0) AS SearchCount,
										ISNULL(SUM(W.ResultsReturned),0) AS ResultCount,
										CONVERT(CHAR(10),MAX(W.LastSearchedOn),101) AS DateLastSearched
						
						FROM			WordsSearched W
						
						WHERE			1=1		
						
					<CFIF Len(Arguments.Word)>
						AND				W.WordSearched LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.Word#%" />		
					</CFIF>
					
						GROUP BY		LTRIM(RTRIM(W.WordSearched))
			
			) AS RowConstrainedResult

			WHERE		RowNum >= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.StartRow#" />
			AND			RowNum <= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.EndRow#" />
			
			ORDER BY 	RowNum		
		</cfquery>
		
		<cfreturn loc_WordsSearched />
		
	</cffunction>
	
</cfcomponent>