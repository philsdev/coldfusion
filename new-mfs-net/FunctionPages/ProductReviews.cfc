<cfcomponent hint="This component will handle editing product reviews" extends="MachII.framework.Listener">
	
	<cffunction name="GetProductReviewSummary" returntype="query" output="no">		
		<cfargument name="ProductID" type="numeric" default="0" />
		
		<cfset var loc_ProductReviewSummary = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_ProductReviewSummary">
			SELECT			AVG(R.Rating) AS RatingAvg,
							COUNT(*) AS RatingCount,
							R.ProductID
			FROM			ProductReviews R
				
			WHERE			R.ProductID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ProductID#" />

			GROUP BY		R.ProductID
		</cfquery>
		
		<cfreturn loc_ProductReviewSummary />	
	</cffunction>	
	
	<cffunction name="GetProductReviews" returntype="query" output="no">		
		<cfargument name="StartRow" type="numeric" default="1" />
		<cfargument name="EndRow" type="numeric" default="#REQUEST.Settings.RecordsPerPage#" /> 
		<cfargument name="ProductID" type="numeric" default="0" />
		
		<cfset var loc_ProductReviews = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_ProductReviews">
			SELECT		*
			FROM  (
					  
						SELECT			ROW_NUMBER() OVER ( ORDER BY R.DateCreated DESC ) AS RowNum,
										COUNT(*) OVER () as Row_Total,
										R.ReviewID,
										R.Title,
										R.Rating,
										A.Username,
										CONVERT(CHAR(10),R.DateCreated,101) AS DateCreated,
										CASE
											WHEN DATALENGTH(R.ProDescription) > 0 THEN R.ProDescription
											ELSE 'None'
										END AS ProDescription,
										CASE
											WHEN DATALENGTH(R.ConDescription) > 0 THEN R.ConDescription
											ELSE 'None'
										END AS ConDescription,
										R.IsApproved
						FROM			ProductReviews R
						JOIN			Accounts A ON R.AccountID = A.AccountID
							
						WHERE			R.ProductID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ProductID#" />
					<cfif Request.IsFrontEnd>
						AND				R.IsApproved = 1
						AND				A.Status = 1
					</cfif>
					
			) AS RowConstrainedResult

			WHERE		RowNum >= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.StartRow#" />
			AND			RowNum <= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.EndRow#" />
			
			ORDER BY 	RowNum
		</cfquery>
		
		<cfreturn loc_ProductReviews />	
	</cffunction>	
	
	<cffunction name="GetProductReviewDetails" returntype="query" output="no">
		<cfargument name="ReviewID" type="numeric" default="0" />
		
		<cfset var loc_ReviewDetails = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_ReviewDetails">
			SELECT		R.*, 
						A.Username
			FROM 		ProductReviews R
			JOIN		Accounts A ON R.AccountID = A.AccountID
			where		R.ReviewID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ReviewID#" />
		</cfquery>
		
		<cfreturn loc_ReviewDetails />	
	</cffunction>
	
	
	<cffunction name="UpdateProductReview" output="no">
		<cfargument name="ReviewID" type="numeric" default="0" />
		<cfargument name="ProductID" type="numeric" default="0" />
		<cfargument name="IsApproved" type="boolean" default="0">
		<cfargument name="ReturnUrl" type="string" required="yes" />
		
		<cfset var loc_ProductID = Arguments.ProductID />
		<cfset var loc_ReviewID = Arguments.ReviewID />
		<cfset var loc_StatusMessage = "" />
		<cfset var loc_UpdateReviewDetails = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_UpdateReviewDetails">
			UPDATE ProductReviews
			SET 
			IsApproved = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.IsApproved#" />,
			DateModified = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> 
			
			where ReviewID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ReviewID#" />
			
		</cfquery>
		
		<cfset loc_StatusMessage = "Product.Updated" />
		
		<cflocation url="#Arguments.ReturnUrl#&Message=#loc_StatusMessage#&ProductID=#loc_ProductID#&ReviewID=#loc_ReviewID#" addtoken="no" />

	</cffunction>
	
	
	<cffunction name="DeleteProductReview" output="no">
		<cfargument name="ReviewID" type="numeric" default="0" />
		<cfargument name="ProductID" type="numeric" default="0" />
		
		
		<cfset var loc_StatusMessage = "" />
		<cfset var loc_DeleteReviewDetails = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_DeleteReviewDetails">
			DELETE 
			FROM ProductReviews
			WHERE ReviewID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ReviewID#" />
			
		</cfquery>

	</cffunction>

	
</cfcomponent>