<cfcomponent extends="MachII.framework.Listener">

	<cffunction name="GetCleanUrl" access="public" output="false" returntype="string">
		<cfargument name="DirtyUrl" type="string" required="yes" />
		
		<cfset var loc_CleanUrl = TRIM( Arguments.DirtyUrl ) />
		
		<cfset loc_CleanUrl = REReplace( loc_CleanUrl, '[^a-zA-Z0-9_-]', '-', 'all' ) />
		<cfset loc_CleanUrl = Replace( loc_CleanUrl, '----', '-', 'all' ) />
		<cfset loc_CleanUrl = Replace( loc_CleanUrl, '---', '-', 'all' ) />
		<cfset loc_CleanUrl = Replace( loc_CleanUrl, '--', '-', 'all' ) />
		<cfset loc_CleanUrl = LCASE( loc_CleanUrl ) />
		
		<cfreturn loc_CleanUrl />
	</cffunction>
	
	<cffunction name="GetFriendlyUrl" access="public" output="false" returntype="string">
		<cfargument name="UrlBase" type="string" default="" />
		<cfargument name="ItemTitle" type="string" required="yes" />
		
		<cfset var loc_FriendlyUrl = GetCleanUrl( Arguments.ItemTitle ) & ".html" />
		
		<cfif LEN( Arguments.UrlBase )>
			<cfset loc_FriendlyUrl = Arguments.UrlBase & loc_FriendlyUrl />
		</cfif>
		
		<cfreturn loc_FriendlyUrl />
	</cffunction>
	
	<cffunction name="GetAbsoluteUrl" access="public" output="false" returntype="string">
		<cfargument name="RelativeUrl" type="string" default="" />
		
		<cfset var loc_RelativeUrl = TRIM( Arguments.RelativeUrl ) />
		<cfset var loc_AbsoluteUrl = "" />
		
		<!--- remove extra slash, if present in relative url --->
		<cfif LEFT( loc_RelativeUrl, 1 ) EQ "/">
			<cfset loc_RelativeUrl = RemoveChars( loc_RelativeUrl, 1, 1 ) />
		</cfif>
		
		<cfset loc_AbsoluteUrl = Request.Root.Web & loc_RelativeUrl />
		
		<cfreturn loc_AbsoluteUrl />
	</cffunction>
	
	<!-----------------------------------------------------------------------------------------------
		MAP
	------------------------------------------------------------------------------------------------>
	
	<cffunction name="GetMapLink" access="public" output="false" returntype="string">
		<cfargument name="AddressID" default="" />
		<cfargument name="AddressTitle" type="string" default="" />
		<cfargument name="Street1" type="string" default="" />
		<cfargument name="Street2" type="string" default="" />
		<cfargument name="City" type="string" default="" />
		<cfargument name="State" type="string" default="" />
		<cfargument name="ZipCode" type="string" default="" />
		
		<cfset var loc_IsValidAddress = false />
		<cfset var loc_AddressID = Arguments.AddressID />
		<cfset var loc_AddressDetails = "" />
		<cfset var loc_AddressTitle = "" />
		<cfset var loc_Street1 = "" />
		<cfset var loc_Street2 = "" />
		<cfset var loc_City = "" />
		<cfset var loc_State = "" />
		<cfset var loc_ZipCode = "" />
		<cfset var loc_HasAddressTitle = "" />
		<cfset var loc_HasStreet1 = "" />
		<cfset var loc_HasStreet2 = "" />
		<cfset var loc_HasCity = "" />
		<cfset var loc_HasState = "" />
		<cfset var loc_HasZipCode = "" />
		<cfset var loc_MapLink = "" />
		<cfset var loc_AccountManager = Request.ListenerManager.GetListener( "AccountManager" ) />
		
		<cfif IsNumeric( Arguments.AddressID )>
			<cfset loc_AddressDetails = loc_AccountManager.GetAddressDetails( AddressID:loc_AddressID ) />
			<cfset loc_AddressTitle = loc_AddressDetails.AddressTitle />
			<cfset loc_Street1 = loc_AddressDetails.Street1 />
			<cfset loc_Street2 = loc_AddressDetails.Street2 />
			<cfset loc_City = loc_AddressDetails.City />
			<cfset loc_State = loc_AddressDetails.State />
			<cfset loc_ZipCode = loc_AddressDetails.ZipCode />
		<cfelse>
			<cfset loc_AddressTitle = Arguments.AddressTitle />
			<cfset loc_Street1 = Arguments.Street1 />
			<cfset loc_Street2 = Arguments.Street2 />
			<cfset loc_City = Arguments.City />
			<cfset loc_State = Arguments.State />
			<cfset loc_ZipCode = Arguments.ZipCode />			
		</cfif>
		
		<cfset loc_HasAddressTitle = LEN(TRIM(loc_AddressTitle)) />
		<cfset loc_HasStreet1 = LEN(TRIM(loc_Street1)) />
		<cfset loc_HasStreet2 = LEN(TRIM(loc_Street2)) />
		<cfset loc_HasCity = LEN(TRIM(loc_City)) />
		<cfset loc_HasState = REFind('[A-Z]{2}', loc_State) />
		<cfset loc_HasZipCode = IsNumeric(ZipCode) />
		
		<cfif loc_HasAddressTitle>
			<cfset loc_MapLink = loc_MapLink & " " & loc_AddressTitle />
		</cfif>
		
		<!--- add separator after title if there is more to the address --->
		<cfif loc_HasAddressTitle AND (loc_HasStreet1 OR loc_HasStreet2 OR loc_HasCity OR loc_HasState OR loc_HasZipCode)>
			<cfset loc_MapLink = loc_MapLink & " |" />
		</cfif>
		
		<cfif loc_HasStreet1>
			<cfset loc_MapLink = loc_MapLink & " " & loc_Street1 />
		</cfif>
		
		<cfif loc_HasStreet2>
			<cfset loc_MapLink = loc_MapLink & " " & loc_Street2 />
		</cfif>
		
		<cfif loc_HasCity AND loc_HasState>
			<cfset loc_MapLink = loc_MapLink & " " & loc_City & ", " & loc_State />
		<cfelseif loc_HasCity>
			<cfset loc_MapLink = loc_MapLink & " " & loc_City />
		<cfelseif loc_HasState>
			<cfset loc_MapLink = loc_MapLink & " " & loc_State />
		</cfif>
		
		<cfif loc_HasZipCode>
			<cfset loc_MapLink = loc_MapLink & " " & loc_ZipCode />
		</cfif>
		
		<cfif NOT LEN( loc_MapLink )>
			<cfset loc_MapLink = "N/A" />
		</cfif>
		
		<cfif ( loc_HasCity AND loc_HasState ) OR loc_HasZipCode>
			<cfset loc_IsValidAddress = true />
		</cfif>
		
		<cfif loc_IsValidAddress>
			<cfset loc_MapLink = "<a href='/map-#loc_AddressID#.html' class='fancyPopup'>" & loc_MapLink & "</a>" />
		</cfif>
		
		<cfreturn loc_MapLink />
	</cffunction>
	
	<!-----------------------------------------------------------------------------------------------
		USER
	------------------------------------------------------------------------------------------------>
	
	<cffunction name="GetProfileLink" access="public" output="false" returntype="string">
		<cfargument name="UserID" type="numeric" required="yes" />
		<cfargument name="Username" type="string" required="yes" />
		
		<cfreturn GetFriendlyUrl( UrlBase:"/profile-#Arguments.UserID#/", ItemTitle:Arguments.Username ) />
	</cffunction>
	
	<!-----------------------------------------------------------------------------------------------
		COMMUNITY
	------------------------------------------------------------------------------------------------>
	
	<cffunction name="GetCommunityLink" access="public" output="false" returntype="string">
		<cfargument name="CommunityID" type="numeric" required="yes" />
		<cfargument name="CommunityTitle" type="string" required="yes" />
		
		<cfreturn GetFriendlyUrl( UrlBase:"/community-#Arguments.CommunityID#/", ItemTitle:Arguments.CommunityTitle ) />
	</cffunction>
	
	<cffunction name="GetCommunityCategoryLink" access="public" output="false" returntype="string">
		<cfargument name="CategoryID" type="numeric" required="yes" />
		<cfargument name="CategoryTitle" type="string" required="yes" />
		
		<cfreturn GetFriendlyUrl( UrlBase:"/community/category-#Arguments.CategoryID#/", ItemTitle:Arguments.CategoryTitle ) />
	</cffunction>
	
	<cffunction name="GetCommunityUserLink" access="public" output="false" returntype="string">
		<cfargument name="UserID" type="numeric" required="yes" />
		<cfargument name="Username" type="string" required="yes" />
		
		<cfreturn GetFriendlyUrl( UrlBase:"/community/user-#Arguments.UserID#/", ItemTitle:Arguments.Username ) />
	</cffunction>
	
	<!-----------------------------------------------------------------------------------------------
		DEALS
	------------------------------------------------------------------------------------------------>
	
	<cffunction name="GetDealLink" access="public" output="false" returntype="string">
		<cfargument name="DealID" type="numeric" required="yes" />
		<cfargument name="DealTitle" type="string" required="yes" />
		
		<cfreturn GetFriendlyUrl( UrlBase:"/deal-#Arguments.DealID#/", ItemTitle:Arguments.DealTitle ) />
	</cffunction>
	
	<cffunction name="GetDealCategoryLink" access="public" output="false" returntype="string">
		<cfargument name="CategoryID" type="numeric" required="yes" />
		<cfargument name="CategoryTitle" type="string" required="yes" />
		
		<cfreturn GetFriendlyUrl( UrlBase:"/deals/category-#Arguments.CategoryID#/", ItemTitle:Arguments.CategoryTitle ) />
	</cffunction>
	
	<cffunction name="GetDealUserLink" access="public" output="false" returntype="string">
		<cfargument name="UserID" type="numeric" required="yes" />
		<cfargument name="Username" type="string" required="yes" />
		
		<cfreturn GetFriendlyUrl( UrlBase:"/deals/user-#Arguments.UserID#/", ItemTitle:Arguments.Username ) />
	</cffunction>
	
	<!-----------------------------------------------------------------------------------------------
		EVENTS
	------------------------------------------------------------------------------------------------>
	
	<cffunction name="GetEventLink" access="public" output="false" returntype="string">
		<cfargument name="EventID" type="numeric" required="yes" />
		<cfargument name="EventTitle" type="string" required="yes" />
		
		<cfreturn GetFriendlyUrl( UrlBase:"/event-#Arguments.EventID#/", ItemTitle:Arguments.EventTitle ) />
	</cffunction>
	
	<cffunction name="GetEventCategoryLink" access="public" output="false" returntype="string">
		<cfargument name="CategoryID" type="numeric" required="yes" />
		<cfargument name="CategoryTitle" type="string" required="yes" />
		
		<cfreturn GetFriendlyUrl( UrlBase:"/events/category-#Arguments.CategoryID#/", ItemTitle:Arguments.CategoryTitle ) />
	</cffunction>
	
	<cffunction name="GetEventUserLink" access="public" output="false" returntype="string">
		<cfargument name="UserID" type="numeric" required="yes" />
		<cfargument name="Username" type="string" required="yes" />
		
		<cfreturn GetFriendlyUrl( UrlBase:"/events/user-#Arguments.UserID#/", ItemTitle:Arguments.Username ) />
	</cffunction>
	
	<!-----------------------------------------------------------------------------------------------
		JOBS
	------------------------------------------------------------------------------------------------>
	
	<cffunction name="GetJobLink" access="public" output="false" returntype="string">
		<cfargument name="JobID" type="numeric" required="yes" />
		<cfargument name="JobTitle" type="string" required="yes" />
		
		<cfreturn GetFriendlyUrl( UrlBase:"/job-#Arguments.JobID#/", ItemTitle:Arguments.JobTitle ) />
	</cffunction>
	
	<cffunction name="GetJobCategoryLink" access="public" output="false" returntype="string">
		<cfargument name="CategoryID" type="numeric" required="yes" />
		<cfargument name="CategoryTitle" type="string" required="yes" />
		
		<cfreturn GetFriendlyUrl( UrlBase:"/jobs/category-#Arguments.CategoryID#/", ItemTitle:Arguments.CategoryTitle ) />
	</cffunction>
	
	<cffunction name="GetJobUserLink" access="public" output="false" returntype="string">
		<cfargument name="UserID" type="numeric" required="yes" />
		<cfargument name="Username" type="string" required="yes" />
		
		<cfreturn GetFriendlyUrl( UrlBase:"/jobs/user-#Arguments.UserID#/", ItemTitle:Arguments.Username ) />
	</cffunction>
	
	<!-----------------------------------------------------------------------------------------------
		MARKETPLACE
	------------------------------------------------------------------------------------------------>
	
	<cffunction name="GetMarketplaceLink" access="public" output="false" returntype="string">
		<cfargument name="MarketplaceID" type="numeric" required="yes" />
		<cfargument name="MarketplaceTitle" type="string" required="yes" />
		
		<cfreturn GetFriendlyUrl( UrlBase:"/marketplace-#Arguments.MarketplaceID#/", ItemTitle:Arguments.MarketplaceTitle ) />
	</cffunction>
	
	<cffunction name="GetMarketplaceCategoryLink" access="public" output="false" returntype="string">
		<cfargument name="CategoryID" type="numeric" required="yes" />
		<cfargument name="CategoryTitle" type="string" required="yes" />
		
		<cfreturn GetFriendlyUrl( UrlBase:"/marketplace/category-#Arguments.CategoryID#/", ItemTitle:Arguments.CategoryTitle ) />
	</cffunction>
	
	<cffunction name="GetMarketplaceUserLink" access="public" output="false" returntype="string">
		<cfargument name="UserID" type="numeric" required="yes" />
		<cfargument name="Username" type="string" required="yes" />
		
		<cfreturn GetFriendlyUrl( UrlBase:"/marketplace/user-#Arguments.UserID#/", ItemTitle:Arguments.Username ) />
	</cffunction>	
	
	<!-----------------------------------------------------------------------------------------------
		STUDY GROUPS
	------------------------------------------------------------------------------------------------>
	
	<cffunction name="GetStudyGroupLink" access="public" output="false" returntype="string">
		<cfargument name="StudyGroupID" type="numeric" required="yes" />
		<cfargument name="StudyGroupTitle" type="string" required="yes" />
		
		<cfreturn GetFriendlyUrl( UrlBase:"/study-group-#Arguments.StudyGroupID#/", ItemTitle:Arguments.StudyGroupTitle ) />
	</cffunction>

	<cffunction name="GetStudyGroupCourseLink" access="public" output="false" returntype="string">
		<cfargument name="CourseID" type="numeric" required="yes" />
		<cfargument name="CourseTitle" type="string" required="yes" />
		
		<cfreturn GetFriendlyUrl( UrlBase:"/study-groups/course-#Arguments.CourseID#/", ItemTitle:Arguments.CourseTitle ) />
	</cffunction>	
	
	<cffunction name="GetStudyGroupUserLink" access="public" output="false" returntype="string">
		<cfargument name="UserID" type="numeric" required="yes" />
		<cfargument name="Username" type="string" required="yes" />
		
		<cfreturn GetFriendlyUrl( UrlBase:"/study-groups/user-#Arguments.UserID#/", ItemTitle:Arguments.Username ) />
	</cffunction>	
	
</cfcomponent>