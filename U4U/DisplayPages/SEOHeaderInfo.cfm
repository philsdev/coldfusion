
<!--- Need to get all parameters if passed --->
<cfset SiteTitle = #request.event.getArg('SiteTitle')# />
<cfset SiteDescription = #request.event.getArg('SiteDescription')# />
<cfset SiteSummary = #request.event.getArg('SiteSummary')# />
<cfset SiteKeywords = #request.event.getArg('SiteKeywords')# />

<cfset ContentManagedEvents = "" />

<!--- //////////////////// GET THE SEO TITLE //////////////////// --->
<cfif ISDEFINED("SiteTitle") AND TRIM(SiteTitle) IS NOT "">
	<cfparam name="Title" default="#SiteTitle#" />

<cfelseif isdefined("URL.Page") AND #trim(PageDetails.MetaTitle)# IS NOT "">
	<cfparam name="Title" default="#trim(PageDetails.MetaTitle)#" />

<cfelseif isdefined("URL.Page") AND #trim(PageDetails.PageTitle)# IS NOT "">
	<cfparam name="Title" default="#trim(PageDetails.PageTitle)#" />

<cfelseif isdefined("ProductNameVal")>
	<cfif #trim(ProductDetails.MetaTitle)# IS NOT "">
    	<cfparam name="Title" default="#trim(ProductDetails.MetaTitle)#" />
    <cfelse>
    	<cfparam name="Title" default="#trim(ProductDetails.ProductName)#" />
    </cfif>
	
<cfelseif (NOT IsDefined("url.event") OR IsDefined("url.event") AND ListContains(ContentManagedEvents,url.event)) AND (IsDefined("request.PageDetails") AND StructKeyExists(request.PageDetails,"metaTitle"))>
	<cfparam name="Title" default="#trim(request.PageDetails.metaTitle)#" />
	
<cfelse>
	<cfparam name="Title" default="#Request.WebDisplay#" />
</cfif>


<!--- //////////////////// GET THE SEO DESCRIPTION //////////////////// --->

<!--- Need to see if a SiteDescription parameter has been passed --->
<cfif ISDEFINED("SiteDescription") AND TRIM(SiteDescription) NEQ "">
	<cfparam name="Description" default="#SiteDescription#" />
    
<cfelseif isdefined("URL.Page") AND #trim(PageDetails.MetaDescription)# IS NOT "">
	<cfparam name="Description" default="#trim(PageDetails.MetaDescription)#" />
    
<cfelseif isdefined("URL.Page") AND #trim(PageDetails.PageDesc)# IS NOT "">
	<cfparam name="Description" default="#trim(PageDetails.PageDesc)#" />

<cfelseif isdefined("ProductNameVal")>
	<cfif #trim(ProductDetails.MetaDescription)# IS NOT "">
    	<cfparam name="Description" default="#trim(ProductDetails.MetaDescription)#" />
    <cfelse>
    	<cfparam name="Description" default="#trim(ProductDetails.ShortDescription)#" />
    </cfif>

<cfelseif NOT IsDefined("url.event") AND (IsDefined("request.PageDetails") AND StructKeyExists(request.PageDetails,"MetaDescription"))>
	<cfparam name="Description" default="#trim(request.PageDetails.MetaDescription)#" />
	
<cfelse>
	<cfparam name="Description" default="#Request.WebDisplay#" />
</cfif>


<!--- //////////////////// GET THE SEO SUMMARY //////////////////// --->

<!--- Need to see if a SiteSummary parameter has been passed --->
<cfif ISDEFINED("SiteSummary") AND SiteSummary IS NOT "">
	<cfparam name="Summary" default="#SiteSummary#" />

<cfelseif isdefined("URL.Page") AND #trim(PageDetails.MetaDescription)# IS NOT "">
	<cfparam name="Summary" default="#trim(PageDetails.MetaDescription)#" />
    
<cfelseif isdefined("URL.Page") AND #trim(PageDetails.PageDesc)# IS NOT "">
	<cfparam name="Summary" default="#trim(PageDetails.PageDesc)#" />

<cfelseif isdefined("ProductNameVal")>
	<cfif #trim(ProductDetails.MetaDescription)# IS NOT "">
    	<cfparam name="Summary" default="#trim(ProductDetails.MetaDescription)#" />
    <cfelse>
    	<cfparam name="Summary" default="#trim(ProductDetails.ShortDescription)#" />
    </cfif>

<!--- This is the default Description --->
<cfelse>
	<cfparam name="Summary" default="#Request.WebDisplay#" />
</cfif>

<!--- //////////////////// GET THE SEO KEYWORDS //////////////////// --->


<!--- Need to see if a SiteKeywords parameter has been passed --->
<cfif ISDEFINED("SiteKeywords") AND SiteKeywords IS NOT "">
	<cfparam name="Keywords" default="#SiteKeywords#" />

<cfelseif isdefined("ProductNameVal")>
	<cfif #trim(ProductDetails.MetaKeywords)# IS NOT "">
    	<cfparam name="Keywords" default="#trim(ProductDetails.MetaKeywords)#" />
    <cfelse>
    	<cfparam name="Keywords" default="#trim(ProductDetails.ProductName)#" />
    </cfif>

<!--- This is the default Description --->
<cfelse>
	<cfparam name="Keywords" default="#Request.WebDisplay#" />
</cfif>