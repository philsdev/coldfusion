<!DOCTYPE html>
<html>
<head>
<title>CL Parser</title>
<script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
</head>
<body>

<p>IP Block: <cfoutput>#YesNoFormat(SESSION.IsBlocked)#</cfoutput></p>

<cfscript>  
  variables.tickStart = GetTickCount();
  
  variables.currentDate = Now();
  
  variables.unixTimeStamp = REQUEST.utility.dateToUTC(variables.currentDate);
  
  variables.htmlFiles = DirectoryList(
    REQUEST.htmlPath,
    false,
    "path",
    "*.html"
  );
  
  variables.sql = "";
  
  variables.totalCount = 0;
  variables.count = 0;
  
  variables.smokingOptions = ArrayNew(1);
  variables.parkingOptions = ArrayNew(1);
  variables.laundryOptions = ArrayNew(1);
  variables.cszOptions = ArrayNew(1);
  
  if (NOT ArrayLen(variables.htmlFiles)) {
    WriteOutput("<h1>No Files!</h1><hr />");
  }
  
  for (variables.htmlFile in variables.htmlFiles) {
    variables.totalCount++;
    
    variables.isProcessed = false;
    
    // debug var to hold values
    variables.page = StructNew();
    
    // var to hold values for db insert
    variables.insert = StructNew();
    
    variables.fileUri = ListLast(variables.htmlFile, "\");    
    
    // get file contents
    variables.fileContents = FileRead(variables.htmlFile);
    
    // get archive location
    variables.htmlArchiveFile = REQUEST.htmlArchivePath & variables.fileUri;
    
    // archive file
    FileMove(variables.htmlFile, variables.htmlArchiveFile);
    
    // parse file contents
    variables.dom = REQUEST.jsoup.parse(variables.fileContents, REQUEST.urlBase, REQUEST.parser.xmlParser());
    
    // set maps
    variables.maps = variables.dom.select(".mapaddress a");
    
    variables.page.maps = StructNew();
    
    // only want properties with maps (w/o are bogus)
    if (ArrayLen(variables.maps)) {
      for (variables.map in variables.maps) {
        variables.page.maps[variables.map.text()] = variables.map.attr("href");
      }
      
      // ADDRESS
      
      // only want properties with Google map
      if (StructKeyExists(variables.page.maps, "google map")) {
        variables.page.addressParts = REQUEST.utility.getGoogleAddressParts(variables.page.maps["google map"]);
        
        // only want properties where we could pull address parts from Google map URL
        if (NOT StructIsEmpty(variables.page.addressParts)) {
          
          // get breadcrumb
          variables.page.breadcrumb = variables.dom.select(".breadcrumbs .category").text();          
          
          if (FindNoCase("real estate", variables.page.breadcrumb)) {
            variables.page.category = "RHFS";
            variables.page.status = "for_sale";
          } else {
            variables.page.category = "RHFR";
            variables.page.status = "for_rent";
          }
          
          // set category
          variables.insert["category"] = variables.page.category;
          
          // set status
          variables.insert["status"] = variables.page.status;
          
          variables.insert["street"] = variables.page.addressParts.street;
          variables.insert["city"] = variables.page.addressParts.city;
          variables.insert["state"] = UCase(variables.page.addressParts.state);
      
          // set external id
          variables.page.external_id = ListFirst(variables.fileUri, ".");
          
          variables.insert["external_id"] = variables.page.external_id;
          
          // set source
          variables.page.filter = "CRAIG";
          
          variables.insert["filter"] = variables.page.filter;
          
          // set external_url
          variables.page.external_url = variables.dom.select("meta[property=og:url]").attr("content");
          
          variables.insert["external_url"] = variables.page.external_url;
          
          // set title
          variables.page.title = variables.dom.select("title").text();
          
          variables.insert["title"] = variables.page.title;
          
          // set price
          variables.page.price = variables.dom.select(".price").text();
          variables.page.price = ReplaceNoCase(variables.page.price, "$", "", "ALL");
          variables.page.price = ReplaceNoCase(variables.page.price, "&##x0024;", "", "ALL");
          
          variables.insert["price"] = variables.page.price;
          
          // set date posted
          variables.page.created = REQUEST.utility.dateTimeToUTC(variables.dom.select("time").attr("datetime"));
          
          variables.insert["created"] = variables.page.created;
          
          // set date expires (+45 days)
          variables.page.expires = variables.page.created + (45*86400);
          
          variables.insert["expires"] = variables.page.expires;
          
          // set date crawled
          variables.insert["crawled"] = variables.unixTimeStamp;
          
          // set body
          variables.page.body = variables.dom.select("##postingbody").text();
          
          variables.insert["body"] = Trim(variables.page.body);
          
          // get images
          variables.images = variables.dom.select(".slide > img");
          
          // get thumbs
          variables.thumbs = variables.dom.select("##thumbs > a > img");
          
          variables.page.image = "";
          
          variables.page.images = ArrayNew(1);
          
          variables.page.thumbs = ArrayNew(1);
          
          // set images
          for (variables.image in variables.images) {
            ArrayAppend(variables.page.images, variables.image.attr("src"));
          }
          
          // set thumbs
          for (variables.thumb in variables.thumbs) {
            ArrayAppend(variables.page.thumbs, variables.thumb.attr("src"));     
          }
          
          variables.insert["thumbs"] = SerializeJSON(variables.page.thumbs);
          
          // add missing images based on thumbs
          for (variables.t = 1; variables.t LTE ArrayLen(variables.page.thumbs); variables.t++) {
            if (NOT ArrayIsDefined(variables.page.images, variables.t)) {
              ArrayAppend(variables.page.images, ReplaceNoCase(variables.page.thumbs[variables.t], "50x50c", "600x450"));
            }
          }
          
          variables.insert["images"] = SerializeJSON(variables.page.images);
          
          // set main image
          if (ArrayIsDefined(variables.page.images, 1)) {
            variables.page.image = variables.page.images[1];
            
            variables.insert["image"] = variables.page.image;
          }
          
          // set main thumb
          if (ArrayIsDefined(variables.page.thumbs, 1)) {
            variables.page.thumb = variables.page.thumbs[1];
            
            variables.insert["thumb"] = variables.page.thumb;
          }          
          
          // set reply link
          variables.page.reply = variables.dom.select("##replylink").attr("href");
          
          if (LEN(variables.page.reply)) {
            variables.page.reply = REQUEST.urlBase & variables.page.reply;
            
            variables.page.replyMethods = REQUEST.utility.getReplymethods(variables.page.reply);

            if (LEN(variables.page.replyMethods.email)) {
              variables.insert["email"] = variables.page.replyMethods.email;
            }
          }
          
          // set latitude
          variables.page.latitude = variables.dom.select("##map").attr("data-latitude");
          
          variables.insert["latitude"] = variables.page.latitude;
          
          // set longitude
          variables.page.longitude = variables.dom.select("##map").attr("data-longitude");
          
          variables.insert["longitude"] = variables.page.longitude;   
          
          // get attributes
          variables.attributes = variables.dom.select(".attrgroup").first();
          
          variables.page.attributes = ArrayNew(1);
          
          for (variables.attribute in variables.attributes.select("span")) {
            ArrayAppend(variables.page.attributes, variables.attribute.text());     
          }
          
          // set default attributes
          variables.page.bedrooms = 0;
          variables.page.bathrooms = 0;
          variables.page.cats = 0;
          variables.page.dogs = 0;
          variables.page.laundry = "";
          variables.page.parking = "";
          variables.page.smoking = 0;
          variables.page.sqft = 0;
          variables.page.available = "";
          variables.page.type = "apartment";
          
          for (variables.attribute in variables.page.attributes) {
            // type
            if (FindNoCase("apartment", variables.attribute)) {
              variables.page.type = "apartment";
            } else if (FindNoCase("house", variables.attribute)) {
              variables.page.type = "house";
            } else if (FindNoCase("condo", variables.attribute)) {
              variables.page.type = "condo";
            } else if (FindNoCase("townhouse", variables.attribute)) {
              variables.page.type = "townhouse";
            }
            
            // bedrooms and bathrooms
            if (Find("BR", variables.attribute) AND Find("Ba", variables.attribute)) {
              if (ListLen(variables.attribute, "/") EQ 2) {
                variables.page.bedrooms = Replace(ListFirst(variables.attribute, "/"), "BR", "");
                
                variables.insert["bedrooms"] = Trim(variables.page.bedrooms);

                variables.page.bathrooms = Replace(ListLast(variables.attribute, "/"), "Ba", "");
                
                variables.insert["bathrooms"] = Trim(variables.page.bathrooms);
              }
            }
          
            // cats
            if (FindNoCase("cats are ok", variables.attribute)) {
              variables.page.cats = 1;
            }
            
            // dogs
            if (FindNoCase("dogs are ok", variables.attribute)) {
              variables.page.dogs = 1;
            }
            
            // laundry
            if (FindNoCase("w/d in unit", variables.attribute)) {
              variables.page.laundry = "in unit";
            } else if (FindNoCase("laundry in bldg", variables.attribute)) {
              variables.page.laundry = "in bldg";
            } else if (FindNoCase("laundry on site", variables.attribute)) {
              variables.page.laundry = "on site";
            } else if (FindNoCase("w/d hookups", variables.attribute)) {
              variables.page.laundry = "hookups";
            }
            
            if (FindNoCase("w/d", variables.attribute) OR FindNoCase("laundry", variables.attribute)) {
              if (NOT ArrayFindNoCase(variables.laundryOptions, variables.attribute)) {
                ArrayAppend(variables.laundryOptions, variables.attribute);
              }
            }
            
            // parking
            if (FindNoCase("off-street parking", variables.attribute)) {
              variables.page.parking = "off-street";
            } else if (FindNoCase("street parking", variables.attribute)) {
              variables.page.parking = "on-street";
            } else if (FindNoCase("attached garage", variables.attribute)) {
              variables.page.parking = "attached garage";
            } else if (FindNoCase("detached garage", variables.attribute)) {
              variables.page.parking = "detached garage";
            }
            
            if (FindNoCase("garage", variables.attribute) OR FindNoCase("parking", variables.attribute)) {
              if (NOT ArrayFindNoCase(variables.parkingOptions, variables.attribute)) {
                ArrayAppend(variables.parkingOptions, variables.attribute);
              }
            }
            
            // area
            if (FindNoCase("ft2", variables.attribute)) {
              variables.page.sqft = ReplaceNoCase(variables.attribute, "ft2", "");
            }
            
            // available
            variables.page.available = variables.dom.select(".property_date").attr("date");            
            
            if (NOT LEN(variables.page.available) AND FindNoCase("available", variables.attribute)) {
              variables.page.available = ReplaceNoCase(variables.attribute, "available", "");
            }
            
            // smoking
            if (FindNoCase("smoking", variables.attribute)) {
              if (NOT ArrayFindNoCase(variables.smokingOptions, variables.attribute)) {
                ArrayAppend(variables.smokingOptions, variables.attribute);
              }
            }
          }
          
          variables.insert["cats"] = variables.page.cats;
          variables.insert["dogs"] = variables.page.dogs;
          variables.insert["laundry"] = variables.page.laundry;
          variables.insert["parking"] = variables.page.parking;
          variables.insert["smoking"] = variables.page.smoking;
          variables.insert["sqft"] = variables.page.sqft;
          variables.insert["available"] = UCase(variables.page.available);
          variables.insert["type"] = variables.page.type;
          
          //dump(variables.page);
            
          /*
            // get reverse geocode data
            variables.page.geocode = REQUEST.utility.getReverseGeocode(latitude: variables.page.latitude, longitude: variables.page.longitude);
            
            REQUEST.utility.dump(variables.page.geocode.FileContent);
          */
          
          // get open houses
          variables.openhouses = variables.dom.select(".attrgroup .otherpostings a");
          
          variables.openHouseArray = ArrayNew(1);
          
          for (variables.openhouse in variables.openhouses) {
            ArrayAppend(variables.openHouseArray, variables.openHouse.text());
          }
          
          if (ArrayLen(variables.openhouseArray)) {
            variables.insert["openhouses"] = SerializeJSON(variables.openHouseArray);
          }
          
          // delete previous instance of same property
          variables.sql &= "DELETE FROM `demorati_external_properties` WHERE filter = 'CRAIG' AND external_id = " & variables.page.external_id & ";" & chr(10);
          variables.sql &= chr(10);
          
          // delete previous instances of similar property
          variables.sql &= "DELETE FROM `demorati_external_properties`" & chr(10);
          variables.sql &= "WHERE filter = '" & variables.insert["filter"] & "'" & chr(10);
          variables.sql &= "AND UPPER(title) = '" & UCase(Replace(variables.insert["title"], "'", "\'", "ALL")) & "'" & chr(10);
          variables.sql &= "AND UPPER(street) = '" & UCase(Replace(variables.insert["street"], "'", "\'", "ALL")) & "'" & chr(10);
          variables.sql &= "AND UPPER(city) = '" & UCase(Replace(variables.insert["city"], "'", "\'", "ALL")) & "'" & chr(10);
          variables.sql &= "AND UPPER(state) = '" & UCase(variables.insert["state"]) & "'" & chr(10);
          variables.sql &= "AND price = " & variables.insert["price"] & ";" & chr(10);
          variables.sql &= chr(10);
          
          variables.insertKeyList = StructKeyList(variables.insert);
          variables.insertColumnCount = ListLen(variables.insertKeyList);
          variables.insertIndex = 1;
          
          variables.sql &= "INSERT INTO `demorati_external_properties` (" & chr(10);
          variables.sql &= variables.insertKeyList & chr(10);
          variables.sql &= ") VALUES (" & chr(10);
          
          for (variables.insertKey in variables.insertKeyList) {
            variables.insertValue = Trim(variables.insert[variables.insertKey]);
            
            if (IsNumeric(variables.insertValue)) {
              variables.sql &= variables.insertValue;
            } else {
              variables.sql &= "'" & Replace(variables.insertValue, "'", "\'", "ALL") & "'";
            }
            
            if (variables.insertIndex LT variables.insertColumnCount) {
              variables.sql &= ",";
            }
            
            variables.sql &= chr(10);
          
            variables.insertIndex++;
          }
          
          variables.sql &= ");" & chr(10);
          variables.sql &= chr(10);
          
          WriteOutput("[" & variables.count & "]"); /* variables.page.external_id */
          REQUEST.utility.flushOutput();
          
          variables.count++;
          
          variables.isProcessed = true;
        }
      }
      
      if (NOT variables.isProcessed) {
        WriteOutput("[X]");
        REQUEST.utility.flushOutput();
      }
      
    }
  }
    
  if (LEN(variables.sql)) {
    variables.sqlFilename = REQUEST.sqlPath & DateFormat(variables.currentDate, "yyyymmdd") & "-" & TimeFormat(variables.currentDate, "HHnnss") & ".sql";
    
    FileWrite(variables.sqlFilename, variables.sql);
  }
</cfscript>

<!---
<h3>Parking Options</h3>
<cfdump var="#variables.parkingOptions#">

<h3>Smoking Options</h3>
<cfdump var="#variables.smokingOptions#">

<h3>Laundry Options</h3>
<cfdump var="#variables.laundryOptions#">

<h3>CSZ Options</h3>
<cfdump var="#variables.cszOptions#">
--->

<cfset variables.elapsedTime = ((GetTickCount() - variables.tickStart) / 1000) />

<p>Elapsed Time: <cfoutput>#variables.elapsedTime#</cfoutput> sec</p>

<p>Total: <cfoutput>#variables.count#</cfoutput> of <cfoutput>#variables.totalCount#</cfoutput></p>

<pre style="width:95%; height: 500px; border: 1px solid black; padding: 10px; overflow: scroll;"><cfoutput>#variables.sql#</cfoutput></pre>

</body>
</html>