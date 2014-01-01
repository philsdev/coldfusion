<cfcomponent hint="This component will handle editing site administrators" extends="MachII.framework.Listener">

	<cfscript>
		this.SortOptions = ArrayNew(1);
		
		this.SortOptions[1] = ["promotionname","Promotion Name","P.PromotionName"];
		this.SortOptions[2] = ["promotioncode","Promotion Code","P.PromotionCode"];
		this.SortOptions[3] = ["startdate","Start Date","P.StartDate"];
		this.SortOptions[4] = ["enddate","End Date","P.EndDate"];		
		this.SortOptions[5] = ["productcount","Products","ISNULL(TOTALS.SubTotal,0)"];
		this.SortOptions[6] = ["status","Status","S.Status"];
		
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
	
	<cffunction name="GetPromotions" returntype="query">
		<cfargument name="StartRow" type="numeric" default="1" />
		<cfargument name="EndRow" type="numeric" default="#REQUEST.Settings.RecordsPerPage#" /> 
		<cfargument name="PromotionName" type="string" default="" />
		<cfargument name="PromotionCode" type="string" default="" />
		<cfargument name="Status" type="any" required="no" default="" />
		<cfargument name="sidx" type="string" required="no" default="#this.SortOptions[1][3]#" />
		<cfargument name="sord" type="string" required="no" default="#this.DefaultSord#" />
    	
		<cfset var loc_Promotions = "" />
	
		<cfquery datasource="#request.dsource#" name="loc_Promotions">
			SELECT		*
			FROM  (
					  
						SELECT			ROW_NUMBER() OVER ( ORDER BY #Arguments.sidx# #Arguments.sord# ) AS RowNum,
										COUNT(*) OVER () as Row_Total,
										P.PromotionID,
										P.PromotionName,
										P.PromotionCode,
										CONVERT( CHAR(10), P.StartDate, 101 ) AS StartDate,
										CONVERT( CHAR(10), P.EndDate, 101 ) AS EndDate,
										ISNULL(TOTALS.SubTotal,0) AS OrderCount,
										S.Status
						
						FROM			Promotions P
						JOIN			Status S ON P.Status = S.ID
						LEFT JOIN		(
											SELECT		PromotionID,
														COUNT(*) AS SubTotal
											FROM		Orders
											GROUP BY	PromotionID
						
										) TOTALS ON P.PromotionID = TOTALS.PromotionID
						
						WHERE			1=1
						
					<CFIF Len(Arguments.PromotionName)>
						AND				p.PromotionName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.PromotionName#%" />		
					</CFIF>
					<CFIF IsBoolean(Arguments.Status)>
						AND				P.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />		
					</CFIF>
			
			) AS RowConstrainedResult

			WHERE		RowNum >= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.StartRow#" />
			AND			RowNum <= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.EndRow#" />
			
			ORDER BY 	RowNum		
		</cfquery>
		
		<cfreturn loc_Promotions />
		
	</cffunction>
	
	<cffunction name="GetPromotionDetails" returntype="query" output="no">
		<cfargument name="PromotionID" type="numeric" default="0" />
		
		<cfset var loc_PromotionDetails = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_PromotionDetails">
			SELECT		PromotionID,
						PromotionName, 
						PromotionCode,
						RedemptionMaximum,
						OrderMinimumAmount,
						DiscountPercent,
						DiscountAmount,
						CONVERT( CHAR(10), StartDate, 101 ) AS StartDate,
						CONVERT( CHAR(10), EndDate, 101 ) AS EndDate,
						Status
						
			FROM		Promotions
			
			WHERE		PromotionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PromotionID#" />
		</cfquery>
		
		<cfreturn loc_PromotionDetails />
	
	</cffunction>
	
	<cffunction name="GetDisplayPromotionDetails" returntype="query" output="no">
		<cfargument name="PromotionCode" type="string" required="yes" />
		
		<cfset var loc_PromotionDetails = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_PromotionDetails">
			SELECT		PromotionID,
						PromotionName, 
						PromotionCode,
						RedemptionMaximum,
						OrderMinimumAmount,
						DiscountPercent,
						DiscountAmount
						
			FROM		Promotions
			
			WHERE		PromotionCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.PromotionCode#" />
			AND			Status = 1
			AND			(
							StartDate IS NULL
							OR
							DATEDIFF( DAY, StartDate, GETDATE() ) >= 0
						)
			AND			(
							EndDate IS NULL
							OR
							DATEDIFF( DAY, EndDate, GETDATE() ) <= 0
						)
		</cfquery>
		
		<cfreturn loc_PromotionDetails />
	
	</cffunction>
	
	<cffunction name="UpdatePromotion" returntype="void">
		<cfargument name="PromotionID" default="0" />		
		<cfargument name="PromotionName" type="string" required="yes" />		
		<cfargument name="PromotionCode" type="string" required="yes" />
		<cfargument name="RedemptionMaximum" type="string" required="yes" />
		<cfargument name="OrderMinimumAmount" type="string" required="yes" />
		<cfargument name="DiscountPercent" type="numeric" required="no" default="0" />
		<cfargument name="DiscountAmount" type="numeric"required="no" default="0" />
		<cfargument name="StartDate" type="string" required="yes" />
		<cfargument name="EndDate" type="string" required="yes" />		
		<cfargument name="Status" type="boolean" required="yes" />
		<cfargument name="ReturnUrl" type="string" required="yes" />
		
		<cfset var loc_PromotionID = Arguments.PromotionID />
		<cfset var loc_UpdatePromotion = "" />
		<cfset var loc_StatusMessage = "" />
		
		<cfif (Arguments.DiscountPercent GT 0 AND Arguments.DiscountAmount GT 0) OR (Arguments.DiscountPercent EQ 0 AND Arguments.DiscountAmount EQ 0)>
			<cfthrow message="Promotion must have discount percent OR amount" />
		</cfif>
		
		<cfquery datasource="#request.dsource#" name="loc_UpdatePromotion">
			DECLARE @PromotionID AS Int;

			SET @PromotionID = (
				SELECT	PromotionID
				FROM	Promotions
				WHERE	PromotionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_PromotionID#" />
			);
			
			IF @PromotionID IS NULL
			
				BEGIN
		
					SET NOCOUNT ON
					
					INSERT INTO Promotions (
						PromotionName, 
						PromotionCode,
						RedemptionMaximum,
						OrderMinimumAmount,
						DiscountPercent,
						DiscountAmount,
						StartDate,
						EndDate,
						Status
					) VALUES (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.PromotionName#" maxlength="255" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.PromotionCode#" maxlength="50" />,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.RedemptionMaximum#" null="#NOT(LEN(Arguments.RedemptionMaximum))#" />,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.OrderMinimumAmount#" null="#NOT(LEN(Arguments.OrderMinimumAmount))#" />,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DiscountPercent#" />,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DiscountAmount#" />,
						<cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.StartDate#" null="#NOT IsDate(Arguments.StartDate)#" />,
						<cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.EndDate#" null="#NOT IsDate(Arguments.EndDate)#" />,
						<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />
					)
					 
					SELECT	@@IDENTITY AS NewID,
							'Promotion.Added' AS StatusMessage
					SET NOCOUNT OFF
				END
			ELSE
				BEGIN
		
					UPDATE	Promotions
					
					SET		PromotionName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.PromotionName#" maxlength="255" />, 
							PromotionCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.PromotionCode#" maxlength="50" />,
							RedemptionMaximum = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.RedemptionMaximum#" null="#NOT(LEN(Arguments.RedemptionMaximum))#" />,
							OrderMinimumAmount = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.OrderMinimumAmount#" null="#NOT(LEN(Arguments.OrderMinimumAmount))#" />,
							DiscountPercent = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DiscountPercent#" />,
							DiscountAmount = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DiscountAmount#" />,
							StartDate = <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.StartDate#" null="#NOT IsDate(Arguments.StartDate)#" />,
							EndDate = <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.EndDate#" null="#NOT IsDate(Arguments.EndDate)#" />,
							Status = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />
							
					WHERE	PromotionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_PromotionID#" />;
					
					SELECT	#loc_PromotionID# AS NewID,
							'Promotion.Updated' AS StatusMessage
				END
		</cfquery>
		
		<cfset loc_PromotionID = loc_UpdatePromotion.NewID />
		<cfset loc_StatusMessage = loc_UpdatePromotion.StatusMessage />
		
		<cflocation url="#Arguments.ReturnUrl#&Message=#loc_StatusMessage#&PromotionID=#loc_PromotionID#" addtoken="no" />
    
    </cffunction>
	
	<cffunction name="DeletePromotion" access="public" output="false" returntype="void">    
		<cfargument name="PromotionID" type="numeric" required="yes" />		
		
		<cfset var loc_DeletePromotion = "" />		
		
		<cfquery datasource="#request.dsource#" name="loc_DeletePromotion">
			DELETE
			FROM		Promotions
			WHERE		PromotionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PromotionID#" />
		</cfquery>
		
	</cffunction>

</cfcomponent>