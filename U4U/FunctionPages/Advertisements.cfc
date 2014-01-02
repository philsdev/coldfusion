<cfcomponent extends="MachII.framework.Listener">

	<cfscript>
		this.SortOptions = ArrayNew(1);
		
		this.SortOptions[1] = ["title","Title","AD.Title"];
		this.SortOptions[2] = ["type","Title","ADT.Title"];
		this.SortOptions[3] = ["size","Title","ADS.Title"];	
		this.SortOptions[4] = ["costperclick","PPC","ISNULL(AD.CostPerClick,0)"];
		this.SortOptions[5] = ["costperthousandimpressions","PPM","ISNULL(AD.CostPerThousandImpressions,0)"];
		this.SortOptions[6] = ["budget","Budget","ISNULL(AD.Budget,0)"];
		this.SortOptions[7] = ["budgetused","BudgetUsed","ISNULL(SUM(CASE WHEN TRACKING.IsBillable = 1 THEN COST ELSE 0 END),0)"];	
		this.SortOptions[8] = ["billableimpressions","Billable Impressions","ISNULL(SUM(CASE WHEN TRACKING.MonetizationModelID = 1 AND TRACKING.IsBillable = 1 THEN 1 ELSE 0 END),0)"];	
		this.SortOptions[9] = ["nonbillableimpressions","Non-Billable Impressions","ISNULL(SUM(CASE WHEN TRACKING.MonetizationModelID = 1 AND TRACKING.IsBillable = 0 THEN 1 ELSE 0 END),0)"];	
		this.SortOptions[10] = ["billableclicks","Billable Clicks","ISNULL(SUM(CASE WHEN TRACKING.MonetizationModelID = 2 AND TRACKING.IsBillable = 1 THEN 1 ELSE 0 END),0)"];	
		this.SortOptions[11] = ["nonbillableclicks","Non-Billable Clicks","ISNULL(SUM(CASE WHEN TRACKING.MonetizationModelID = 2 AND TRACKING.IsBillable = 0 THEN 1 ELSE 0 END),0)"];	
		this.SortOptions[12] = ["ishouseadvertisement","House Ad?","AD.IsHouseAdvertisement"];
		this.SortOptions[13] = ["username","Username","A.Username"];		
		this.SortOptions[14] = ["datecreated","Date Created","AD.DateCreated"];
		this.SortOptions[15] = ["status","Status","ST.Status"];
		
		this.UniqueUserHourThrottle = Request.UniqueUserHourThrottle;
		this.CostMask = "999999.09";
		this.DefaultSearchText = "Search Advertisements";
	</cfscript>
	
	<cffunction name="GetDefaultSearchText" access="public" output="false" returntype="string">
		<cfreturn this.DefaultSearchText />
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
	
	<cffunction name="GetAdvertisementTypes" access="public" output="false" returntype="query">    
        
		<cfset var loc_AdvertisementTypes = "" />
        
		<cfquery datasource="#request.dsource#" name="loc_AdvertisementTypes">
			SELECT		ID,
						Title + ' (.' + FileExtension + ')' AS Title
			
			FROM		AMP_AdvertisementTypes
			
			ORDER BY	Title
		</cfquery>		
		
		<cfreturn loc_AdvertisementTypes />
	</cffunction> 
	
	<cffunction name="GetAdvertisementSizes" access="public" output="false" returntype="query">    
        
		<cfset var loc_AdvertisementSizes = "" />
        
		<cfquery datasource="#request.dsource#" name="loc_AdvertisementSizes">
			SELECT		ID,
						Title + ' (' + CAST(Width AS VARCHAR(10)) + 'x' + CAST(Height AS VARCHAR(10)) + ')' AS Title
			
			FROM		AMP_AdvertisementSizes
			
			ORDER BY	Title
		</cfquery>		
		
		<cfreturn loc_AdvertisementSizes />
	</cffunction> 
	
	<cffunction name="GetAdvertisementPlacements" access="public" output="false" returntype="query">    
        
		<cfset var loc_AdvertisementPlacements = "" />
        
		<cfquery datasource="#request.dsource#" name="loc_AdvertisementPlacements">
			SELECT		ID,
						Title
			
			FROM		AMP_AdvertisementPlacements
			
			ORDER BY	Title
		</cfquery>		
		
		<cfreturn loc_AdvertisementPlacements />
	</cffunction> 
	
	<cffunction name="GetMonetizationModels" access="public" output="no" returntype="query">    
        
		<cfset var loc_Models = "" />
        
		<cfquery datasource="#request.dsource#" name="loc_Models">
			SELECT		ID,
						Title
			FROM		AMP_MonetizationModels
		</cfquery>
		
		<cfreturn loc_Models />
	</cffunction>
		
	<cffunction name="GetAdvertisements" access="public" output="yes" returntype="query">    
		<cfargument name="StartRow" type="numeric" default="1" />
		<cfargument name="EndRow" type="numeric" default="#Request.RecordsPerPage#" /> 
		<cfargument name="Title" type="string" default="" />
		<cfargument name="DateCreated" type="string" default="" />
		<cfargument name="Size" type="string" default="" />
		<cfargument name="Type" type="string" default="" />
		<cfargument name="User" type="string" default="" />
		<cfargument name="Username" type="string" default="" />
		<cfargument name="SearchTerm" type="string" default="" />
		<cfargument name="Status" type="string" default="" />
		<cfargument name="sidx" type="string" required="no" default="#this.SortOptions[1][3]#" />
		<cfargument name="sord" type="string" required="no" default="desc" />
        
		<cfset var loc_Advertisements = "" />
		<cfset var loc_SearchTerm = TRIM( Arguments.SearchTerm ) />
		
		<cfif loc_SearchTerm EQ this.DefaultSearchText>
			<cfset loc_SearchTerm = "" />
		<cfelseif LEN(loc_SearchTerm)>
			<cfset loc_SearchTerm = "%" & Arguments.SearchTerm & "%" />
		</cfif>
        
		<cfquery datasource="#request.dsource#" name="loc_Advertisements">
			SELECT		*
			FROM  (
					  
						SELECT			ROW_NUMBER() OVER ( ORDER BY #Arguments.sidx# ) AS RowNum,
										COUNT(*) OVER () as Row_Total,
										AD.ID,
										AD.Title,
										CONVERT(CHAR(10),AD.DateCreated,101) AS DateCreated,
										ADT.Title AS Type,
										ADS.Title AS Size,
										ADS.Width AS Width,
										ADS.Height AS Height,
										AD.MonetizationModelID,
										M.Title as MonetizationModel,
										ISNULL(AD.CostPerClick,0) AS CostPerClick,
										ISNULL(AD.CostPerThousandImpressions,0) AS CostPerThousandImpressions,
										ISNULL(AD.CostPerImpression,0) AS CostPerImpression,
										ISNULL(AD.Budget,0) AS Budget,
										ISNULL(SUM(CASE WHEN TRACKING.IsBillable = 1 THEN COST ELSE 0 END),0) AS BudgetUsed,
										ISNULL(SUM(CASE WHEN TRACKING.MonetizationModelID = 1 AND TRACKING.IsBillable = 1 THEN 1 ELSE 0 END),0) AS BillableImpressions,
										ISNULL(SUM(CASE WHEN TRACKING.MonetizationModelID = 1 AND TRACKING.IsBillable = 0 THEN 1 ELSE 0 END),0) AS NonBillableImpressions,
										ISNULL(SUM(CASE WHEN TRACKING.MonetizationModelID = 1 THEN 1 ELSE 0 END),0) AS TotalImpressions,
										ISNULL(SUM(CASE WHEN TRACKING.MonetizationModelID = 2 AND TRACKING.IsBillable = 1 THEN 1 ELSE 0 END),0) AS BillableClicks,
										ISNULL(SUM(CASE WHEN TRACKING.MonetizationModelID = 2 AND TRACKING.IsBillable = 0 THEN 1 ELSE 0 END),0) AS NonBillableClicks,
										ISNULL(SUM(CASE WHEN TRACKING.MonetizationModelID = 2 THEN 1 ELSE 0 END),0) AS TotalClicks,	
										A.Username,
										AD.IsHouseAdvertisement,
										ST.Status
						
						FROM			AMP_Advertisements AD						
						JOIN			AMP_Accounts A ON AD.UserID = A.ID
						JOIN			AMP_AdvertisementTypes ADT ON AD.TypeID = ADT.ID
						JOIN			AMP_AdvertisementSizes ADS ON AD.SizeID = ADS.ID
						JOIN			AMP_MonetizationModels M ON AD.MonetizationModelID = M.ID
						JOIN			AMP_Status ST ON AD.Status = ST.ID
						LEFT JOIN		AMP_AdvertisementPlacementSelections APS ON AD.ID = APS.AdvertisementID
						LEFT JOIN		AMP_AdvertisementLocationSelections ALS ON AD.ID = ALS.AdvertisementID
						LEFT JOIN		AMP_AdvertisementTracking TRACKING ON AD.ID = TRACKING.AdvertisementID
												
						WHERE			1=1
					<cfif Len(Arguments.Title)>
							AND			AD.Title LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.Title#%" />		
					</cfif>
					<cfif IsDate(Arguments.DateCreated)>
							AND			AD.DateCreated = <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.DateCreated#" />		
					</cfif>
					<cfif IsNumeric(Arguments.Type)>
						AND				AD.TypeID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Type#" />		
					</cfif>
					<cfif IsNumeric(Arguments.Size)>
						AND				AD.SizeID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Size#" />		
					</cfif>
					<cfif IsNumeric(Arguments.User)>
						AND				AD.UserID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.User#" />		
					</cfif>
					<cfif LEN(Arguments.Username)>
						AND				A.Username LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.Username#%" />		
					</cfif>
					<cfif IsBoolean(Arguments.Status)>
						AND				AD.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />		
					</cfif>
					
					<cfif LEN( loc_SearchTerm )>
						AND			(
										AD.Title LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#loc_SearchTerm#" />		
										OR
										AD.Description LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#loc_SearchTerm#" />
									)
					</cfif>
					
					<cfif Request.IsFrontEnd>
						AND				AD.UserID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.User#" />
					</cfif>
					
						GROUP BY		AD.ID,
										AD.Title,
										AD.DateCreated,
										ADT.Title,
										ADS.Title,
										ADS.Width,
										ADS.Height,
										AD.MonetizationModelID,
										M.Title,
										AD.CostPerClick,
										AD.CostPerThousandImpressions,
										AD.CostPerImpression,
										AD.Budget,
										A.Username,
										AD.IsHouseAdvertisement,
										ST.Status
					
			) AS RowConstrainedResult

			WHERE		RowNum >= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.StartRow#" />
			AND			RowNum <= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.EndRow#" />
			
			ORDER BY 	RowNum	
		</cfquery>
		
		<cfreturn loc_Advertisements />
	</cffunction>
	
	<cffunction name="GetAdvertisementDetails" access="public" output="true" returntype="query">    
		<cfargument name="AdvertisementID" default="0" />
        
		<cfset var loc_Advertisement = "" />
        
		<cfquery datasource="#request.dsource#" name="loc_Advertisement">
			SELECT		ID,
						Title,
						Description,
						SizeID,
						TypeID,
						UserID,
						Budget,
						CostPerClick,
						CostPerThousandImpressions,
						IsHouseAdvertisement,
						DestinationUrl,
						Status
			
			FROM		AMP_Advertisements
			
			WHERE		ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AdvertisementID#" />
		</cfquery>
		
		<cfreturn loc_Advertisement />
	</cffunction> 
	
	<cffunction name="GetAdvertisementPlacement" access="public" output="false" returntype="query">    
		<cfargument name="PlacementID" type="numeric" required="yes" />
		<cfargument name="LocationID" type="numeric" required="yes" />
		<cfargument name="AdvertisementCount" default="1" />
	
		<cfset var loc_Placement = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_Placement" maxrows="#Arguments.AdvertisementCount#">	
			SELECT			AD.ID,
							ABS(CAST(CAST(NEWID() AS VARBINARY) AS INT)) AS SortOrder,
							AD.Title,
							AD.DestinationUrl,
							AD.CostPerImpression AS CostPerImpression,
							ADT.Title AS [Type],
							ADT.FileExtension,
							ADS.Width AS Width,
							ADS.Height AS Height,
							APS.PlacementID,
							AD.IsHouseAdvertisement

			FROM			AMP_Advertisements AD				
			JOIN			AMP_AdvertisementTypes ADT ON AD.TypeID = ADT.ID
			JOIN			AMP_AdvertisementSizes ADS ON AD.SizeID = ADS.ID			
			
			JOIN			AMP_AdvertisementPlacementSelections APS 
			ON				AD.ID = APS.AdvertisementID 
			AND				APS.PlacementID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PlacementID#" />
			
			LEFT JOIN		AMP_AdvertisementLocationSelections ALS
			ON				AD.ID = ALS.AdvertisementID 
			AND				(
								ALS.LocationID IS NULL
								OR
								ALS.LocationID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LocationID#" />
							)
							
			LEFT JOIN		(
								SELECT		SUM(CASE WHEN IsBillable = 1 THEN Cost ELSE 0 END) as BudgetUsed,
											AdvertisementID
								FROM		AMP_AdvertisementTracking
								WHERE		IsBillable = 1
								GROUP BY	AdvertisementID
							) TRACKING ON AD.ID = TRACKING.AdvertisementID

			WHERE			AD.Status = 1
			AND				(
								( 
									AD.IsHouseAdvertisement = 0
									AND ISNULL(TRACKING.BudgetUsed,0) <= AD.Budget 
								)
								OR
								AD.IsHouseAdvertisement = 1
							)
			AND				(
								AD.StartDate IS NULL 
								OR 
								DATEDIFF( DAY, AD.StartDate, GETDATE() ) >= 0
							)
			AND				(
								AD.EndDate IS NULL 
								OR 
								DATEDIFF( DAY, AD.EndDate, GETDATE() ) <= 0
							)
			
			ORDER BY		IsHouseAdvertisement,
							SortOrder
		</cfquery>		
		
		<cfreturn loc_Placement />
	</cffunction>
	
	<cffunction name="GetAdvertisementCost" access="public" output="false" returntype="numeric">    
		<cfargument name="AdvertisementID" type="numeric" required="yes" />
		<cfargument name="MonetizationModelID" type="numeric" required="yes" />
	
		<cfset var loc_Cost = "" />
		<cfset var loc_Action = "" />
		
		<cfswitch expression="#Arguments.MonetizationModelID#">
			<cfcase value="1">
				<cfset loc_Action = "CostPerImpression" />
			</cfcase>
			<cfdefaultcase>
				<cfset loc_Action = "CostPerClick" />
			</cfdefaultcase>
		</cfswitch>
		
		<cfquery datasource="#request.dsource#" name="loc_Cost">	
			SELECT			ISNULL(#loc_Action#,0) AS Cost

			FROM			AMP_Advertisements
			WHERE			ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AdvertisementID#" />
			AND				Status = 1
		</cfquery>		
		
		<cfreturn loc_Cost.Cost />
	</cffunction>
	
	<cffunction name="TrackAdvertisement" access="public" output="false" returntype="void">    
		<cfargument name="AdvertisementID" type="numeric" required="yes" />
		<cfargument name="LocationID" type="numeric" required="yes" />
		<cfargument name="MonetizationModelID" type="numeric" required="yes" />
		<cfargument name="PlacementID" type="numeric" required="yes" />
		<cfargument name="Cost" type="numeric" required="yes" />
		
		<cfset var loc_AdvertisementTracking = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_AdvertisementTracking">	
			DECLARE @USERTRACKINGCOUNT AS INT;
			DECLARE @COST AS DECIMAL(18,3);
			DECLARE @ISBILLABLE AS BIT;
		
			SET @USERTRACKINGCOUNT = (
				SELECT		COUNT(*) AS Total
				FROM		AMP_AdvertisementTracking
				WHERE		AdvertisementID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AdvertisementID#" />
				AND			MonetizationModelID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MonetizationModelID#" />
				AND			IPAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_HOST#" maxlength="15" />
				AND			DATEDIFF( MINUTE, DateCreated, GETDATE() ) <= (60 * #this.UniqueUserHourThrottle#)
				AND			IsBillable = 1
			);
			
			IF @USERTRACKINGCOUNT = 0
				BEGIN
					SET @ISBILLABLE = 1
				END
			ELSE
				BEGIN
					SET @ISBILLABLE = 0
				END;
				
			<!--- cost must be sql var rather than queryparam --->
			SET @COST = #Arguments.Cost#;
		
			INSERT INTO AMP_AdvertisementTracking (
				AdvertisementID,
				LocationID,
				MonetizationModelID,
				PlacementID,
				Cost,
				IsBillable,
				IPAddress,
				DateCreated							
			) VALUES (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AdvertisementID#" />,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LocationID#" />,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MonetizationModelID#" />,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PlacementID#" />,
				@COST,
				@ISBILLABLE,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_HOST#" maxlength="15" />,
				GETDATE()
			);
		</cfquery>
		
	</cffunction>
	
	<cffunction name="TrackAdvertisements" access="public" output="false" returntype="void">  
		<cfargument name="AdvertisementsQuery" type="query" required="yes" />
		<cfargument name="LocationID" type="numeric" required="yes" />
		<cfargument name="MonetizationModelID" type="numeric" required="yes" />
		<cfargument name="PlacementID" type="numeric" required="yes" />
		
		<cfset var loc_Advertisements = Arguments.AdvertisementsQuery />
		<cfset var loc_AdvertisementTracking = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_AdvertisementTracking">	
			DECLARE @USERTRACKINGCOUNT AS INT;
			DECLARE @COST AS DECIMAL(18,3);
			DECLARE @ISBILLABLE AS BIT;
			
			<cfoutput query="loc_Advertisements">
			
				/* #loc_Advertisements.Title# */
		
				SET @USERTRACKINGCOUNT = (
					SELECT		COUNT(*) AS Total
					FROM		AMP_AdvertisementTracking
					WHERE		AdvertisementID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_Advertisements.ID#" />
					AND			MonetizationModelID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MonetizationModelID#" />
					AND			IPAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_HOST#" maxlength="15" />
					AND			DATEDIFF( MINUTE, DateCreated, GETDATE() ) <= (60 * #this.UniqueUserHourThrottle#)
					AND			IsBillable = 1
				);
				
				IF @USERTRACKINGCOUNT = 0
					BEGIN
						SET @ISBILLABLE = 1
					END
				ELSE
					BEGIN
						SET @ISBILLABLE = 0
					END;
					
				<!--- cost must be sql var rather than queryparam --->
				SET @COST = #loc_Advertisements.CostPerImpression#;
	
				INSERT INTO AMP_AdvertisementTracking (
					AdvertisementID,
					LocationID,
					MonetizationModelID,
					PlacementID,
					Cost,
					IsBillable,
					IPAddress,
					DateCreated							
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#loc_Advertisements.ID#" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LocationID#" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MonetizationModelID#" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PlacementID#" />,
					@COST,
					@ISBILLABLE,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_HOST#" maxlength="15" />,
					GETDATE()
				);
			</cfoutput>
		</cfquery>
		
	</cffunction>
	
	<cffunction name="GetAdvertisementPlacementSelections" access="public" output="true" returntype="query">    
		<cfargument name="AdvertisementID" default="0" />
        
		<cfset var loc_AdvertisementPlacementSelections = "" />
        
		<cfquery datasource="#request.dsource#" name="loc_AdvertisementPlacementSelections">
			SELECT		AP.ID,
						AP.Title,
						CASE WHEN APS.AdvertisementID IS NOT NULL THEN 1 ELSE 0 END AS IsSelected
			
			FROM		AMP_AdvertisementPlacements AP
			LEFT JOIN	AMP_AdvertisementPlacementSelections APS ON AP.ID = APS.PlacementID
			AND			APS.AdvertisementID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AdvertisementID#" />
		</cfquery>	
		
		<cfreturn loc_AdvertisementPlacementSelections />
	</cffunction>
	
	<cffunction name="GetAdvertisementLocationSelections" access="public" output="true" returntype="query">    
		<cfargument name="AdvertisementID" default="0" />
        
		<cfset var loc_AdvertisementPlacementSelections = "" />
        
		<cfquery datasource="#request.dsource#" name="loc_AdvertisementPlacementSelections">
			SELECT		L.ID,
						L.Title,
						CASE WHEN ALS.AdvertisementID IS NOT NULL THEN 1 ELSE 0 END AS IsSelected
			
			FROM		AMP_Locations L
			LEFT JOIN	AMP_AdvertisementLocationSelections ALS ON L.ID = ALS.LocationID
			AND			ALS.AdvertisementID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AdvertisementID#" />
		</cfquery>	
		
		<cfreturn loc_AdvertisementPlacementSelections />
	</cffunction>
	
	<cffunction name="UpdateAdvertisement" access="public" output="true" returntype="void">    
		<cfargument name="IsBackEnd" default="no">
		<cfargument name="AdvertisementID" type="numeric" required="yes" />
		<cfargument name="User" type="numeric" required="yes" />
		<cfargument name="Type" type="numeric" required="yes" />
		<cfargument name="Size" type="numeric" required="yes" />
		<cfargument name="Title" type="string" default="" />
		<cfargument name="Description" type="string" default="" />
		<cfargument name="IsHouseAdvertisement" type="boolean" required="yes" />
		<cfargument name="Budget" type="numeric" required="yes" />
		<cfargument name="MonetizationModel" default="1" />
		<cfargument name="CostPerClick" type="numeric" />
		<cfargument name="CostPerThousandImpressions" type="numeric" />
		<cfargument name="DestinationUrl" type="string" default="" />
		<cfargument name="Status" default="1" />
		<cfargument name="Location" type="string" default="" />
		<cfargument name="Placement" type="string" default="" />
		
		<cfset var loc_UpdateAdvertisement = "" />
		<cfset var loc_thisPlacement = "" />
		<cfset var loc_thisLocation = "" />
		<cfset var loc_CreativeFileExtension = "" />
		<cfset var loc_AdvertisementID = Arguments.AdvertisementID />
		<cfset var loc_AdvertisementPath = StructNew() />
		<cfset var loc_StatusMessage = "" />
		<cfset var loc_ReturnUrl = "" />
		
		<cfset var loc_Budget = Arguments.Budget />
		<cfset var loc_CostPerClick = Arguments.CostPerClick />
		<cfset var loc_CostPerThousandImpressions = Arguments.CostPerThousandImpressions />
		<cfset var loc_CostPerImpression = "" />		
		
		<cfif NOT IsNumeric(loc_Budget)>
			<cfset loc_Budget = 0 />
		</cfif>
		
		<cfif NOT IsNumeric(loc_CostPerClick)>
			<cfset loc_CostPerClick = 0 />
		</cfif>
		
		<cfif NOT IsNumeric(loc_CostPerThousandImpressions)>
			<cfset loc_CostPerThousandImpressions = 0 />
		</cfif>
		
		<cfset loc_CostPerImpression = (loc_CostPerThousandImpressions / 1000) />
		
	   	<cfquery datasource="#request.dsource#" name="loc_UpdateAdvertisement">
			DECLARE @AdvertisementID AS Int;
			DECLARE @Budget AS DECIMAL(18,3);
			DECLARE @CostPerClick AS DECIMAL(18,3);
			DECLARE @CostPerThousandImpressions AS DECIMAL(18,3);
			DECLARE @CostPerImpression AS DECIMAL(18,3);
			
			SET @Budget = #loc_Budget#;
			SET @CostPerClick = #loc_CostPerClick#;
			SET @CostPerThousandImpressions = #loc_CostPerThousandImpressions#;
			SET @CostPerImpression = #loc_CostPerImpression#;

			SET @AdvertisementID = (
				SELECT	ID
				FROM	AMP_Advertisements
				WHERE	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_AdvertisementID#" />
			);
			
			IF @AdvertisementID IS NULL
			
				BEGIN
				
					INSERT INTO AMP_Advertisements (
						UserID,
						SizeID,
						TypeID,
						Title,
						Description,
						IsHouseAdvertisement,
						Budget,
						MonetizationModelID,
						CostPerClick,
						CostPerThousandImpressions,
						CostPerImpression,
						DestinationUrl,
						Status,
						DateCreated
					 )
					 VALUES (
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.User#" />,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Size#" />,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Type#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Title#" maxlength="50" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Description#" />,
						<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.IsHouseAdvertisement#" />,
						@Budget,	
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MonetizationModel#" />,
						@CostPerClick,	
						@CostPerThousandImpressions,	
						@CostPerImpression,	
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.DestinationUrl#" maxlength="255" />,
						<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />,
						GETDATE()
					 )
						 
					SELECT	@@IDENTITY AS NewID,
							'Advertisement.Added' AS StatusMessage;
					SET @AdvertisementID = @@IDENTITY;
					SET NOCOUNT OFF;
				END
			ELSE
				BEGIN
				
					UPDATE	AMP_Advertisements
			
					SET		UserID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.User#" />,
							SizeID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Size#" />,
							TypeID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Type#" />,
							Title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Title#" maxlength="50" />,
							Description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Description#" />,
							IsHouseAdvertisement = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.IsHouseAdvertisement#" />,
							Budget = @Budget,	
							MonetizationModelID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MonetizationModel#" />,
							CostPerClick = @CostPerClick,	
							CostPerThousandImpressions = @CostPerThousandImpressions,	
							CostPerImpression = @CostPerImpression,	
							DestinationUrl = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.DestinationUrl#" maxlength="255" />,
							Status = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />,
							DateModified = GETDATE()					
			
					WHERE	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_AdvertisementID#" />;
			
					SELECT	#loc_AdvertisementID# AS NewID,
							'Advertisement.Updated' AS StatusMessage;
				END
				
			DELETE
			FROM		AMP_AdvertisementPlacementSelections
			WHERE		AdvertisementID = @AdvertisementID;
				
			<cfif Len( Arguments.Placement )>
				<cfloop list="#Arguments.Placement#" index="loc_thisPlacement">
					INSERT INTO AMP_AdvertisementPlacementSelections (
						AdvertisementID,
						PlacementID
					) VALUES (
						@AdvertisementID,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#loc_thisPlacement#" /> 
					);
				</cfloop>
			</cfif>
			
			DELETE
			FROM		AMP_AdvertisementLocationSelections
			WHERE		AdvertisementID = @AdvertisementID;
			
			<cfif Len( Arguments.Location )>
				<cfloop list="#Arguments.Location#" index="loc_thisLocation">
					INSERT INTO AMP_AdvertisementLocationSelections (
						AdvertisementID,
						LocationID
					) VALUES (
						@AdvertisementID,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#loc_thisLocation#" /> 
					);
				</cfloop>
			</cfif>
		</cfquery>
		
		<cfset loc_AdvertisementID = loc_UpdateAdvertisement.NewID />
		<cfset loc_StatusMessage = loc_UpdateAdvertisement.StatusMessage />
		
		<!--- item image was uploaded --->
		<cfif len(Arguments.Image)>
		
			<cfset loc_CreativeFileExtension = GetCreativeFileExtension( AdvertisementTypeID:Arguments.Type ) />
			<cfset loc_AdvertisementCreativePath = Request.Root.Advertisement.Creative & loc_AdvertisementID & "." & loc_CreativeFileExtension />
			
			<!--- upload user file (as-is) --->
			<cffile action="upload" filefield="Image" destination="#loc_AdvertisementCreativePath#" nameconflict="overwrite" />
		
		</cfif>
		
		<cfset loc_ReturnUrl = Arguments.ReturnUrl />
		<cfif Arguments.IsBackEnd>
			<cfset loc_ReturnUrl = loc_ReturnUrl & "&AdvertisementID=" & loc_AdvertisementID & "&Message=" & loc_StatusMessage />
		</cfif>
		
		<cflocation url="#loc_ReturnUrl#" addtoken="no" />	
		
	</cffunction> 
	
	<cffunction name="DeleteAdvertisement" access="public" output="false" returntype="void">    
		<cfargument name="AdvertisementID" type="numeric" required="yes" />
		
		<cfset var loc_DeleteAdvertisement = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_DeleteAdvertisement">
			DELETE
			FROM		AMP_AdvertisementPlacementSelections
			WHERE		AdvertisementID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AdvertisementID#" />;
		
			DELETE
			FROM		AMP_Advertisements
			WHERE		ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AdvertisementID#" />;
		</cfquery>
		
	</cffunction>
	
	<cffunction name="GetCreativeFileExtension" access="public" output="false" returntype="string">   
		<cfargument name="AdvertisementID" default="0" />
		<cfargument name="AdvertisementTypeID" default="" />
		
		<cfset var loc_CreativeFileExtension = "" />
		<cfset var loc_CreativeFileExtensions = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_CreativeFileExtensions">
		
			<cfif IsNumeric(Arguments.AdvertisementTypeID)>
				SELECT		ADT.FileExtension
				FROM		AMP_AdvertisementTypes ADT
				WHERE		ADT.ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AdvertisementTypeID#" />
			<cfelseif IsNumeric(Arguments.AdvertisementID)>
				SELECT		ADT.FileExtension
				FROM		AMP_Advertisements AD
				JOIN		AMP_AdvertisementTypes ADT ON AD.TypeID = ADT.ID
				WHERE		AD.ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AdvertisementID#" />
			<cfelse>
				SELECT		NULL AS FileExtension
			</cfif>
			
		</cfquery>
		
		<cfset loc_CreativeFileExtension = loc_CreativeFileExtensions.FileExtension />
		
		<cfreturn loc_CreativeFileExtension />
	</cffunction>
	
	<cffunction name="GetCreative" access="public" output="false" returntype="string">    
		<cfargument name="AdvertisementID" default="0" />
		
		<cfset var loc_AdvertisementID = Arguments.AdvertisementID />
		<cfset var loc_CreativeFileExtension = GetCreativeFileExtension( AdvertisementID:loc_AdvertisementID ) />
		<cfset var loc_CreativePath = Request.Root.Advertisement.Creative & loc_AdvertisementID & "." & loc_CreativeFileExtension />
		<cfset var loc_Creative = "" />
		
		<cfif FileExists( loc_CreativePath )>
			<cfset loc_Creative = Request.Root.Web & "images/advertisement/" & loc_AdvertisementID & "." & loc_CreativeFileExtension />
		</cfif>
		
		<cfreturn loc_Creative />
	</cffunction>
	
</cfcomponent>