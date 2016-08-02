<cfcomponent> 
  <cfscript>
    THIS.name = "Craigslist Scraper"; 
    THIS.clientmanagement="True"; 
    THIS.loginstorage="Session"; 
    THIS.sessionmanagement="True"; 
    THIS.sessiontimeout="#createtimespan(0,0,10,0)#";
    THIS.applicationtimeout="#createtimespan(5,0,0,0)#";
    THIS.javaSettings = {
      LoadPaths = ["c:\coldfusion10\cfusion\lib\jsoup-1.8.1.jar"], 
      loadColdFusionClassPath = true, 
      reloadOnChange = false
    };
  </cfscript>
  
  <cffunction name="onRequestStart" returnType="boolean"> 
    <cfargument name="targetPage" type="string" required="true" /> 
    <cfparam name="SESSION.IsBlocked" default="false" />
    
    <cfsetting requesttimeout="600" />

    <cfscript>
      REQUEST.utility = CreateObject("component", "cfc.utility");
      
      REQUEST.mapsApiKey = "********";    
      REQUEST.geocodeUrl = "https://maps.googleapis.com/maps/api/geocode/json";
      
      REQUEST.proxyServer = "***.***.***.***";
      REQUEST.proxyPort = "10080";

      REQUEST.isSleepEnabled = false;
      REQUEST.threadSleepDuration = 3000;
      
      REQUEST.urlBase = "http://boston.craigslist.org";
      
      REQUEST.basePath = expandPath(".") & "\";
      
      REQUEST.htmlPath = REQUEST.basePath & "html\";
      REQUEST.htmlArchivePath = REQUEST.htmlPath & "archive\";
      
      REQUEST.sqlPath = REQUEST.basePath & "sql\";
      REQUEST.sqlArchivePath = REQUEST.sqlPath & "archive\";
      
      REQUEST.jsoup = CreateObject("java", "org.jsoup.Jsoup");
      
      REQUEST.parser = CreateObject("java", "org.jsoup.parser.Parser");
      
      REQUEST.xmlTreeBuilder = CreateObject("java", "org.jsoup.parser.XmlTreeBuilder");
      
      REQUEST.blockMessage = "This IP has been automatically blocked";
      REQUEST.blockError = "<p><strong>IP was blocked!</strong></p>";
      
      REQUEST.httpError = "<p><strong>HTTP result is NOT OK!</strong></p>";
    </cfscript>
		
    <cfreturn true /> 
  </cffunction>
  
</cfcomponent>
