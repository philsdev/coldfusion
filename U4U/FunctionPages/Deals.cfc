<cfcomponent extends="MachII.framework.Listener">

	<cfscript>
		this.SortOptions = ArrayNew(1);
		
		this.SortOptions[1] = ["title","Title","D.Title"];
		this.SortOptions[2] = ["category","Category","DC.Title"];
		this.SortOptions[3] = ["costperclick","PPC","ISNULL(D.CostPerClick,0)"];
		this.SortOptions[4] = ["costperthousandimpressions","PPM","ISNULL(D.CostPerThousandImpressions,0)"];
		this.SortOptions[5] = ["budget","Budget","ISNULL(D.Budget,0)"];
		this.SortOptions[6] = ["budgetused","BudgetUsed","TRACKING.BudgetUsed"];	
		this.SortOptions[7] = ["startdate","Start Date","D.StartDate"];		
		this.SortOptions[8] = ["enddate","End Date","D.EndDate"];
		this.SortOptions[9] = ["datecreated","Date Created","D.DateCreated"];
		this.SortOptions[10] = ["status","Status","ST.Status"];
		
		this.DefaultSearchText = "Search Deals";
		this.UniqueUserHourThrottle = Request.UniqueUserHourThrottle;
		
		this.DefaultRates = StructNew();
		this.DefaultRates.CostPerClick = 5;
		this.DefaultRates.CostPerThousandImpressions = 10;
		
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
	
	<cffunction name="GetMonetizationModels" access="public" output="no" returntype="query">    
        
		<cfset var loc_Models = "" />
        
		<cfquery datasource="#request.dsource#" name="loc_Models">
			SELECT		ID,
						Title
			FROM		AMP_MonetizationModels
		</cfquery>
		
		<cfreturn loc_Models />
	</cffunction>
		
	<cffunction name="GetDeals" access="public" output="yes" returntype="query">    
		<cfargument name="StartRow" type="numeric" default="1" />
		<cfargument name="EndRow" type="numeric" default="#Request.RecordsPerPage#" /> 
		<cfargument name="Title" type="string" default="" />
		<cfargument name="StartDate" type="string" default="" />
		<cfargument name="EndDate" type="string" default="" />
		<cfargument name="DateCreated" type="string" default="" />
		<cfargument name="Username" type="string" default="" />
		<cfargument name="Category" type="string" default="" />
		<cfargument name="User" type="string" default="" />
		<cfargument name="SearchTerm" type="string" default="" />
		<cfargument name="Status" type="string" default="" />
		<cfargument name="sidx" type="string" required="no" default="#this.SortOptions[1][3]#" />
		<cfargument name="sord" type="string" required="no" default="desc" />
        
		<cfset var loc_Deals = "" />
		<cfset var loc_SearchTerm = TRIM( Arguments.SearchTerm ) />
		
		<cfif loc_SearchTerm EQ this.DefaultSearchText>
			<cfset loc_SearchTerm = "" />
		<cfelseif LEN(loc_SearchTerm)>
			<cfset loc_SearchTerm = "%" & Arguments.SearchTerm & "%" />
		</cfif>
        
		<cfquery datasource="#request.dsource#" name="loc_Deals">
			SELECT		*
			FROM  (
					  
						SELECT			ROW_NUMBER() OVER ( ORDER BY #Arguments.sidx# ) AS RowNum,
										COUNT(*) OVER () as Row_Total,
										ABS(CAST(CAST(NEWID() AS VARBINARY) AS INT)) AS DealSortOrder,
										D.ID,
										D.Title,
										D.Description,
										CONVERT(CHAR(10),D.StartDate,101) AS StartDate,
										CONVERT(CHAR(10),D.EndDate,101) AS EndDate,
										CONVERT(CHAR(10),D.DateCreated,101) AS DateCreated,
										D.AddressID,
										ADDR.Title AS AddressTitle,
										ADDR.Street1,
										ADDR.Street2,
										ADDR.City,
										ADDR.State,
										D.UserID,
										A.Username,
										D.CategoryID,
										DC.Title AS Category,
										M.Title as MonetizationModel,
										ISNULL(D.CostPerClick,0) AS CostPerClick,
										ISNULL(D.CostPerThousandImpressions,0) AS CostPerThousandImpressions,
										ISNULL(D.CostPerImpression,0) AS CostPerImpression,
										ISNULL(D.Budget,0) AS Budget,
										TRACKING.BudgetUsed,
										ST.Status
						
						FROM			AMP_Deals D	
						JOIN			AMP_Accounts A ON D.UserID = A.ID
						JOIN			AMP_Address ADDR ON D.AddressID = ADDR.ID	
						JOIN			AMP_DealCategories DC ON D.CategoryID = DC.ID
						JOIN			AMP_MonetizationModels M ON D.MonetizationModelID = M.ID
						JOIN			AMP_Status ST ON D.Status = ST.ID
						
						LEFT JOIN		(
											SELECT		SUM(Cost) as BudgetUsed,
														DealID
											FROM		AMP_DealTracking
											GROUP BY	DealID
										) TRACKING ON D.ID = TRACKING.DealID
						
						WHERE			1=1
					<cfif Len(Arguments.Title)>
							AND			D.Title LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.Title#%" />		
					</cfif>
					<cfif IsNumeric(Arguments.Category)>
							AND			D.CategoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Category#" />		
					</cfif>
					<cfif IsDate(Arguments.StartDate)>
							AND			D.StartDate = <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.StartDate#" />		
					</cfif>
					<cfif IsDate(Arguments.EndDate)>
							AND			D.EndDate = <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.EndDate#" />		
					</cfif>
					<cfif IsDate(Arguments.DateCreated)>
							AND			D.DateCreated = <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.DateCreated#" />		
					</cfif>
					<cfif LEN(Arguments.Username)>
						AND				A.Username LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.Username#%" />		
					</cfif>
					<cfif IsNumeric(Arguments.Category)>
						AND				D.CategoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Category#" />		
					</cfif>
					<cfif IsNumeric(Arguments.User)>
						AND				D.UserID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.User#" />		
					</cfif>	
					<cfif IsBoolean(Arguments.Status)>
						AND				D.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />		
					</cfif>
					
					<cfif LEN( loc_SearchTerm )>
						AND			(
										D.Title LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#loc_SearchTerm#" />		
										OR
										D.Description LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#loc_SearchTerm#" />
									)
					</cfif>
					
					<cfif Request.IsFrontEnd>
						AND				D.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
						AND			(
										D.StartDate IS NULL 
										OR 
										DATEDIFF( DAY, D.StartDate, GETDATE() ) >= 0
									)
						AND			(
										D.EndDate IS NULL 
										OR 
										DATEDIFF( DAY, D.EndDate, GETDATE() ) <= 0
									)	
						AND			ISNULL(TRACKING.BudgetUsed,0) < D.Budget
					</cfif>
					
			) AS RowConstrainedResult

			WHERE		RowNum >= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.StartRow#" />
			AND			RowNum <= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.EndRow#" />
			
			ORDER BY 	RowNum	
		</cfquery>
		
		<cfreturn loc_Deals />
	</cffunction>
	
	<cffunction name="GetDealDetails" access="public" output="false" returntype="query">    
		<cfargument name="DealID" default="0" />
		<cfargument name="User" default="" />
        
		<cfset var loc_Deal = "" />
        
		<cfquery datasource="#request.dsource#" name="loc_Deal">
			SELECT		D.ID,
						D.Title,
						D.Description,
						CONVERT(CHAR(10),D.StartDate,101) AS StartDate,
						CONVERT(CHAR(10),D.EndDate,101) AS EndDate,
						CONVERT(CHAR(10),D.DateCreated,101) AS DateCreated,
						D.UserID,
						A.Username,
						D.CategoryID,
						DC.Title AS Category,
						D.Status,
						D.Budget,
						D.Budget - (TRACKING.BudgetUsedImpressions + TRACKING.BudgetUsedClicks) AS BudgetRemaining,
						TRACKING.BudgetUsedImpressions,
						TRACKING.BudgetUsedClicks,
						TRACKING.BudgetUsedImpressions + TRACKING.BudgetUsedClicks AS BudgetUsed,
						TRACKING.Impressions,
						TRACKING.Clicks,
						CONVERT( CHAR(10), TRACKING.FirstTrack, 101 ) AS FirstTrack,
						CONVERT( CHAR(10), TRACKING.LastTrack, 101 ) AS LastTrack,
						D.CostPerClick,
						D.CostPerThousandImpressions,
						D.MonetizationModelID,
						M.Title as MonetizationModel,
						D.DestinationUrl,
						D.AddressID,
						ADDR.Title AS AddressTitle,
						ADDR.Street1,
						ADDR.Street2,
						ADDR.City,
						ADDR.State,
						ADDR.ZipCode,
						ADDR.PhoneNumber,
						ADDR.URL
			
			FROM		AMP_Deals D
			JOIN		AMP_Accounts A ON D.UserID = A.ID
			JOIN		AMP_Address ADDR ON D.AddressID = ADDR.ID
			JOIN		AMP_DealCategories DC ON D.CategoryID = DC.ID
			JOIN		AMP_MonetizationModels M ON D.MonetizationModelID = M.ID
			
			LEFT JOIN	(
							SELECT		DealID,
										MIN(DateCreated) AS FirstTrack,
										MAX(DateCreated) AS LastTrack,
										ISNULL(SUM(CASE WHEN MonetizationModelID = 1 THEN Cost END),0) as BudgetUsedImpressions,
										ISNULL(SUM(CASE WHEN MonetizationModelID = 2 THEN Cost END),0) as BudgetUsedClicks,
										ISNULL(COUNT(CASE WHEN MonetizationModelID = 1 THEN 1 END),0) as Impressions,
										ISNULL(COUNT(CASE WHEN MonetizationModelID = 2 THEN 1 END),0) as Clicks
							FROM		AMP_DealTracking
							GROUP BY	DealID
						) TRACKING ON D.ID = TRACKING.DealID
						
			WHERE		D.ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.DealID#" />
			<cfif Request.IsFrontEnd>
				AND		D.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
				<cfif IsNumeric(Arguments.User)>
					AND		D.UserID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.User#" />
				</cfif>
			</cfif>
		</cfquery>		
		
		<cfreturn loc_Deal />
	</cffunction> 
	
	<cffunction name="UpdateDeal" access="public" output="false" returntype="void">    
		<cfargument name="DealID" type="numeric" required="yes" />
		<cfargument name="User" type="numeric" required="yes" />
		<cfargument name="Category" type="numeric" required="yes" />
		<cfargument name="Title" type="string" default="" />
		<cfargument name="Description" type="string" default="" />
		<cfargument name="StartDate" type="string" default="" />
		<cfargument name="EndDate" type="string" default="" />
		<cfargument name="DestinationUrl" type="string" default="" />
		<cfargument name="Status" default="1" />
		<cfargument name="AddressTitle" type="string" default="" />
		<cfargument name="Street1" type="string" default="" />
		<cfargument name="Street2" type="string" default="" />
		<cfargument name="City" type="string" default="" />
		<cfargument name="State" type="string" default="" />
		<cfargument name="ZipCode" type="string" default="" />
		<cfargument name="PhoneNumber" type="string" default="" />
		<cfargument name="Url" type="string" default="" />
		<cfargument name="Image" type="string" default="" />
		<cfargument name="Budget" type="numeric" required="yes" />
		<cfargument name="MonetizationModel" default="1" />
		<cfargument name="CostPerClick" type="numeric" />
		<cfargument name="CostPerThousandImpressions" type="numeric" />
		
		<cfset var loc_UpdateDeal = "" />
		<cfset var loc_DealID = Arguments.DealID />
		<cfset var loc_ItemUploadPath = "" />
		<cfset var loc_Admin = Request.ListenerManager.GetListener( "AdminManager" ) />
		<cfset var loc_ItemKey = "deal" />
		<cfset var loc_StatusMessage = "" />
		<cfset var loc_ReturnUrl = "" />		
		<cfset var loc_Budget = Arguments.Budget />
		<cfset var loc_CostPerClick = "" />
		<cfset var loc_CostPerThousandImpressions = "" />
		<cfset var loc_CostPerImpression = "" />
		
		<cfif Request.IsFrontEnd>
			<cfset loc_CostPerClick = this.DefaultRates.CostPerClick />
			<cfset loc_CostPerThousandImpressions = this.DefaultRates.CostPerThousandImpressions />
		<cfelse>
			<cfset loc_CostPerClick = Arguments.CostPerClick />
			<cfset loc_CostPerThousandImpressions = Arguments.CostPerThousandImpressions />
		</cfif>

		<cfif NOT IsNumeric(loc_Budget)>
			<cfset loc_Budget = 0 />
		</cfif>		
		
		<cfif NOT IsNumeric(loc_CostPerClick)>
			<cfset loc_CostPerClick = 0 />
		</cfif>
		
		<cfif NOT IsNumeric(loc_CostPerThousandImpressions)>
			<cfset loc_CostPerThousandImpressions = 0 />
		</cfif>
		
		<!--- for front end only, set default prices, which are used for inserts and ignored for updates --->
		<cfif Request.IsFrontEnd>
			<cfswitch expression="#Arguments.MonetizationModel#">
				<cfcase value="1">
					<cfset loc_CostPerThousandImpressions = this.DefaultRates.CostPerThousandImpressions />
					<cfset loc_CostPerClick = 0 />
				</cfcase>
				<cfcase value="2">
					<cfset loc_CostPerThousandImpressions = 0 />
					<cfset loc_CostPerClick = this.DefaultRates.CostPerClick />
				</cfcase>
			</cfswitch>
		</cfif>
		
		<cfset loc_CostPerImpression = (loc_CostPerThousandImpressions / 1000) />
		
		<cfquery datasource="#request.dsource#" name="loc_UpdateDeal">
			DECLARE @AddressID AS Int;
			DECLARE @DealID AS Int;
			DECLARE @Budget AS DECIMAL(18,3);
			DECLARE @CostPerClick AS DECIMAL(18,3);
			DECLARE @CostPerThousandImpressions AS DECIMAL(18,3);
			DECLARE @CostPerImpression AS DECIMAL(18,3);
			
			SET @Budget = #loc_Budget#;
			SET @CostPerClick = #loc_CostPerClick#;
			SET @CostPerThousandImpressions = #loc_CostPerThousandImpressions#;
			SET @CostPerImpression = #loc_CostPerImpression#;

			SET @AddressID = (
				SELECT	AddressID
				FROM	AMP_Deals
				WHERE	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_DealID#" />
			);
			
			SET @DealID = (
				SELECT	ID
				FROM	AMP_Deals
				WHERE	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_DealID#" />
				<cfif Request.IsFrontEnd>
					AND		UserID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.User#" />
				</cfif>
			);
			
			IF @AddressID IS NULL
			
				BEGIN
				
					SET NOCOUNT ON;
				
					INSERT INTO AMP_Address (
						Title,
						Street1,
						Street2,
						City,
						State,
						ZIPCode,
						PhoneNumber,
						URL,
						DateCreated
					) VALUES (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.AddressTitle#" maxlength="50" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Street1#" maxlength="50" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Street2#" maxlength="50" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.City#" maxlength="50" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.State#" maxlength="2" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ZipCode#" maxlength="10" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.PhoneNumber#" maxlength="20" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Url#" maxlength="200" />,
						GETDATE()	
					);
			
					SET @AddressID = @@IDENTITY;
					
				END
					
			ELSE
			
				UPDATE	AMP_Address
			
				SET		Title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.AddressTitle#" maxlength="50" />,
						Street1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Street1#" maxlength="50" />,
						Street2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Street2#" maxlength="50" />,
						City = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.City#" maxlength="50" />,
						State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.State#" maxlength="2" />,
						ZIPCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ZipCode#" maxlength="10" />,
						PhoneNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.PhoneNumber#" maxlength="20" />,
						URL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Url#" maxlength="200" />,
						DateModified = GETDATE()
		
				WHERE	ID = @AddressID;
			
			IF @DealID IS NULL
			
				BEGIN
				
					INSERT INTO AMP_Deals (
						UserID,
						CategoryID,
						AddressID,
						Title,
						Description,
						StartDate,
						EndDate,
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
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Category#" />,
						@AddressID,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Title#" maxlength="50" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Description#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.StartDate#" null="#NOT(IsDate(Arguments.StartDate))#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.EndDate#" null="#NOT(IsDate(Arguments.EndDate))#" />,
						@Budget,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MonetizationModel#" />,
						@CostPerClick,
						@CostPerThousandImpressions,
						@CostPerImpression,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.DestinationUrl#" maxlength="255" />,
					<cfif Request.IsFrontEnd>
						<cfqueryparam cfsqltype="cf_sql_bit" value="0" />,
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />,
					</cfif>
						GETDATE()
					 )
						 
					SELECT	@@IDENTITY AS NewID,
							'Deal.Added' AS StatusMessage;
					SET NOCOUNT OFF;
				END
			ELSE
				BEGIN
				
					UPDATE	AMP_Deals
			
					SET		CategoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Category#" />,
							Title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Title#" maxlength="50" />,
							Description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Description#" />,
							StartDate = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.StartDate#" null="#NOT(IsDate(Arguments.StartDate))#" />,
							EndDate = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.EndDate#" null="#NOT(IsDate(Arguments.EndDate))#" />,
							Budget = @Budget,							
							DestinationUrl = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.DestinationUrl#" maxlength="255" />,
							<cfif NOT Request.IsFrontEnd>
								MonetizationModelID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MonetizationModel#" />,
								CostPerClick = @CostPerClick,
								CostPerThousandImpressions = @CostPerThousandImpressions,
								CostPerImpression = @CostPerImpression,
								Status = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />,
								UserID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.User#" />,
							</cfif>
							DateModified = GETDATE()					
			
					WHERE	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_DealID#" />
					AND		UserID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.User#" />;
			
					SELECT	#loc_DealID# AS NewID,
							'Deal.Updated' AS StatusMessage;
				END
		</cfquery>
		
		<cfset loc_DealID = loc_UpdateDeal.NewID />
		<cfset loc_StatusMessage = loc_UpdateDeal.StatusMessage />
		
		<!--- item image was uploaded --->
		<cfif len(Arguments.Image)>
		
			<cfset loc_ItemUploadPath = Request.Root[loc_ItemKey].Original & loc_DealID & ".jpg" />
			
			<!--- upload user file (as-is) --->
			<cffile action="upload" filefield="Image" destination="#loc_ItemUploadPath#" nameconflict="overwrite" />
			
			<cfset loc_Admin.CreateImageVariations( ItemKey:loc_ItemKey, ItemID:loc_DealID ) />
		
		</cfif>
		
		<cfif Request.IsFrontEnd>
			<cfset loc_ReturnUrl = "/deal-" & ListLast( loc_StatusMessage, "." ) & "-" & loc_DealID & ".html" />
		<cfelse>
			<cfset loc_ReturnUrl = Arguments.ReturnUrl & "&DealID=" & loc_DealID & "&Message=" & loc_StatusMessage />
		</cfif>
		
		<cflocation url="#loc_ReturnUrl#" addtoken="no" />	
		
	</cffunction> 
	
	<cffunction name="DeleteDeal" access="public" output="false" returntype="void">    
		<cfargument name="DealID" type="numeric" required="yes" />
		
		<cfset var loc_DeleteDeal = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_DeleteDeal">
			DELETE
			FROM		AMP_Deals
			WHERE		ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.DealID#" />
		</cfquery>
		
	</cffunction>
	
	<cffunction name="GetDealCost" access="public" output="false" returntype="numeric">    
		<cfargument name="DealID" type="numeric" required="yes" />
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

			FROM			AMP_Deals
			WHERE			ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.DealID#" />
			AND				Status = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
		</cfquery>		
		
		<cfreturn loc_Cost.Cost />
	</cffunction>
	
	<cffunction name="TrackDeal" access="public" output="false" returntype="void">    
		<cfargument name="DealID" type="numeric" required="yes" />
		<cfargument name="LocationID" type="numeric" required="yes" />
		<cfargument name="MonetizationModelID" type="numeric" required="yes" />
		
		<cfset var loc_DealTracking = "" />
		<cfset var loc_DealCost = GetDealCost( DealID:Arguments.DealID, MonetizationModelID:Arguments.MonetizationModelID ) />
		
		<cfquery datasource="#request.dsource#" name="loc_DealTracking">	
			DECLARE @USERTRACKINGCOUNT AS INT;
			DECLARE @COST AS DECIMAL(18,3);
			DECLARE @ISBILLABLE AS BIT;
		
			SET @USERTRACKINGCOUNT = (
				SELECT		COUNT(*) AS Total
				FROM		AMP_DealTracking
				WHERE		DealID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.DealID#" />
				AND			MonetizationModelID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MonetizationModelID#" />
				AND			IPAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_HOST#" maxlength="15" />
				AND			DATEDIFF( MINUTE, DateCreated, GETDATE() ) <= (60 * #this.UniqueUserHourThrottle#)
				AND			IsBillable = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
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
			SET @COST = #loc_DealCost#;

			INSERT INTO AMP_DealTracking (
				DealID,
				LocationID,
				MonetizationModelID,
				Cost,
				IsBillable,
				IPAddress,
				DateCreated							
			) VALUES (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.DealID#" />,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LocationID#" />,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MonetizationModelID#" />,
				@COST,
				@ISBILLABLE,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_HOST#" maxlength="15" />,
				GETDATE()
			);
		</cfquery>
		
	</cffunction>
	
	<cffunction name="TrackDeals" access="public" output="false" returntype="void">    
		<cfargument name="DealQuery" type="query" required="yes" />
		<cfargument name="LocationID" type="numeric" required="yes" />
		<cfargument name="MonetizationModelID" type="numeric" required="yes" />
		
		<cfset var loc_Deals = Arguments.DealQuery />
		<cfset var loc_DealTracking = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_DealTracking">	
			DECLARE @USERTRACKINGCOUNT AS INT;
			DECLARE @COST AS DECIMAL(18,3);
			DECLARE @ISBILLABLE AS BIT;
			
			<cfoutput query="loc_Deals">
			
				/* #loc_Deals.Title# */
		
				SET @USERTRACKINGCOUNT = (
					SELECT		COUNT(*) AS Total
					FROM		AMP_DealTracking
					WHERE		DealID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_Deals.ID#" />
					AND			MonetizationModelID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MonetizationModelID#" />
					AND			IPAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_HOST#" maxlength="15" />
					AND			DATEDIFF( MINUTE, DateCreated, GETDATE() ) <= (60 * #this.UniqueUserHourThrottle#)
					AND			IsBillable = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
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
				SET @COST = #loc_Deals.CostPerImpression#;
	
				INSERT INTO AMP_DealTracking (
					DealID,
					LocationID,
					MonetizationModelID,
					Cost,
					IsBillable,
					IPAddress,
					DateCreated							
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#loc_Deals.ID#" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.LocationID#" />,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MonetizationModelID#" />,
					@COST,
					@ISBILLABLE,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_HOST#" maxlength="15" />,
					GETDATE()
				);
			</cfoutput>
		</cfquery>
		
	</cffunction>
	
</cfcomponent>