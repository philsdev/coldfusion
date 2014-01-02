<cfcomponent extends="MachII.framework.Listener">

	<cfscript>
		this.SortOptions = ArrayNew(1);
		
		this.SortOptions[1] = ["title","Title","M.Title"];
		this.SortOptions[2] = ["startdate","Start Date","M.StartDate"];		
		this.SortOptions[3] = ["enddate","End Date","M.EndDate"];
		this.SortOptions[4] = ["datecreated","Date Created","M.DateCreated"];
		this.SortOptions[5] = ["price","Price","M.Price"];
		this.SortOptions[6] = ["category","Category","MC.Title"];
		this.SortOptions[7] = ["status","Status","ST.Status"];
		
		this.DefaultSearchText = "Search Marketplace";
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
		
	<cffunction name="GetItems" access="public" output="yes" returntype="query">    
		<cfargument name="StartRow" type="numeric" default="1" />
		<cfargument name="EndRow" type="numeric" default="#Request.RecordsPerPage#" /> 
		<cfargument name="Title" type="string" default="" />
		<cfargument name="StartDate" type="string" default="" />
		<cfargument name="EndDate" type="string" default="" />
		<cfargument name="DateCreated" type="string" default="" />
		<cfargument name="Category" type="string" default="" />
		<cfargument name="User" type="string" default="" />
		<cfargument name="PriceMin" type="string" default="" />
		<cfargument name="PriceMax" type="string" default="" />
		<cfargument name="Status" type="string" default="" />
		<cfargument name="SearchTerm" type="string" default="" />
		<cfargument name="sidx" type="string" required="no" default="#this.SortOptions[1][3]#" />
		<cfargument name="sord" type="string" required="no" default="desc" />
        
		<cfset var loc_Marketplace = "" />
		<cfset var loc_SearchTerm = TRIM( Arguments.SearchTerm ) />
		
		<cfif loc_SearchTerm EQ this.DefaultSearchText>
			<cfset loc_SearchTerm = "" />
		<cfelseif LEN(loc_SearchTerm)>
			<cfset loc_SearchTerm = "%" & Arguments.SearchTerm & "%" />
		</cfif>
        
		<cfquery datasource="#request.dsource#" name="loc_Marketplace">
			SELECT		*
			FROM  (
					  
						SELECT			ROW_NUMBER() OVER ( ORDER BY #Arguments.sidx# ) AS RowNum,
										COUNT(*) OVER () as Row_Total,
										M.ID,
										M.Title,
										M.Description,
										CONVERT(CHAR(10),M.StartDate,101) AS StartDate,
										CONVERT(CHAR(10),M.EndDate,101) AS EndDate,
										CONVERT(CHAR(10),M.DateCreated,101) AS DateCreated,
										M.Price,										
										M.CategoryID,
										MC.Title AS Category,
										M.UserID,
										A.Username,
										ST.Status
						
						FROM			AMP_Marketplace M						
						JOIN			AMP_Accounts A ON M.UserID = A.ID
						JOIN			AMP_MarketplaceCategories MC ON M.CategoryID = MC.ID
						JOIN			AMP_Status ST ON M.Status = ST.ID
						
						WHERE			1=1
					<cfif Len(Arguments.Title)>
							AND			M.Title LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.Title#%" />		
					</cfif>
					<cfif IsDate(Arguments.StartDate)>
							AND			M.StartDate = <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.StartDate#" />		
					</cfif>
					<cfif IsDate(Arguments.EndDate)>
							AND			M.EndDate = <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.EndDate#" />		
					</cfif>
					<cfif IsDate(Arguments.DateCreated)>
							AND			M.DateCreated = <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.DateCreated#" />		
					</cfif>
					<cfif IsNumeric(Arguments.Category)>
						AND				M.CategoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Category#" />		
					</cfif>					
					<cfif IsNumeric(Arguments.User)>
						AND				M.UserID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.User#" />		
					</cfif>
					<cfif IsNumeric(Arguments.PriceMin)>
						AND				M.Price >= <cfqueryparam cfsqltype="cf_sql_decimal" value="#Arguments.PriceMin#" />		
					</cfif>
					<cfif IsNumeric(Arguments.PriceMax)>
						AND				M.Price <= <cfqueryparam cfsqltype="cf_sql_decimal" value="#Arguments.PriceMax#" />		
					</cfif>
					<cfif IsBoolean(Arguments.Status)>
						AND				M.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />		
					</cfif>
					
					<cfif LEN( loc_SearchTerm )>
						AND			(
										M.Title LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#loc_SearchTerm#" />		
										OR
										M.Description LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#loc_SearchTerm#" />
									)
					</cfif>
					
					<cfif Request.IsFrontEnd>
						AND		M.Status = 1		
						AND		A.Status = 1
						AND		(
									M.StartDate IS NULL 
									OR 
									DATEDIFF( DAY, M.StartDate, GETDATE() ) >= 0
								)
						AND		(
									M.EndDate IS NULL 
									OR 
									DATEDIFF( DAY, M.EndDate, GETDATE() ) <= 0
								)
					</cfif>
					
			) AS RowConstrainedResult

			WHERE		RowNum >= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.StartRow#" />
			AND			RowNum <= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.EndRow#" />
			
			ORDER BY 	RowNum	
		</cfquery>
		
		<cfreturn loc_Marketplace />
	</cffunction>
	
	<cffunction name="GetItemDetails" access="public" output="false" returntype="query">    
		<cfargument name="ItemID" default="0" />
		<cfargument name="User" default="" />
		
		<cfset var loc_Item = "" />
        
		<cfquery datasource="#request.dsource#" name="loc_Item">
			SELECT		M.ID,
						M.Title,
						M.Description,
						CONVERT(CHAR(10),M.DateCreated,101) AS DateCreated,
						CONVERT(CHAR(10),M.StartDate,101) AS StartDate,
						CONVERT(CHAR(10),M.EndDate,101) AS EndDate,
						M.Price,
						M.CategoryID,
						MC.Title as Category,
						M.UserID,
						A.Username,
						A.Email,
						M.Status
			
			FROM		AMP_Marketplace M
			JOIN		AMP_Accounts A ON M.UserID = A.ID
			JOIN		AMP_MarketplaceCategories MC ON M.CategoryID = MC.ID
			
			WHERE		M.ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ItemID#" />
			<cfif Request.IsFrontEnd>
				AND		M.Status = 1		
				AND		A.Status = 1
				AND		(
							M.StartDate IS NULL 
							OR 
							DATEDIFF( DAY, M.StartDate, GETDATE() ) >= 0
						)
				AND		(
							M.EndDate IS NULL 
							OR 
							DATEDIFF( DAY, M.EndDate, GETDATE() ) <= 0
						)
				<cfif IsNumeric(Arguments.User)>
					AND		M.UserID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.User#" />
				</cfif>
			</cfif>
			
		</cfquery>		
		
		<cfreturn loc_Item />
	</cffunction> 
	
	<cffunction name="UpdateItem" access="public" output="true" returntype="void">    
		<cfargument name="ItemID" default="0" />
		<cfargument name="User" type="numeric" required="yes" />
		<cfargument name="Category" type="numeric" required="yes" />
		<cfargument name="Title" type="string" default="" />
		<cfargument name="Description" type="string" default="" />
		<cfargument name="StartDate" type="string" default="" />
		<cfargument name="EndDate" type="string" default="" />
		<cfargument name="Price" type="string" default="" />
		<cfargument name="Image" default="" />
		<cfargument name="Status" default="1" />
		
		<cfset var loc_UpdateItem = "" />
		<cfset var loc_ItemID = Arguments.ItemID />
		<cfset var loc_ItemUploadPath = "" />
		<cfset var loc_Admin = Request.ListenerManager.GetListener( "AdminManager" ) />
		<cfset var loc_ItemKey = "marketplace" />
		<cfset var loc_StatusMessage = "" />
		<cfset var loc_ReturnUrl = "" />
		
		<cftry>
	   	<cfquery datasource="#request.dsource#" name="loc_UpdateItem">
			DECLARE @ItemID AS Int;

			SET @ItemID = (
				SELECT		ID
				FROM		AMP_Marketplace
				WHERE		ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_ItemID#" />
				<cfif Request.IsFrontEnd>
					AND		UserID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.User#" />
				</cfif>
			);
			
			IF @ItemID IS NULL
			
				BEGIN
				
					INSERT INTO AMP_Marketplace (
						UserID,
						CategoryID,
						Title,
						Description,
						StartDate,
						EndDate,
						Price,
						Status,
						DateCreated
					 )
					 VALUES (
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.User#" />,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Category#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Title#" maxlength="50" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Description#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.StartDate#" null="#NOT(IsDate(Arguments.StartDate))#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.EndDate#" null="#NOT(IsDate(Arguments.EndDate))#" />,
						<cfqueryparam cfsqltype="cf_sql_decimal" value="#Arguments.Price#" />,						
						<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />,
						GETDATE()
					 )
						 
					SELECT	@@IDENTITY AS NewID,
							'Item.Added' AS StatusMessage;
					SET NOCOUNT OFF;
				END
			ELSE
				BEGIN
				
					UPDATE	AMP_Marketplace
			
					SET		UserID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.User#" />,
							CategoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Category#" />,
							Title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Title#" maxlength="50" />,
							Description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Description#" />,
							StartDate = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.StartDate#" null="#NOT(IsDate(Arguments.StartDate))#" />,
							EndDate = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.EndDate#" null="#NOT(IsDate(Arguments.EndDate))#" />,
							Status = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />,
							Price = <cfqueryparam cfsqltype="cf_sql_decimal" value="#Arguments.Price#" />,	
							DateModified = GETDATE()					
			
					WHERE	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_ItemID#" />;
			
					SELECT	#loc_ItemID# AS NewID,
							'Item.Updated' AS StatusMessage;
				END
		</cfquery>
		<cfcatch type="any">
			<cfdump var="#arguments#">
			<cfdump var="#cfcatch#">
			<cfabort>
		</cfcatch>
		</cftry>
		
		<cfset loc_ItemID = loc_UpdateItem.NewID />
		<cfset loc_StatusMessage = loc_UpdateItem.StatusMessage />
		
		<!--- item image was uploaded --->
		<cfif len(Arguments.Image)>
		
			<cfset loc_ItemUploadPath = Request.Root[loc_ItemKey].Original & loc_ItemID & ".jpg" />
			
			<!--- upload user file (as-is) --->
			<cffile action="upload" filefield="Image" destination="#loc_ItemUploadPath#" nameconflict="overwrite" />
			
			<cfset loc_Admin.CreateImageVariations( ItemKey:loc_ItemKey, ItemID:loc_ItemID ) />
		
		</cfif>
		
		<cfif Request.IsFrontEnd>
			<cfset loc_ReturnUrl = "/marketplace-" & ListLast( loc_StatusMessage, "." ) & "-" & loc_ItemID & ".html" />
		<cfelse>
			<cfset loc_ReturnUrl = Arguments.ReturnUrl & "&ItemID=" & loc_ItemID & "&Message=" & loc_StatusMessage />
		</cfif>
		
		<cflocation url="#loc_ReturnUrl#" addtoken="no" />	
		
	</cffunction> 
	
	<cffunction name="DeleteItem" access="public" output="false" returntype="void">    
		<cfargument name="ItemID" type="numeric" required="yes" />
		
		<cfset var loc_DeleteItem = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_DeleteItem">
			DELETE
			FROM		AMP_Marketplace
			WHERE		ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ItemID#" />
		</cfquery>
		
	</cffunction>
	
	<cffunction name="SendContactRequest" access="public" output="false" returntype="void">    
		<cfargument name="ItemID" type="numeric" required="yes" />
		<cfargument name="FirstName" type="string" required="yes" />
		<cfargument name="LastName" type="string" required="yes" />
		<cfargument name="Email" type="string" required="yes" />
		<cfargument name="PhoneNumber" type="string" required="yes" />
		<cfargument name="Comments" type="string" required="yes" />
		
		<cfset var loc_ItemDetails = GetItemDetails( ItemID:Arguments.ItemID ) />
		<cfset var loc_ReturnUrl = "" />
		
		<cfmail		to="#loc_ItemDetails.Email#"
					from="#Request.Sender_Email#"
					subject="Marketplace Inquiry from #Request.SiteLabel#">You have recieved an inquiry on your Marketplace item.
					
Item: #loc_ItemDetails.Title#

Name: #Arguments.FirstName# #Arguments.LastName#

Email: #Arguments.Email#

Phone Number: #Arguments.PhoneNumber#

Comments: #Arguments.Comments#</cfmail>	

		<cfset loc_ReturnUrl = "/marketplace-#Arguments.ItemID#/contact-sent.html" />

		<cflocation url="#loc_ReturnUrl#" addtoken="no" />	
		
	</cffunction>
	
	
</cfcomponent>