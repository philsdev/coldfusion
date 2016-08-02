<cfcomponent name="utility">

	<cffunction name="flushOutput" output="true" access="public" returntype="any">
    <cfflush />
  </cffunction>

  <cffunction name="getURLParamValue" output="false" access="public" returntype="string">
    <cfargument name="paramString" type="string" required="true" />
    <cfargument name="keyName" type="string" required="true" />
    
    <cfset var loc_keyName = "" />
    <cfset var loc_keyValue = "" />
    <cfset var loc_keyNameValuePair = "" />
    
    <cfloop list="#arguments.paramString#" delimiters="&" index="loc_keyNameValuePair">
      <cfset loc_keyName = ListFirst(loc_keyNameValuePair, "=") />
      
      <cfif loc_keyName EQ arguments.keyName>
        <cfset loc_keyValue = ListLast(loc_keyNameValuePair, "=") />
      </cfif>
    </cfloop>
    
    <cfreturn loc_keyValue />  
  </cffunction>

  <cffunction name="getAttributes" output="false" access="public" returntype="struct">
    <cfargument name="attributeStruct" type="struct" required="true" />
    
    <cfset var loc_attribute = "" />
    <cfset var loc_attributes = StructNew() />
    
    <cfscript>
      for (loc_attribute in arguments.attributeStruct) {
        // bedrooms and bathrooms
        if (Find("BR", loc_attribute) AND Find("Ba", loc_attribute)) {
          if (ListLen(loc_attribute, "/") EQ 2) {
            loc_attributes.bedrooms = Replace(ListFirst(loc_attribute, "/"), "BR", "");
            loc_attributes.bathrooms = Replace(ListLast(loc_attribute, "/"), "Ba", "");
          }
        }
      
        // cats
        if (FindNoCase("cats are ok", loc_attribute)) {
          loc_attributes.cats = 1;
        }
        
        // dogs
        if (FindNoCase("dogs are ok", loc_attribute)) {
          loc_attributes.dogs = 1;
        }
        
        // laundry
        if (FindNoCase("w/d in unit", loc_attribute)) {
          loc_attributes.laundry = "in unit";
        } else if (FindNoCase("laundry in bldg", loc_attribute)) {
          loc_attributes.laundry = "in bldg";
        } else if (FindNoCase("laundry on site", loc_attribute)) {
          loc_attributes.laundry = "on site";
        } else if (FindNoCase("w/d hookups", loc_attribute)) {
          loc_attributes.laundry = "hookups";
        }
        
        // parking
        if (FindNoCase("off-street parking", loc_attribute)) {
          loc_attributes.parking = "off-street";
        } else if (FindNoCase("street parking", loc_attribute)) {
          loc_attributes.parking = "on-street";
        } else if (FindNoCase("attached garage", loc_attribute)) {
          loc_attributes.parking = "attached garage";
        } else if (FindNoCase("detached garage", loc_attribute)) {
          loc_attributes.parking = "detached garage";
        }
        
        // area
        if (FindNoCase("ft2", loc_attribute)) {
          loc_attributes.sqft = ReplaceNoCase(loc_attribute, "ft2", "");
        }
        
        // available
        if (FindNoCase("available", loc_attribute)) {
          loc_attributes.available = ReplaceNoCase(loc_attribute, "available", "");
        }
      }
    </cfscript>
    
    <cfreturn loc_attributes />
  </cffunction>

  <cffunction name="getGoogleAddressParts" output="false" access="public" returntype="struct" hint="Parse Google Map URL">
    <cfargument name="googleMapUrl" type="any" required="true" />

    <cfset var loc_addressParts = ListLast(arguments.googleMapUrl, "?") />
    <cfset var loc_addressQueryString = ListLast(URLDecode(loc_addressParts), "=") />
    <cfset var loc_addressQueryStringValues = ListLast(loc_addressQueryString, ":") />
    <cfset var loc_addressArray = ListToArray(loc_addressQueryStringValues, " ") />
    <cfset var loc_addressArrayLen = ArrayLen(loc_addressArray) />
    <cfset var loc_addressStruct = StructNew() />
    <cfset var loc_index = 0 />
    <cfset var loc_indexOffset = 0 />
    <cfset var loc_addressPart = "" />
    <cfset var loc_key = "" />
    <cfset var loc_value = "" />
    <cfset var loc_listLen = 0 />
    
    <cfset loc_addressStruct["street"] = "" />
    <cfset loc_addressStruct["city"] = "" />
    <cfset loc_addressStruct["state"] = "" />
    <cfset loc_addressStruct["country"] = "" />

    <cfif ArrayLen(loc_addressArray)>
      <cfloop array="#loc_addressArray#" index="loc_addressPart">
        <cfset loc_index++ />
        
        <cfset loc_indexOffset = loc_addressArrayLen - loc_index />      
        
        <cfswitch expression="#loc_indexOffset#">
          <cfcase value="0">
            <cfset loc_addressStruct["country"] = UCase(loc_addressPart) />
          </cfcase>
          <cfcase value="1">
            <cfset loc_addressStruct["state"] = UCase(loc_addressPart) />
          </cfcase>
          <cfcase value="2">
            <cfset loc_addressStruct["city"] = loc_addressPart />
          </cfcase>
          <cfdefaultcase>
            <cfset loc_addressStruct["street"] = ListAppend(loc_addressStruct["street"], loc_addressPart, " ") />
          </cfdefaultcase>
        </cfswitch>
      </cfloop>
    </cfif>
    
    <cfreturn loc_addressStruct />
  </cffunction>

  <cffunction name="getYahooAddressParts" output="false" access="public" returntype="struct" hint="Parse Yahoo Map URL">
    <cfargument name="yahooMapUrl" type="any" required="true" />
    
    <cfset var loc_addressParts = ListLast(arguments.yahooMapUrl, "?") />
    <cfset var loc_addressArray = ListToArray(URLDecode(loc_addressParts), "&") />
    <cfset var loc_addressStruct = StructNew() />
    <cfset var loc_index = "" />
    <cfset var loc_key = "" />
    <cfset var loc_value = "" />
    <cfset var loc_listLen = 0 />
    
    <cfloop array="#loc_addressArray#" index="loc_index">
      <cfset loc_key = ListFirst(loc_index, "=") />
      <cfset loc_value = ListLast(loc_index, "=") />
      
      <cfswitch expression="#loc_key#">
        <cfcase value="addr">
          <cfset loc_addressStruct["street"] = loc_value />
        </cfcase>
        <cfcase value="csz">
          <cfset loc_addressStruct["csz"] = loc_value />
          <cfset loc_addressStruct["state"] = UCase(ListLast(loc_value, " ")) />
          <cfset loc_listLen = ListLen(loc_value, " ") />
          <cfset loc_addressStruct["city"] = ListDeleteAt(loc_value, loc_listLen, " ") />
        </cfcase>
        <cfcase value="country">
          <cfset loc_addressStruct["country"] = UCase(loc_value) />
        </cfcase>
      </cfswitch>
    </cfloop>
    
    <cfreturn loc_addressStruct />
  </cffunction>

  <cffunction name="getReplymethods" output="false" access="public" returntype="struct">
    <cfargument name="replyUrl" type="any" required="true" />
    
    <cfset var loc_content = "" />
    <cfset var loc_replyMethods = StructNew() />
    <cfset var loc_dom = "" />
    
    <cfset loc_replyMethods["email"] = "" />
    
    <cfif NOT SESSION.IsBlocked>
      <cfset loc_content = getHTTP(arguments.replyUrl) />
      
      <cfif isHttpSuccess(loc_content.statusCode)>
        <cfset loc_dom = REQUEST.jsoup.parse(loc_content.fileContent, REQUEST.urlBase, REQUEST.parser.xmlParser()) />
        <cfset loc_replyMethods["email"] = loc_dom.select(".anonemail").text() />
        
        <!--- pause briefly --->
        <cfset REQUEST.utility.pause() />
      <cfelse>
        <cfset SESSION.IsBlocked = true />
      </cfif>
    </cfif>
    
    <cfreturn loc_replyMethods>
  </cffunction>

  <cffunction name="getHTTP" output="false" access="public" returntype="struct">
    <cfargument name="httpUrl" type="any" required="true" />
    <cfargument name="useProxy" type="any" default="false" />
    
    <cfset var loc_content = StructNew() />
    
    <cfset loc_content.FileContent = "" />
    <cfset loc_content.StatusCode = "" />
    
    <!---
    <cfif IsBoolean(arguments.useProxy) and arguments.useProxy EQ true>
      <cfhttp method="get" url="#arguments.httpUrl#" result="loc_content" proxyServer="#REQUEST.proxyServer#" proxyPort="#REQUEST.proxyPort#" timeout="5" />
    <cfelse>
      <cfhttp method="get" url="#arguments.httpUrl#" result="loc_content" timeout="5" />
    </cfif>   
    --->
    
    <cfif NOT SESSION.IsBlocked>
      <cfhttp method="get" url="#arguments.httpUrl#" result="loc_content" timeout="5" />
    </cfif>
    
    <cfreturn loc_content />
  </cffunction>

  <cffunction name="isHttpSuccess" output="false" access="public" returntype="boolean">
    <cfargument name="statusCode" type="any" required="true" />

    <cfset var loc_isSuccess = false />
    
    <cfif arguments.statusCode EQ "200 OK">
      <cfset loc_isSuccess = true />
    </cfif>
    
    <cfreturn loc_isSuccess />
  </cffunction>

  <cffunction name="getReverseGeocode" output="false" access="public" returntype="any">
    <cfargument name="latitude" type="any" required="true" />
    <cfargument name="longitude" type="any" required="true" />
    
    <cfset var loc_content = "" />
    <cfset var loc_geocodeUrl = REQUEST.geocodeUrl & "?latlng=" & arguments.latitude & "," & arguments.longitude & "&key=" & REQUEST.mapsApiKey />
    
    <cfhttp method="get" url="#loc_geocodeUrl#" result="loc_content" />
    
    <cfreturn loc_content>
  </cffunction>
    
  <cffunction name="dateToUTC" output="false" access="public" returntype="any" hint="Take a date and return the number of seconds since the Unix Epoch">
    <cfargument name="date" type="any" required="true" />
    <cfreturn dateDiff("s", dateConvert("utc2Local", "January 1 1970 00:00"), arguments.date) />
  </cffunction>

  <cffunction name="dateTimeToUTC" output="false" access="public" returntype="any" hint="Take a date and return the number of seconds since the Unix Epoch">
    <cfargument name="date" type="any" required="true" />
    
    <cfset var loc_date = ListFirst(arguments.date, "T") />
    <cfset var loc_timeLong = ListLast(arguments.date, "T") />
    <cfset var loc_time = ListFirst(loc_timeLong, "-") />
    <cfset var loc_dateTime = loc_date & " " & loc_time />
    
    <cfreturn dateToUTC(loc_dateTime) />
  </cffunction>

  <cffunction name="pause" output="false" access="public" returntype="void">
    <cfif REQUEST.isSleepEnabled>
      <cfset sleep(REQUEST.threadSleepDuration) />
    </cfif>
  </cffunction>

  <cffunction name="abort">
    <cfabort />
  </cffunction>

  <cffunction name="dump">
    <cfargument name="data" type="any" required="true" />
    
    <cfdump var="#data#">
  </cffunction>
	
</cfcomponent>