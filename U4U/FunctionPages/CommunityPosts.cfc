<cfcomponent extends="MachII.framework.Listener">

	<cfscript>
		this.SortOptions = ArrayNew(1);
		
		this.SortOptions[1] = ["datecreated","Date Created","P.DateCreated"];
		this.SortOptions[2] = ["title","Description","P.Description"];
		this.SortOptions[3] = ["community","Community","C.Title"];
		this.SortOptions[4] = ["category","Category","CAT.Title"];
		this.SortOptions[5] = ["username","Username","A.Username"];
		this.SortOptions[6] = ["status","Status","ST.Status"];
	</cfscript>
	
	<cffunction name="GetSortOptions" access="public" output="false" returntype="array"> 
		<cfreturn this.SortOptions />
	</cffunction>
	
	<cffunction name="GetCommunityPosts" access="public" output="false" returntype="query">    
		<cfargument name="Category" type="string" default="" />
		<cfargument name="CommunityID" type="string" default="" />
		<cfargument name="Description" type="string" default="" />
		<cfargument name="User" type="string" default="" />
		<cfargument name="Status" type="string" default="" />
		<cfargument name="sidx" type="string" required="no" default="#this.SortOptions[1][3]#" />
		<cfargument name="sord" type="string" required="no" default="desc" />
        
		<cfset var loc_CommunityPosts = "" />
        
		<cftry>
		<cfquery datasource="#request.dsource#" name="loc_CommunityPosts">
			SELECT		*
			FROM  (
					  
						SELECT			ROW_NUMBER() OVER ( ORDER BY #Arguments.sidx# ) AS RowNum,
										COUNT(*) OVER () as Row_Total,
										P.ID,
										CASE
											WHEN LEN(P.Description) >= #REQUEST.ShortDescriptionLength# THEN LEFT(P.Description,#REQUEST.ShortDescriptionLength#) + '...'
											ELSE P.Description
										END AS Title,
										P.Description,
										P.CommunityID,
										C.Title AS Community,
										C.CategoryID,
										CAT.Title AS Category,
										P.UserID,
										A.Username,
										A.Signature,
										ISNULL(POSTS.Total,0) AS UserPostCount,
										PR.Description AS QuoteDescription,
										CONVERT(CHAR(10),P.DateCreated,101) AS DateCreated,
										P.DateCreated AS DatePosted,
										ST.Status
						
						FROM			AMP_CommunityPosts P
						JOIN			AMP_Communities C ON P.CommunityID = C.ID
						JOIN			AMP_CommunityCategories CAT ON C.CategoryID = CAT.ID
						JOIN			AMP_Accounts A ON P.UserID = A.ID
						JOIN			AMP_Status ST ON P.Status = ST.ID
						
						LEFT JOIN		(
											SELECT		COUNT(*) AS Total,
														UserID
											FROM		AMP_CommunityPosts
											GROUP BY	UserID
										) POSTS ON P.UserID = POSTS.UserID
						
						LEFT JOIN		AMP_CommunityPosts PR ON P.ReplyPostID = PR.ID
						
						WHERE			1=1
					<cfif LEN(Arguments.Description)>
						AND				P.Description LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Arguments.Description#%" />		
					</cfif>
					<cfif IsNumeric(Arguments.User)>
						AND				P.UserID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.User#" />		
					</cfif>
					<cfif IsNumeric(Arguments.Category)>
						AND				C.CategoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Category#" />		
					</cfif>
					<cfif IsNumeric(Arguments.CommunityID)>
						AND				P.CommunityID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.CommunityID#" />		
					</cfif>
					<cfif IsBoolean(Arguments.Status)>
						AND				P.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />		
					</cfif>
					
					<cfif Request.IsFrontEnd>
						AND				P.CommunityID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.CommunityID#" />		
						AND				P.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
						AND				C.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
						AND				CAT.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="1" />
						<!--- AND				A.Status = <cfqueryparam cfsqltype="cf_sql_bit" value="1" /> --->
					</cfif>
			
			) AS RowConstrainedResult

			WHERE		RowNum >= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.StartRow#" />
			AND			RowNum <= <CFQUERYPARAM cfsqltype="cf_sql_integer" value="#Arguments.EndRow#" />
			
			ORDER BY 	RowNum		
		</cfquery>
		<cfcatch type="any">
			<cfdump var="#cfcatch#">
			<cfabort>
		</cfcatch>
		</cftry>
		
		<cfreturn loc_CommunityPosts />
	</cffunction>
	
	<cffunction name="GetCommunityPostDetails" access="public" output="false" returntype="query">    
		<cfargument name="CommunityPostID" default="0" />
        
		<cfset var loc_Post = "" />
        
		<cfquery datasource="#request.dsource#" name="loc_Post">
			SELECT		P.ID,
						P.Description,
						A.Username,
						P.Status
			
			FROM		AMP_CommunityPosts P
			JOIN		AMP_Accounts A ON P.UserID = A.ID
			
			WHERE		P.ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.CommunityPostID#" />
		</cfquery>		
		
		<cfreturn loc_Post />
	</cffunction> 
	
	<cffunction name="ReplyToCommunityPost" access="public" output="false" returntype="void">    
		<cfargument name="CommunityID" type="numeric" required="yes" />
		<cfargument name="CommunityPostID" default="" />
		<cfargument name="User" type="numeric" required="yes" />
		<cfargument name="Description" type="string" default="" />
				
		<cfset var loc_Reply = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_Reply">
			INSERT INTO AMP_CommunityPosts(
				CommunityID,
				UserID,
				ReplyPostID,
				Description,
				Status,
				DateCreated				
			) VALUES (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.CommunityID#" />,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.User#" />,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.CommunityPostID#" null="#NOT( IsNumeric( Arguments.CommunityPostID ) )#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Description#" />,
				<cfqueryparam cfsqltype="cf_sql_bit" value="1" />,
				GETDATE()
			)
		</cfquery>
		
	</cffunction>
	
	<cffunction name="UpdateCommunityPost" access="public" output="true" returntype="void">    
		<cfargument name="CommunityPostID" default="0" />
		<cfargument name="Description" type="string" default="" />		
		<cfargument name="Status" default="1" />
		<cfargument name="ReturnUrl" type="string" required="yes" />
		
		<cfset var loc_UpdateCommunityPost = "" />
		<cfset var loc_CommunityPostID = Arguments.CommunityPostID />
		<cfset var loc_StatusMessage = "" />
		<cfset var loc_ReturnUrl = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_UpdateCommunityPost">
			DECLARE @CommunityPostID AS Int;

			SET @CommunityPostID = (
				SELECT	ID
				FROM	AMP_CommunityPosts
				WHERE	ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_CommunityPostID#" />
			);
			
			IF @CommunityPostID IS NOT NULL
			
				UPDATE	AMP_CommunityPosts
			
				SET		Description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Description#" />,
						Status = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Status#" />,
						DateModified = GETDATE()
			
				WHERE	ID = @CommunityPostID;
		</cfquery>
		
		<cfset loc_StatusMessage = "CommunityPost.Updated" />
		
		<cfset loc_ReturnUrl = Arguments.ReturnUrl & "&CommunityPostID=" & loc_CommunityPostID & "&Message=" & loc_StatusMessage />
		
		<cflocation url="#loc_ReturnUrl#" addtoken="no" />	
		
	</cffunction> 
	
	<cffunction name="DeleteCommunityPost" access="public" output="false" returntype="void">    
		<cfargument name="CommunityPostID" type="numeric" required="yes" />
		
		<cfset var loc_DeletePost = "" />
		
		<cfquery datasource="#request.dsource#" name="loc_DeletePost">
			DELETE
			FROM		AMP_CommunityPosts
			WHERE		ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.CommunityPostID#" />
		</cfquery>
		
	</cffunction>
	
</cfcomponent>