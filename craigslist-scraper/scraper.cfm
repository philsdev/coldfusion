<!DOCTYPE html>
<html>
<head>
<title>CL Getter</title>
<script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
</head>
<body>

<h1>Scraper</h1>

<cfset SESSION.PropertyTitles = ArrayNew(1) />

<p>IP Block: <cfoutput>#YesNoFormat(SESSION.IsBlocked)#</cfoutput></p>

<!---
  <select name="category">
    <option value="hhh">all</option>
    <option value="fee">apts broker fee</option>
    <option value="nfb">apts broker no fee</option>
    <option selected="selected" value="abo">apts by owner</option>
    <option value="aiv">apts registration fee</option>
    <option value="hou">apts wanted</option>
    <option value="swp">housing swap</option>
    <option value="off">office & commercial</option>
    <option value="prk">parking & storage</option>
    <option value="reb">real estate - by broker</option>
    <option value="reo">real estate - by owner</option>
    <option value="rew">real estate wanted</option>
    <option value="roo">rooms & shares</option>
    <option value="sha">rooms wanted</option>
    <option value="sbw">sublet/temp wanted</option>
    <option value="sub">sublets & temporary</option>
    <option value="vac">vacation rentals</option>
  </select>
--->

<form method="get">
  <p>
    Get 
    <select name="max">
      <option value="">all</option>
      <option value="10">10</option>
      <option value="50">50</option>
      <option value="100">100</option>
      <option value="250">250</option>
      <option value="500">500</option>
    </select>
    of today's
    <select name="category">
      <option value="abo">rentals</option>
      <option value="rea">sales</option>
    </select>
    in
    <select name="area">
      <option value="gbs">boston/camb/brook</option>
      <option value="bmw">metro west</option>
      <option value="nos">north shore</option>
      <option value="nwb">northwest/merrimack</option>
      <option value="sob">south shore</option>
      <option value="">all boston</option>
    </select>
  </p>
  <p><button type="submit">SCRAPE</button></p>
</form>

<cfif IsDefined("URL.category") AND IsDefined("URL.area")>
  <cfscript>
    switch (URL.category) {
      case "abo": {
        variables.priceMin = "500";
        variables.priceMax = "5000";
        break;
      }
      case "rea": {
        variables.priceMin = "50000";
        variables.priceMax = "5000000";
        break;
      }
    }

    variables.searchUri = "/search/";

    if (LEN(URL.area)) {
      variables.searchUri = variables.searchUri & URL.area & "/";
    }
    
    variables.searchUri = variables.searchUri & URL.category;
    variables.searchUri = variables.searchUri & "?srchType=T&hasPic=1&postedToday=1&minAsk=" & variables.priceMin & "&maxAsk=" & variables.priceMax;
  </cfscript>
<cfelse>
  <cfset variables.searchUri = "" />
</cfif>

<cfparam name="FORM.NextPage" default="#variables.searchUri#" />
<cfparam name="SESSION.PropertyTitles" default="#ArrayNew(1)#" />

<cfif NOT LEN(FORM.NextPage)>
  <cfabort />
</cfif>

