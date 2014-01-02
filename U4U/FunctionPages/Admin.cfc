<cfcomponent hint="This component will handle loggin in and logging out the site administrator" extends="MachII.framework.Listener">

	<cfscript>
		this.HourValuesList = "12,1,2,3,4,5,6,7,8,9,10,11";
		this.MeridianList = "AM,PM";
		this.TimeDelimiter = ":";
		
		this.MinuteValues = StructNew();
		this.MinuteValues.Min = 0;
		this.MinuteValues.Max = 59;
		
		this.TimeFieldSuffix = StructNew();
		this.TimeFieldSuffix.Hour = "__hour";
		this.TimeFieldSuffix.Minute = "__minute";
		this.TimeFieldSuffix.Meridian = "__meridian";
		
		this.CaptchaSettings = StructNew();
		this.CaptchaSettings.CharacterList = "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z";
		this.CaptchaSettings.CharacterListLength = ListLen( this.CaptchaSettings.CharacterList );
		this.CaptchaSettings.MinDrawingAngle = -5;
		this.CaptchaSettings.MaxDrawingAngle = 5;
		this.CaptchaSettings.Width = "150";
		this.CaptchaSettings.Height = "30";
		this.CaptchaSettings.StringLength = "5";
		this.CaptchaSettings.TextColor = "black";
		this.CaptchaSettings.BackgroundColor = "white";
		this.CaptchaSettings.FileExtension = ".png";
		
		this.CaptchaSettings.TextAttributes.Font = "Courier New";
		this.CaptchaSettings.TextAttributes.Size = 18;
		this.CaptchaSettings.TextAttributes.Style = "bold";
		
		this.DescriptionWordMax = 50;
		this.RowMax = 100;
	</cfscript>
	
	<!--- ///////////////////////////////////////////////////////// --->
	<!--- ///////////////   AUTHENTICATION EVENTS   /////////////// --->
	<!--- ///////////////////////////////////////////////////////// --->
	
	<cffunction name="VerifyLogin" output="no" access="public" returntype="void">	
		<cfargument name="Username" type="string" required="true" />
		<cfargument name="Password" type="string" required="true" />
		
		<cfset var loc_FindAdmin = "" />
		<cfset var loc_AdminID = "" />
		<cfset var loc_PW = Arguments.Password />
		
		<cfquery datasource="#request.dsource#" name="loc_FindAdmin">
			SELECT		ISNULL(ID,0) AS AdminID
			FROM		AMP_SiteAdmins
			WHERE		Username = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Username#" />
			AND			Password = <cfqueryparam cfsqltype="cf_sql_char" value="#loc_PW#" />
			AND			Status = 1
		</cfquery>	
		
		<cfset loc_AdminID = loc_FindAdmin.AdminID />
		
		<cflock type="exclusive" scope="SESSION" timeout="10">			
			<cfscript>
				if (loc_AdminID GT 0) {
					
					SESSION.Admin = 1;
					SESSION.SectionQuery = GetAdminSections( AdminID:loc_AdminID );		
					SESSION.AdminPermissions = ValueList(SESSION.SectionQuery.EventName);
					SESSION.AdminPermissionList = ValueList(SESSION.SectionQuery.SectionID);
					
					AnnounceEvent('Admin.HomePage');	
					
				} else {
						
					SESSION.Failed = "yes";
					AnnounceEvent('Admin.Login');
			
				}
			</cfscript>
		</cflock>
	
	</cffunction>	
	
	<cffunction name="Logout" returntype="void" output="false" hint="logging out the site administrator">
	
		<cfset var loc_ThisKey = "" />
		
		<!--- Delete the created SESSIONs --->
		<cfloop collection="#SESSION#" item="loc_ThisKey">
			<cfif NOT ListFindNoCase( "CFID,CFTOKEN", loc_ThisKey )>
				<cfset StructDelete(SESSION,"#loc_ThisKey#") />
			</cfif>
		</cfloop>
		
		<!--- Admin logged out, call the Event to display the login page --->
		<cfset announceEvent('Admin.Login') />
        
	</cffunction>    
			
	<cffunction name="ValidateAdministrator" returntype="void" hint="I check to make sure the admin is still logged in">
		
		<!--- Validate that the admin is still logged in --->
		<cfif not StructKeyExists(SESSION, "AdminID") OR StructCount(SESSION) EQ 0>
			<cflocation url="index.cfm?event=Admin.Login" addtoken="no" />
		</cfif>
		
	</cffunction>
	
	<cffunction name="GetRandomString" access="public" output="false" returntype="string">    
		<cfargument name="StringLength" type="numeric" required="yes" />
		
		<cfset var loc_Index = "" />
		<cfset var loc_CharacterList = this.CaptchaSettings.CharacterList />
		<cfset var loc_CharacterListLength = LISTLEN( loc_CharacterList ) />
		<cfset var loc_RandomCharacterIndex = "" />
		<cfset var loc_RandomCharacter = "" />
		<cfset var loc_RandomString = "" />		
		
		<cfloop from="1" to="#Arguments.StringLength#" index="loc_Index">
			<cfset loc_RandomCharacterIndex = RANDRANGE( 1, loc_CharacterListLength ) />
			<cfset loc_RandomCharacter = LISTGETAT( loc_CharacterList, loc_RandomCharacterIndex ) />
			<cfset loc_RandomString = loc_RandomString & loc_RandomCharacter />
		</cfloop>
		
		<cfreturn loc_RandomString />
	</cffunction>
	
	<cffunction name="GetHashedValue" access="public" output="false" returntype="string">    
		<cfargument name="InputValue" type="string" required="yes" />
		
		<cfset loc_hashedValue = "" />
		
		<cfif LEN( Arguments.InputValue )>
			<cfset loc_hashedValue = HASH( Arguments.InputValue, "SHA-512" ) />
		</cfif>
		
		<cfreturn loc_hashedValue />
	</cffunction>
	
	<cffunction name="GetAdminSections" access="public" returntype="query" output="no">
		<cfargument name="AdminID" type="numeric" required="yes" />
	
		<cfset var loc_AdminSections = "" />
	
		<cfquery name="loc_AdminSections" datasource="#request.dsource#">
			SELECT			S.SectionID,
							RTRIM(S.SectionName) AS SectionName,
							G.GroupName,
							RTRIM(S.EventName) AS EventName,
							RTRIM(S.SectionDescription) AS SectionDescription
			
			FROM			AMP_SiteAdminPermissions P
			JOIN			AMP_SiteAdminSections S ON P.SectionID = S.SectionID AND S.Active = 1
			JOIN			AMP_SiteAdminSectionGroups G ON S.SectionGroupID = G.GroupID AND G.Active = 1
			
			WHERE			P.AdminID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AdminID#" />
			
			ORDER BY		G.Sort,
							S.Sort
		</cfquery>
		
		<cfreturn loc_AdminSections />
	</cffunction>
	
	<cffunction name="GetAdminSection" access="public" returntype="string" output="no">
		<cfargument name="AdminSectionQuery" type="query" required="yes" />
		<cfargument name="EventName" type="string" required="yes" />
		
		<cfset loc_SectionName = "" />
		
		<cfquery name="loc_SectionName" dbtype="query">
			SELECT			EventName
			FROM			Arguments.AdminSectionQuery
			WHERE			EventName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.EventName#" />
		</cfquery>
		
		<cfreturn loc_SectionName.EventName />
	</cffunction>
	
	<cffunction name="GetAdminPermissions" returntype="query" hint="I return the selected admin permissions">
    		<cfargument name="AdminID" default="0" />
	
		<cfset var loc_AdminPermissions = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_AdminPermissions">
			SELECT			S.SectionID,
							RTRIM(S.SectionName) AS SectionName,
							G.GroupName,
							CASE WHEN P.AdminID IS NOT NULL THEN 1 ELSE 0 END AS IsAuthorized
			
			FROM			AMP_SiteAdminSectionGroups G
			JOIN			AMP_SiteAdminSections S ON G.GroupID = S.SectionGroupID AND S.Active = 1     
			LEFT JOIN		AMP_SiteAdminPermissions P ON S.SectionID = P.SectionID 
			AND				P.AdminID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AdminID#" />
			
			WHERE			G.Active = 1
			
			ORDER BY		G.Sort,
							S.Sort
		</cfquery>
        
        <cfreturn loc_AdminPermissions />        
    </cffunction>  
	
	<!--- ///////////////////////////////////////////////////////// --->
	<!--- //////////////////   UTILITY EVENTS   /////////////////// --->
	<!--- ///////////////////////////////////////////////////////// --->
	
	<cffunction name="GetUrl" access="public" output="false" returntype="void">
		<cfargument name="DestinationUrl" type="string" required="yes" />
		
		<cflocation url="#Arguments.DestinationUrl#" addtoken="no" />		
	</cffunction>
	
	<cffunction name="VerifyAvailability" access="public" output="false" returntype="void">
		<cfargument name="InputQuery" default="" />
		
		<cfif NOT IsQuery( Arguments.InputQuery ) OR NOT Arguments.InputQuery.RecordCount>
			<cflocation url="/unavailable.html" addtoken="no" />
		</cfif>
		
	</cffunction>
	
	<cffunction name="LaunderInputs" access="public" output="false" returntype="void">
		<cfargument name="KeyInclusionList" type="string" required="no" default="" />
		
		<cfset var loc_ThisFieldName = "" />
		<cfset var loc_ThisFieldValue = "" />
		
		<cfloop list="#Arguments.KeyInclusionList#" index="loc_thisFieldName">
			<cfset loc_ThisFieldValue = Request.Event.GetArg(loc_thisFieldName) />
			
			<!--- remove tags --->
			<cfset loc_thisFieldValue = REReplaceNoCase( loc_ThisFieldValue, '<[^>]+>', '', 'all' ) />
			
			<cfset Request.Event.SetArg( loc_thisFieldName, loc_thisFieldValue ) />
		</cfloop>
		
	</cffunction>
	
	<cffunction name="StripTagsFromStruct" access="public" output="true" returntype="struct">
		<cfargument name="InputStruct" type="struct" required="yes" />
		<cfargument name="KeyList" type="string" required="no" default="" />
		
		<cfset loc_OutputStruct = Arguments.InputStruct />
		<cfset loc_thisItemName = "" />
		<cfset loc_thisItemValue = "" />
		
		<cfloop collection="#loc_OutputStruct#" item="loc_thisItemName">
			<cfif IsSimpleValue( loc_OutputStruct[loc_thisItemName] )>
				<cfif NOT ListLen( Arguments.KeyList ) OR ( ListLen( Arguments.KeyList ) AND ListFindNoCase( Arguments.KeyList, loc_ThisItemName ) AND IsSimpleValue( loc_OutputStruct[loc_thisItemName] ) )>
					<cfset loc_ThisItemValue = REReplaceNoCase( loc_OutputStruct[loc_thisItemName], '<[^>]+>', '', 'all' ) />
					<cfset loc_OutputStruct[loc_thisItemName] = loc_ThisItemValue />
				</cfif>
			</cfif>
		</cfloop>
		
		<cfreturn loc_OutputStruct />
	</cffunction>
	
	<cffunction name="GetShortDescription" access="public" output="false" returntype="string">
		<cfargument name="Description" type="string" required="yes" />
		
		<cfset var loc_ShortDescription = TRIM( Arguments.Description ) />
		<cfset var loc_WordCount = "" />
		<cfset var loc_CurrentIndex = "" />
		<cfset var loc_SplitPosition = INT( this.DescriptionWordMax + 1 ) />
		
		<cfset loc_ShortDescription = STRIPCR( loc_ShortDescription ) />
		<cfset loc_ShortDescription = Replace( loc_ShortDescription, chr(32) & chr(32), chr(32), 'all') />
		
		<cfset loc_WordCount = ListLen( loc_ShortDescription, chr(32) ) />
		
		<cfif loc_WordCount GT this.DescriptionWordMax>
			<cfloop from="#loc_SplitPosition#" to="#loc_WordCount#" index="loc_CurrentIndex">
				<cfif ListLen( loc_ShortDescription, chr(32) ) GTE loc_SplitPosition>
					<cfset loc_ShortDescription = ListDeleteAt( loc_ShortDescription, loc_SplitPosition, chr(32) ) />
				</cfif>
			</cfloop>
			<cfset loc_ShortDescription = loc_ShortDescription & " ..." />
			<cfset loc_ShortDescription = TRIM( loc_ShortDescription ) />
		</cfif>
		
		<cfreturn loc_ShortDescription />
	</cffunction>
	
	<cffunction name="GetFormattedDescription" access="public" output="false" returntype="string">
		<cfargument name="Description" type="string" default="" />
		
		<cfset var loc_Description = TRIM( Arguments.Description ) />
		
		<cfset loc_Description = Replace( loc_Description, chr(10), "<br />", "all" ) />
		
		<cfreturn loc_Description />
	</cffunction>	
	
	<cffunction name="GetMaxRows" access="public" output="false" returntype="numeric">
		<cfreturn this.RowMax />
	</cffunction>
	
	<cffunction name="GetGridRows" access="public" output="false" returntype="struct">
		<cfargument name="page" type="numeric" default="1" />
		<cfargument name="rows" type="numeric" default="#Request.RecordsPerPage#" />
		
		<cfset var loc_startRow = ( ((arguments.page-1) * arguments.rows) + 1 ) />
		<cfset var loc_endRow = ( ((arguments.page-1) * arguments.rows) + arguments.rows ) /> 
		<cfset var loc_RowStruct = StructNew() />
		<cfset loc_RowStruct.StartRow = loc_startRow />
		<cfset loc_RowStruct.EndRow = loc_endRow />		
		
		<cfreturn loc_RowStruct />	
	</cffunction>
	
	<cffunction name="GetGridTotals" access="public" output="false" returntype="struct">
		<cfargument name="GridQuery" type="query" required="yes" />
		<cfargument name="page" type="numeric" default="1" />
		<cfargument name="rows" type="numeric" default="#Request.RecordsPerPage#" /> 
		
		<cfset var loc_Query = Arguments.GridQuery />
		<cfset var loc_total = 0 />
		<cfset var loc_records = 0 />
		<cfset var loc_TotalsStruct = StructNew() />
		
		<cfif IsNumeric( loc_Query.row_total )>
			<cfset loc_total = Ceiling(loc_Query.row_total/arguments.rows) />
			<cfset loc_records = loc_Query.row_total />
		</cfif>		
		
		<cfset loc_TotalsStruct.Page = Arguments.page />
		<cfset loc_TotalsStruct.Records = loc_records />
		<cfset loc_TotalsStruct.Total = loc_total />
		
		<cfreturn loc_TotalsStruct />	
	</cffunction>  
	
	<cffunction name="GetGridPagination" access="public" output="false" returntype="string">
		<cfargument name="TotalsStruct" type="struct" required="yes" />
		<cfargument name="RowsStruct" type="struct" required="yes" />
	
		<cfset var loc_Pagination = "" />
		<cfset var loc_Label = "" />
		<cfset var loc_Page = Arguments.TotalsStruct.Page />
		<cfset var loc_Total = Arguments.TotalsStruct.Total />
		<cfset var loc_Records = Arguments.TotalsStruct.Records />
		<cfset var loc_StartRow = Arguments.RowsStruct.StartRow />
		<cfset var loc_EndRow = Arguments.RowsStruct.EndRow />
		
		<cfif loc_EndRow GT Arguments.TotalsStruct.Records>
			<cfset loc_EndRow = Arguments.TotalsStruct.Records />
		</cfif>
	
		<cfif Arguments.TotalsStruct.Total GT 1>
			<cfif loc_StartRow EQ loc_Records>
				<cfset loc_Label = NumberFormat(loc_StartRow) />
			<cfelse>
				<cfset loc_Label = NumberFormat(loc_StartRow) & "-" & NumberFormat(loc_EndRow) />
			</cfif>
			<cfset loc_Label = loc_Label & " of " & NumberFormat(loc_Records) />
		
			<cfsavecontent variable="loc_Pagination">
				<cfoutput>
					<div class="pagination">
						<button dest="#loc_Page-1#" <cfif loc_Page EQ 1>disabled="disabled"</cfif>>&lt;</button>						
						<span>#loc_Label#</span>
						<button dest="#loc_Page+1#" <cfif loc_Page EQ loc_Total>disabled="disabled"</cfif>>&gt;</button>
					</div>
				</cfoutput>
			</cfsavecontent>
		</cfif>
		
		<cfreturn loc_Pagination />
	</cffunction>
	
	<cffunction name="GetListingPagination" access="public" output="false" returntype="string" hint="FRONT-END">
		<cfargument name="TotalsStruct" type="struct" required="yes" />
	
		<cfset var loc_Pagination = "" />
		<cfset var loc_PageIndex = "" />
		<cfset var loc_Page = Arguments.TotalsStruct.Page />
		<cfset var loc_Total = Arguments.TotalsStruct.Total />
		<cfset var loc_Records = Arguments.TotalsStruct.Records />
		<cfset var loc_PageList = "" />
	
		<cfif Arguments.TotalsStruct.Total GT 1>	

			<cfloop from="#(loc_Page - 2)#" to="#(loc_Page + 2)#" index="loc_PageIndex">
				<cfif loc_PageIndex GT 0 AND loc_PageIndex LTE loc_Total>
					<cfset loc_PageList = ListAppend( loc_PageList, loc_PageIndex ) />
				</cfif>
			</cfloop>
		
			<cfsavecontent variable="loc_Pagination">
				<cfoutput>
					<div class="wp-pagenavi">
						<span class="pages">Page #NumberFormat(loc_Page)# of #NumberFormat(loc_Total)#</span>
						<cfif loc_Page GT 1>
							<a href="##" class="nextpostslink" p="1" title="First">First</a>
							<a href="##" class="nextpostslink" p="#INT( loc_Page - 1 )#" title="Previous">&laquo;</a>
						</cfif>
						<cfloop list="#loc_PageList#" index="loc_PageIndex">
							<cfif loc_PageIndex EQ loc_Page>
								<span class="current">#NumberFormat(loc_PageIndex)#</span>
							<cfelse>
								<a href="##" class="page" p="#loc_PageIndex#">#NumberFormat(loc_PageIndex)#</a>
							</cfif>
						</cfloop>
						<cfif loc_Page LT loc_Total>
							<a href="##" class="nextpostslink" p="#INT( loc_Page + 1 )#" title="Next">&raquo;</a>
							<a href="##" class="nextpostslink" p="#loc_Total#" title="Next">Last</a>
						</cfif>
						<!---
							<span class="current">1</span>
							<a href="" class="page">2</a>
							<a href="" class="page">3</a>
							<a href="" class="page">4</a>
							<a href="" class="page">5</a>
							<a href="" class="nextpostslink">»</a>
							<a href="" class="larger page">10</a>
							<a href="" class="larger page">20</a>
							<span class="extend">...</span>
							<a href="" class="last">Last »</a>
						--->
					</div>
					
					<!---
						<button dest="#loc_Page-1#" <cfif loc_Page EQ 1>disabled="disabled"</cfif>>&lt;</button>						
						<span>#loc_Label#</span>
						<button dest="#loc_Page+1#" <cfif loc_Page EQ loc_Total>disabled="disabled"</cfif>>&gt;</button>
					--->
				</cfoutput>
			</cfsavecontent>
		</cfif>
		
		<cfreturn loc_Pagination />
	</cffunction>
	
	<cffunction name="GetRowsFoundLabel" access="public" returntype="string" output="no">
		<cfargument name="TotalsStruct" type="struct" required="yes" />
		
		<cfset var loc_Label = "" />
		
		<cfsavecontent variable="loc_Label">
			<strong><cfoutput>#NumberFormat( Arguments.TotalsStruct.Records )#</cfoutput></strong>&nbsp;
			<cfif Arguments.TotalsStruct.Records EQ 1>
				Result
			<cfelse>
				Results
			</cfif>
			found
		</cfsavecontent>
		
		<cfreturn loc_Label>
	</cffunction>
	
	<cffunction name="GetSubmitButtons" access="public" returntype="string" output="no">
		<cfargument name="UrlStruct" required="yes" type="struct" />
		
		<cfset var loc_Buttons = "" />		
		
		<cfsavecontent variable="loc_Buttons">
			<cfoutput>
				<div class="submitButtonContainer">
					<button type="button" class="cancel">Cancel</button>
					<cfif NOT StructKeyExists( Arguments.UrlStruct, "Type" ) 
						OR ( StructKeyExists( Arguments.UrlStruct, "Type" ) AND Arguments.UrlStruct["Type"] NEQ "view" )>
						<button type="submit" class="stay">Save and Keep Editing</button>
						<button type="submit" class="continue">Save and Return to List</button>
					</cfif>
				</div>
			</cfoutput>
		</cfsavecontent>
				
		<cfreturn loc_Buttons />
	</cffunction>
	
	<cffunction name="GetEditButtons" access="public" returntype="string" output="no">
		
		<cfset var loc_Buttons = "" />		
		
		<cfsavecontent variable="loc_Buttons">
			<cfoutput>
				<div class="submitSubButtonContainer">
					<button type="button" class="cancelSub">Cancel</button>
					<button type="submit" class="continueSub">Save</button>
				</div>
			</cfoutput>
		</cfsavecontent>
				
		<cfreturn loc_Buttons />
	</cffunction>
	
	<cffunction name="GetSelectBox" access="public" returntype="string" output="no">
		<cfargument name="FieldName" required="yes" type="string" />
		<cfargument name="FieldID" required="no" type="string" default="#Arguments.FieldName#" />
		<cfargument name="DataQuery" required="yes" type="query" />
		<cfargument name="QueryIDColumn" required="yes" type="string" />
		<cfargument name="QueryLabelColumn" required="yes" type="string" />
		<cfargument name="SelectedValue" required="no" type="any" default="" />
		<cfargument name="FirstLabel" required="no" type="any" default="-- Choose One --" />
		<cfargument name="IsDisabled" required="no" type="any" default="false" />
		
		<cfset var loc_thisId = "" />
		<cfset var loc_thisLabel = "" />
		
		<cfsavecontent variable="loc_Box">			
			<select 
				name="<CFOUTPUT>#Arguments.FieldName#</CFOUTPUT>" 
				id="<CFOUTPUT>#Arguments.FieldID#</CFOUTPUT>" 
				<cfif IsBoolean(Arguments.IsDisabled) AND Arguments.IsDisabled>disabled</cfif>
			>
				<option value=""><CFOUTPUT>#Arguments.FirstLabel#</CFOUTPUT></option>
				<cfoutput query="Arguments.DataQuery">
					<cfset loc_thisId = Arguments.DataQuery[Arguments.QueryIDColumn] />
					<cfset loc_thisLabel = Arguments.DataQuery[Arguments.QueryLabelColumn] />
					<option value="#loc_thisId#" <CFIF Arguments.SelectedValue EQ loc_thisId>selected="selected"</CFIF>>#loc_thisLabel#</option>
				</cfoutput>
			</select>
		</cfsavecontent>
		
		<cfreturn loc_Box />
	</cffunction>
	
	<cffunction name="GetStatusBox" access="public" returntype="string" output="no">
		<cfargument name="SelectedValue" required="no" default="" type="any" />
		<cfargument name="IdAttribute" required="no" default="" type="string" />
		
		<cfset var loc_Status = "" />
		<cfset var loc_FieldName = "Status" />
		<cfset var loc_ID = loc_FieldName />
		<cfset var loc_Box = "" />
		
		<cfif LEN(Arguments.IdAttribute)>
			<cfset loc_ID = Arguments.IdAttribute />
		</cfif>
		
		<cfquery name="loc_Status" datasource="#request.dsource#" cachedwithin="#CreateTimeSpan(0,2,0,0)#">
			SELECT		ID,
						Status
					
			FROM		AMP_Status
			
			ORDER BY	SortOrder
		</cfquery>
		
		<cfset loc_Box = GetSelectBox(
						FieldName:loc_FieldName, 
						FieldID:loc_ID,
						DataQuery:loc_Status, 
						QueryIDColumn:"ID", 
						QueryLabelColumn:"Status", 
						SelectedValue:Arguments.SelectedValue ) />
		
		<cfreturn loc_Box />
	</cffunction>
	
	<cffunction name="GetBooleanBox" access="public" returntype="string" output="no">
		<cfargument name="FieldName" required="yes" type="string" />		
		<cfargument name="SelectedValue" required="no" default="" type="any" />
		<cfargument name="IdAttribute" required="no" default="" type="string" />
		
		<cfset var loc_options = "">
		<cfset var loc_Box = "">
		<cfset var loc_ID = Arguments.FieldName />
		
		<cfif LEN(Arguments.IdAttribute)>
			<cfset loc_ID = Arguments.IdAttribute />
		</cfif>
		
		<cfquery name="loc_options" datasource="#request.dsource#" cachedwithin="#CreateTimeSpan(0,2,0,0)#">
			SELECT	1 AS ID,
					'Yes' AS Label
			UNION
			SELECT	0 AS ID,
					'No' AS Label
		</cfquery>
		
		<cfset loc_Box = GetSelectBox(
						FieldName:Arguments.FieldName, 
						FieldID:loc_ID,
						DataQuery:loc_options, 
						QueryIDColumn:"ID", 
						QueryLabelColumn:"Label", 
						SelectedValue:Arguments.SelectedValue ) />
		
		<cfreturn loc_Box />
	</cffunction>
	
	<cffunction name="GetTimeBoxes" access="public" returntype="string" output="no">
		<cfargument name="FieldName" required="yes" type="string" />	
		<cfargument name="SelectedValue" required="no" default="" type="any" />
		
		<cfset var loc_Boxes = "" />
		<cfset var loc_FirstLabel = "--" />
		<cfset var loc_ThisIndex = "" />
		<cfset var loc_ThisValue = "" />
		<cfset var loc_ThisLabel = "" />
		<cfset var loc_SelectedValue = Arguments.SelectedValue />
		<cfset var loc_SelectedHour = "" />
		<cfset var loc_SelectedMinute = "" />
		<cfset var loc_SelectedMeridian = "" />
		
		<cfif ListLen( loc_SelectedValue, this.TimeDelimiter ) GTE 2>
			<cfset loc_SelectedHour = ListGetAt( loc_SelectedValue, 1, this.TimeDelimiter ) />
			<cfset loc_SelectedMinute = ListGetAt( loc_SelectedValue, 2, this.TimeDelimiter ) />
		
			<cfif loc_SelectedHour LT 12>
				<cfset loc_SelectedMeridian = ListFirst( this.MeridianList ) />
			<cfelse>
				<cfset loc_SelectedHour = NumberFormat( loc_SelectedHour - 12, "00" ) />
				<cfset loc_SelectedMeridian = ListLast( this.MeridianList ) />
			</cfif>		
		</cfif>
			
		<cfsavecontent variable="loc_Boxes">			
			<CFOUTPUT>
			<select name="#Arguments.FieldName##this.TimeFieldSuffix.Hour#" class="timebox">
				<option value="">#loc_FirstLabel#</option>
				<cfloop from="1" to="#ListLen(this.HourValuesList)#" index="loc_thisIndex">
					<cfset loc_ThisValue = ListGetAt( this.HourValuesList, loc_thisIndex ) />
					<cfset loc_ThisLabel = NumberFormat( loc_ThisValue, "00" ) />
					<option value="#loc_ThisLabel#" <cfif loc_ThisValue EQ loc_SelectedHour>selected="selected"</cfif>>#loc_ThisValue#</option>
				</cfloop>
			</select>
			<select name="#Arguments.FieldName##this.TimeFieldSuffix.Minute#" class="timebox">
				<option value="">#loc_FirstLabel#</option>
				<cfloop from="#this.MinuteValues.Min#" to="#this.MinuteValues.Max#" index="loc_thisIndex">
					<cfset loc_ThisValue = loc_thisIndex />
					<cfset loc_ThisLabel = NumberFormat( loc_ThisValue, "00" ) />
					<option value="#loc_ThisLabel#" <cfif loc_ThisValue EQ loc_SelectedMinute>selected="selected"</cfif>>#loc_ThisLabel#</option>
				</cfloop>
			</select>
			<select name="#Arguments.FieldName##this.TimeFieldSuffix.Meridian#" class="timebox">
				<option value="">#loc_FirstLabel#</option>
				<cfloop from="1" to="#ListLen(this.MeridianList)#" index="loc_thisIndex">
					<cfset loc_ThisValue = ListGetAt( this.MeridianList, loc_thisIndex ) />
					<option value="#loc_ThisValue#" <cfif loc_ThisValue EQ loc_SelectedMeridian>selected="selected"</cfif>>#loc_ThisValue#</option>
				</cfloop>
			</select>
			</CFOUTPUT>
		</cfsavecontent>
		
		<cfreturn loc_Boxes />
	</cffunction>
	
	<cffunction name="GetDateTimeString" access="public" output="true" returntype="string"> 
		<cfargument name="FormStruct" type="struct" required="yes" />
		<cfargument name="DateFieldName" type="string" required="yes" />
		<cfargument name="TimeFieldName" type="string" required="yes" />
		
		<cfset var loc_DateTime = "" />
		<cfset var loc_Date = "" />
		<cfset var loc_Time = StructNew() />
		
		<cfset loc_Date = DateFormat( Arguments.FormStruct[ Arguments.DateFieldName ], "mm/dd/yyyy" ) />
		
		<cfset loc_Time.Hour = Arguments.FormStruct[ Arguments.TimeFieldName & this.TimeFieldSuffix.Hour ] />
		<cfset loc_Time.Minute = Arguments.FormStruct[ Arguments.TimeFieldName & this.TimeFieldSuffix.Minute ] />
		<cfset loc_Time.Meridian = Arguments.FormStruct[ Arguments.TimeFieldName & this.TimeFieldSuffix.Meridian ] />
		
		<cfif IsDate( loc_Date )>
			<cfset loc_DateTime = loc_Date & " " & loc_Time.Hour & this.TimeDelimiter & loc_Time.Minute & this.TimeDelimiter & "00 " & loc_Time.Meridian />
		<cfelse>
			<cfset loc_DateTime = "" />
		</cfif>
		
		<cfreturn loc_DateTime />		
	</cffunction>
	
	<cffunction name="GetSortOptionsBox" access="public" returntype="string" output="no">
		<cfargument name="SortOptionsArray" type="array" required="yes" />
		<cfargument name="SelectedValue" required="no" default="" type="any" />
		<cfargument name="FirstLabel" required="no" type="any" default="" />
		
		<cfset var loc_Box = "" />
		<cfset var loc_ThisIndex = "" />
		<cfset var loc_ThisValue = "" />
		<cfset var loc_ThisLabel = "" />
		
		<cfsavecontent variable="loc_Box">			
			<cfoutput>
			<select name="Sort" id="Sort">
				<cfif LEN( Arguments.FirstLabel )>
					<option value="">#Arguments.FirstLabel#</option>
				</cfif>
				<cfloop from="1" to="#ArrayLen(Arguments.SortOptionsArray)#" index="loc_thisIndex">
					<cfset loc_ThisValue = Arguments.SortOptionsArray[loc_thisIndex][1] />
					<cfset loc_ThisLabel = Arguments.SortOptionsArray[loc_thisIndex][2] />
					<option value="#loc_ThisValue#" <CFIF Arguments.SelectedValue EQ loc_ThisValue>selected="selected"</CFIF>>#loc_ThisLabel#</option>
				</cfloop>
			</select>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn loc_Box />
	</cffunction>
	
	<cffunction name="GetSortColumn" access="public" returntype="string" output="no">
		<cfargument name="SortOptionsArray" type="array" required="yes" />
		<cfargument name="Sort" type="string" required="no" default="" />
		
		<cfset var loc_SortColumn = Arguments.SortOptionsArray[1][3] />
		<cfset var loc_ThisIndex = "" />
		
		<cfloop from="1" to="#ArrayLen(Arguments.SortOptionsArray)#" index="loc_thisIndex">
			<cfif Arguments.SortOptionsArray[loc_thisIndex][1] EQ Arguments.Sort>
				<cfset loc_SortColumn = Arguments.SortOptionsArray[loc_thisIndex][3] />
			</cfif>
		</cfloop>
		
		<cfreturn loc_SortColumn />
	</cffunction>
	
	<cffunction name="GetQueryRowAsStruct" access="public" returntype="struct" output="no">
		<cfargument name="InputQuery" type="query" required="yes" />
		<cfargument name="RowIndex" type="numeric" required="yes" />
		
		<cfset loc_Query = Arguments.InputQuery />
		<cfset loc_RowIndex = Arguments.RowIndex />
		<cfset loc_ColumnList = loc_Query.ColumnList />
		<cfset loc_ColumnIndex = loc_Query.ColumnList />
		<cfset loc_Struct = StructNew() />
		
		<cfloop list="#loc_ColumnList#" index="loc_ColumnIndex">
			<cfset loc_Struct[loc_ColumnIndex] = loc_Query[loc_ColumnIndex] />
		</cfloop>
		
		<cfreturn loc_Struct />		
	</cffunction>
	
	<cffunction name="GetSearchTerm" access="public" returntype="string" output="no">
		<cfargument name="CurrentSearchText" type="string" required="yes" />
		<cfargument name="DefaultSearchText" type="string" required="yes" />
		
		<cfset var loc_SearchText = TRIM( Arguments.CurrentSearchText ) />
		
		<cfif NOT LEN( loc_SearchText )>
			<cfset loc_SearchText = Arguments.DefaultSearchText />
		</cfif>
		
		<cfreturn loc_SearchText />
	</cffunction>	
	
	<cffunction name="GetCaptchaFields" access="public" returntype="string" output="no">
	
		<cfset var loc_CaptchaText = GetRandomString( StringLength:this.CaptchaSettings.StringLength ) />
		<cfset var loc_EncryptedString = GetHashedValue( InputValue:loc_CaptchaText ) />
		<cfset var loc_CaptchaImage = ImageNew( "", this.CaptchaSettings.Width, this.CaptchaSettings.Height, "rgb", this.CaptchaSettings.BackgroundColor ) />
		<cfset var loc_ThisLetter = "" />
		<cfset var loc_ThisDrawingAngle = "" />
		<cfset var loc_ThisXOffset = "" />
		<cfset var loc_CaptchaFields = "" />		
		<cfset var loc_ThisIndex = "" />
		<cfset var loc_ImageFileName = "" />
		<cfset var loc_ImageServerPath = "" />
		<cfset var loc_ImageWebPath = "" />
		
		<cfscript>
			
			ImageSetAntialiasing( loc_CaptchaImage, "on" );
			ImageSetDrawingColor( loc_CaptchaImage, this.CaptchaSettings.TextColor );
			
			for( loc_ThisIndex = 1; loc_ThisIndex LTE LEN( loc_CaptchaText ); loc_ThisIndex++) {
			
				loc_ThisLetter = MID( loc_CaptchaText, loc_ThisIndex, 1 );
				loc_ThisDrawingAngle = RandRange( this.CaptchaSettings.MinDrawingAngle, this.CaptchaSettings.MaxDrawingAngle );
				loc_ThisXOffset = 10 + ( (loc_ThisIndex-1) * (this.CaptchaSettings.TextAttributes.Size * 1.5) );
			
				/* set rotation for this letter */
				ImageRotateDrawingAxis( loc_CaptchaImage, loc_ThisDrawingAngle );
						
				/* render this letter */
				ImageDrawText( loc_CaptchaImage, loc_ThisLetter, loc_ThisXOffset, (this.CaptchaSettings.TextAttributes.Size * 1.25), this.CaptchaSettings.TextAttributes );
				
				/* set counter-rotation for this letter */
				ImageRotateDrawingAxis( loc_CaptchaImage, -loc_ThisDrawingAngle );
				
			}
			
			loc_ImageFileName = loc_EncryptedString & this.CaptchaSettings.FileExtension;
			loc_ImageServerPath = REQUEST.Root.Captcha & loc_ImageFileName;
			loc_ImageWebPath = REQUEST.Web.Captcha & loc_ImageFileName;
			
			ImageWrite( loc_CaptchaImage, loc_ImageServerPath );
		</cfscript>
		
		<cfsavecontent variable="loc_CaptchaFields">
			<cfoutput>
				<input type="hidden" name="ValidationKey" value="#loc_EncryptedString#"  />
				<span class="captchaImage">
					<img src="#loc_ImageWebPath#" />
				</span>
				<input type="text" name="InputKey" class="captchaInput" value="" />
			</cfoutput>
		</cfsavecontent>
			
		<cfreturn loc_CaptchaFields />
	
	</cffunction>
	
	<cffunction name="ValidateCaptcha" access="public" returntype="void" output="no">
		<cfargument name="ValidationKey" type="string" required="yes" />
		<cfargument name="InputKey" type="string" required="yes" />
		
		<cfset var loc_ValidationKey = Arguments.ValidationKey />
		<cfset var loc_InputKey = Arguments.InputKey />
		<cfset var loc_EncryptedInput = GetHashedValue( InputValue:loc_InputKey ) />
		
		<cfif loc_EncryptedInput NEQ loc_ValidationKey>
			<!--- cfset AnnounceEvent( 'AuthorizationFailure' ) / --->
			<cflocation url="/authorization-failure.html" addtoken="no" />
		</cfif>
		
	</cffunction>
	
	<cffunction name="GetItemOriginal" access="public" output="false" returntype="string">    
		<cfargument name="ItemKey" type="string" required="yes" />
		<cfargument name="ItemID" default="0" />
		
		<cfset var loc_Key = Arguments.ItemKey />		
		<cfset var loc_ItemID = Arguments.ItemID />
		<cfset var loc_ItemPath = Request.Root[loc_Key].Original & loc_ItemID & ".jpg" />
		<cfset var loc_ItemOriginal = "" />
		
		<cfif FileExists( loc_ItemPath )>
			<cfset loc_ItemOriginal = "/images/" & loc_Key & "/original/" & loc_ItemID & ".jpg" />
		</cfif>
		
		<cfreturn loc_ItemOriginal />
	</cffunction>
	
	<cffunction name="GetItemThumbnail" access="public" output="true" returntype="string">    
		<cfargument name="ItemKey" type="string" required="yes" />
		<cfargument name="ItemID" default="0" />
		
		<cfset var loc_Key = Arguments.ItemKey />		
		<cfset var loc_ItemID = Arguments.ItemID />
		<cfset var loc_ItemPath = Request.Root[loc_Key].Thumbnail & loc_ItemID & ".jpg" />
		<cfset var loc_ItemThumbnail = "" />		
		
		<cfif FileExists( loc_ItemPath )>
			<cfset loc_ItemThumbnail = "/images/" & loc_Key & "/thumb/" & loc_ItemID & ".jpg" />
		<cfelse>
			<cfswitch expression="#loc_Key#">
				<cfcase value="user">
					<cfset loc_ItemThumbnail = "/images/img-user-image-default.jpg" />
				</cfcase>
			</cfswitch>
		</cfif>
		
		<cfreturn loc_ItemThumbnail />
	</cffunction>
	
	<cffunction name="GetItemFullsize" access="public" output="false" returntype="string">    
		<cfargument name="ItemKey" type="string" required="yes" />
		<cfargument name="ItemID" default="0" />
		
		<cfset var loc_Key = Arguments.ItemKey />		
		<cfset var loc_ItemID = Arguments.ItemID />
		<cfset var loc_ItemPath = Request.Root[loc_Key].Fullsize & loc_ItemID & ".jpg" />
		<cfset var loc_ItemFullsize = "" />
		
		<cfif FileExists( loc_ItemPath )>
			<cfset loc_ItemFullsize = "/images/" & loc_Key & "/full/" & loc_ItemID & ".jpg" />
		</cfif>
		
		<cfreturn loc_ItemFullsize />
	</cffunction>
	
	<cffunction name="CreateImageVariations" access="public" output="false" returntype="void"> 
		<cfargument name="ItemKey" type="string" required="yes" />
		<cfargument name="ItemID" type="numeric" required="yes" />
	
		<cfset var loc_Key = Arguments.ItemKey />		
		<cfset var loc_ItemID = Arguments.ItemID />
		<cfset var loc_ItemPath = StructNew() />
	
		<cfscript>
		
			loc_ItemPath.Original = Request.Root[loc_Key].Original & loc_ItemID & ".jpg";
			loc_ItemPath.Fullsize = Request.Root[loc_Key].Fullsize & loc_ItemID & ".jpg";
			loc_ItemPath.Thumbnail = Request.Root[loc_Key].Thumbnail & loc_ItemID & ".jpg";
			
			/* get original image to manipulate into thumbnail */
			loc_OriginalImage = ImageRead(loc_ItemPath.Original);
			
			/* resize thumbnail */
			if ( ImageGetWidth(loc_OriginalImage) NEQ Request.Images.Marketplace.ThumbnailWidth ) {
				ImageScaleToFit(loc_OriginalImage, Request.Images.Marketplace.ThumbnailWidth, '');
			}
			
			/* write thumbnail to disk */
			ImageWrite(loc_OriginalImage, loc_ItemPath.Thumbnail);
		
			/* get original image to manipulate into fullsize */
			loc_OriginalImage = ImageRead(loc_ItemPath.Original);
			
			/* resize fullsize */
			if ( ImageGetWidth(loc_OriginalImage) GT Request.Images.Marketplace.FullsizeWidth ) {
				ImageScaleToFit(loc_OriginalImage, Request.Images.Marketplace.FullsizeWidth, '');
			}
			
			/* write fullsize to disk */
			ImageWrite(loc_OriginalImage, loc_ItemPath.Fullsize);
			
		</cfscript>
	</cffunction>
	
	<cffunction name="jsFormat" access="private" returntype="string" output="no">
		<cfargument name="InputString" type="string" required="yes" />
		
		<cfset var loc_Output = Arguments.InputString />
		
		<cfset loc_Output = StripCR( loc_Output ) />
		
		<!--- escape double quotes --->
		<cfset loc_output = replace( loc_output, chr(34), "\" & chr(34), "all" ) />
		
		<cfreturn loc_Output />		
	</cffunction>
	
	<cffunction name="RenderSectionNavigation" access="public" returntype="string" output="no">
		<cfargument name="SectionArray" type="array" required="yes" />
		
		<cfset var loc_SectionContent = "" />
		<cfset var loc_thisSection = "" />
		<cfset var loc_SectionArray = Arguments.SectionArray />
		
		<cfsavecontent variable="loc_SectionContent"><cfoutput>
			<ul class="TabbedTopPanelsTabGroup">
			<cfloop from="1" to="#ArrayLen(loc_SectionArray)#" index="loc_thisSection">
   				<li class="TabbedTopPanelsTab <CFIF StructKeyExists(URL, "Event") AND URL.Event EQ loc_SectionArray[loc_thisSection].Key>active</CFIF>">
					<a href="index.cfm?event=#loc_SectionArray[loc_thisSection].Key#">#loc_SectionArray[loc_thisSection].Label#</a>
				</li>
   			</cfloop>   
			</ul>
		</cfoutput></cfsavecontent>
		
		<cfreturn loc_SectionContent />
	
	</cffunction>
	
	<cffunction name="SendContactForm" access="public" output="true" returntype="void">    
		<cfargument name="AccountID" type="numeric" required="yes" />
		<cfargument name="FirstName" type="string" required="yes" />
		<cfargument name="LastName" type="string" required="yes" />
		<cfargument name="Email" type="string" required="yes" />
		<cfargument name="PhoneNumber" type="string" required="yes" />
		<cfargument name="Comments" type="string" required="yes" />
		
		<cfset var loc_thisFieldName = "" />
		<cfset var loc_thisFieldValue = "" />
		<cfset var loc_AccountID = Arguments.AccountID />
		
		<cfif loc_AccountID EQ 0>
			<cfset loc_AccountID = "N/A" />
		</cfif>
		
		<cftry>
			<cfmail		to="#Request.Admin_Email#"
						from="#Request.Sender_Email#"
						subject="User Contact Request from #Request.SiteLabel#">You have received the following contact request:
						
Account ID: #loc_AccountID#

First Name: #Arguments.FirstName#

Last Name: #Arguments.LastName#

E-mail: #Arguments.Email#

Phone Number: #Arguments.PhoneNumber#

Comments: #Arguments.Comments#
			</cfmail>
		<cfcatch type="any">
			<cflocation url="/contact-error.html" addtoken="no" />	
		</cfcatch>
		</cftry>
		
		<cflocation url="/contact-sent.html" addtoken="no" />	
		
	</cffunction>	
		
</cfcomponent>