<cfscript>  
  variables.isStopped = false;
  
  variables.maxRows = 100;
  
  variables.indexBase = 0;
  
  variables.skipCount = 0;

  variables.searchUrl = REQUEST.urlBase & FORM.NextPage;
  
  variables.searchParams = ListLast(variables.searchUrl, "?");
  
  variables.currentIndexBase = REQUEST.utility.getURLParamValue(variables.searchParams, "s");
  
  if (IsNumeric(variables.currentIndexBase)) {
    variables.indexBase = variables.currentIndexBase;
  }
  
  WriteOutput("<p>GETTING: " & variables.searchUrl & "</p>");
  REQUEST.utility.flushOutput();

  variables.allResult = REQUEST.utility.getHTTP(variables.searchUrl);

  variables.all = variables.allResult.FileContent;
  
  /* halt execution if IP block message present */
  if (FindNoCase(REQUEST.blockMessage, variables.all)) {
    WriteOutput(REQUEST.blockError);
    REQUEST.utility.abort();    
  }
  
  /* halt execution if HTTP result is not OK */
  if (NOT REQUEST.utility.isHttpSuccess(variables.allResult.statusCode)) {
    WriteOutput(REQUEST.httpError);
    REQUEST.utility.abort();    
  }  
  
  variables.pageError = "";

  variables.tickStart = getTickCount();
  
  variables.html = trim(variables.all);

  variables.html = replaceNoCase(variables.html, "<!DOCTYPE html>", "", "ALL");   
  
  REQUEST.jsoup = createObject("java", "org.jsoup.Jsoup");
  
  REQUEST.parser = createObject("java", "org.jsoup.parser.Parser");
  
  variables.xmlTreeBuilder = createObject("java", "org.jsoup.parser.XmlTreeBuilder");
  
  variables.dom = REQUEST.jsoup.parse(variables.html, REQUEST.urlBase, REQUEST.parser.xmlParser());
  
  variables.next = variables.dom.select("a.button.next").attr("href");
  
  variables.rows = variables.dom.select("a.hdrlnk");

  variables.items = structNew();
  
  for (variables.row in variables.rows) {
    /* variables.items[variables.row.attr("data-id")] = REQUEST.urlBase & variables.row.attr("href"); */
    variables.items[variables.row.attr("data-id")] = StructNew();
    
    variables.items[variables.row.attr("data-id")]["url"] = REQUEST.urlBase & variables.row.attr("href");
    
    variables.items[variables.row.attr("data-id")]["title"] = variables.row.text();
  }
</cfscript>

<cfset variables.itemIndex = 1 + variables.indexBase />

<cfloop collection="#variables.items#" item="variables.item">
  <cfset variables.itemUrl = variables.items[variables.item]["url"] />
  <cfset variables.itemTitle = variables.items[variables.item]["title"] />
  
  <cfif NOT ArrayFindNoCase(SESSION.PropertyTitles, variables.itemTitle)>
    <cfset ArrayAppend(SESSION.PropertyTitles, variables.itemTitle) />
    
    <cfhttp method="get" url="#variables.itemUrl#" result="variables.page" />
    
    <!--- halt execution if IP block message present --->
    <cfif FindNoCase(REQUEST.blockMessage, variables.page.fileContent)>
      <cfbreak />
      <cfset variables.isStopped = true />
      <cfset variables.pageError = REQUEST.blockError />
    </cfif>    
    
    <!--- halt execution if HTTP status is not ok --->
    <cfif NOT REQUEST.utility.isHttpSuccess(variables.page.statusCode)>
      <cfbreak />
      <cfset variables.isStopped = true />
      <cfset variables.pageError = REQUEST.httpError />
    </cfif>
  
    <cfset variables.itemUri = ListLast(variables.itemUrl, "/") />
  
    <cfset variables.item_path = REQUEST.htmlPath & variables.itemUri />
  
    <cffile action="write" file="#variables.item_path#" output="#trim(variables.page.fileContent)#" />

    <cfoutput>[#variables.itemIndex#]</cfoutput>
    
    <!--- pause briefly --->
    <cfset REQUEST.utility.pause() />
  <cfelse>    
    <cfoutput>[X]</cfoutput>
    <cfset variables.skipCount++ />
  </cfif>
  
  <cfflush />
  
  <cfset variables.itemIndex = variables.itemIndex + 1 />
</cfloop>

<cfset variables.elapsedTime = ((getTickCount() - variables.tickStart) / 1000) />

<p>Elapsed Time: <cfoutput>#variables.elapsedTime#</cfoutput></p>

<p>Skipped: <cfoutput>#variables.skipCount#</cfoutput></p>

<cfif variables.isStopped>
  <cfoutput>#variables.pageError#</cfoutput>
<cfelse>
  <!--- if row count is less than max, no more pages to load --->
  <cfif structCount(variables.items) EQ variables.maxRows>
    <script>
      jQuery(document).ready(function() {
        jQuery("#poster").submit();
      });
    </script>

    <form method="post" id="poster">
      <input type="hidden" name="NextPage" id="next-page" value="<cfoutput>#variables.next#</cfoutput>" />
    </form>
  </cfif>
</cfif>

</body>
</html>