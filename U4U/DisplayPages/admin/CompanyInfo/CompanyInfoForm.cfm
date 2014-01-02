<script type="text/javascript" src="/javascript/companyinfo.js"></script>
<cfoutput>
<cfsilent>
	<cfquery datasource="#request.dsource#" name="CompInfo">
		SELECT PhoneNum, TollFreeNum, FaxNum, SiteTitle, SiteSubTitle, EmailAddress, Address1, Address2, City, State, ZipCode, Country
		FROM AMP_CompanyInfo
		WHERE CompInfoID = 1
	</cfquery>
	<cfquery name="getstates" datasource="#request.dsource#">
		SELECT ISO
		FROM AMP_States
		ORDER BY Name
	</cfquery>
</cfsilent>

<cfif isdefined("URL.Message") AND  URL.Message EQ "Edit">
  <p class="Message" align="CENTER">The company information has been updated.</p>
</cfif>

<div class="TabbedPanels" id="TabbedPanels1">
    <cfinclude template="inc_MainNavigation.cfm" />
    <div class="TabbedPanelsContentGroup">
    	<div class="TabbedPanelsContent">    
            <h3 style="padding-left:10px; margin-bottom:0px; padding-bottom:0;">Editing Company Information</h3>
            <div id="editCareerForm" class="formContainer">
               <form action="index.cfm?event=EditCompInfoSubmit" method="post" name="CompInfoForm" id="CompInfoForm">
                	<input type="hidden" name="CompInfoID" value="1" />    
                    <div class="inputForm">
                        <ul class="form">                      	                                                    
                            <li>
                                <label>Location Title:</label>
                                <input class="textinput" type="text" name="SiteTitle" id="SiteTitle" value="#trim(CompInfo.SiteTitle)#" maxlength="500" />
                            </li>
                            <li>
                                <label>Location Sub Title:</label>
                                <input class="textinput" type="text" name="SiteSubTitle" value="#trim(CompInfo.SiteSubTitle)#" maxlength="500" />
                            </li>
                            <li>
                                <label>Phone Number:</label>
                                <input class="textinput" type="text" name="PhoneNum" value="#trim(CompInfo.PhoneNum)#" maxlength="25" />
                            </li> 
                            <li>
                                <label>Fax Number:</label>
                                <input class="textinput" type="text" name="FaxNum" value="#trim(CompInfo.FaxNum)#" maxlength="25" />
                            </li> 
                            <li>
                                <label>Toll Free Number:</label>
                                <input class="textinput" type="text" name="TollFreeNum" value="#trim(CompInfo.TollFreeNum)#" maxlength="25" />
                            </li>
                            <li>
                                <label>Email Address:</label>
                                <input class="textinput" type="text" name="EmailAddress" value="#trim(CompInfo.EmailAddress)#" maxlength="255" />
                            </li>  
                            <li>
                                <label>Street Address:</label>
                                <input class="textinput" type="text" name="Address1" id="Address1" value="#trim(CompInfo.Address1)#" maxlength="50" />
                            </li> 
                            <li>
                                <label>Address 2:</label>
                                <input class="textinput" type="text" name="Address2" value="#trim(CompInfo.Address2)#" maxlength="50" /> 
                            </li>  
                             <li>
                                <label>City:</label>
                                <input class="textinput" type="text" name="City" id="City" value="#trim(CompInfo.City)#" maxlength="50" />
                            </li>
                             <li>
                                <label>State:</label>
                                <select name="State">
                                    <option value="">- Select State -</option>
                                    <cfloop query="getstates">
                                        <option value="#trim(ISO)#" <CFIF #trim(CompInfo.State)# IS #trim(ISO)#>selected</CFIF>>#trim(ISO)#</option>
                                    </cfloop>
                                </select>
                            </li>
                             <li>
                                <label>Postal Code:</label>
                                <input class="textinput" type="text" name="ZipCode" id="ZipCode" value="#trim(CompInfo.ZipCode)#" maxlength="50" />
                            </li>
                             <li>
                                <label>Country:</label>
                                <input class="textinput" type="text" name="Country" value="#trim(CompInfo.Country)#" maxlength="50" /> 
                            </li> 
                        </ul>                                               
                    </UL>                        
                     <div class="submitButtonContainer">
                        	<input type="Submit" class="Button" name="SaveAndKeep" value="Save and Keep Editing" />
                            <input type="Submit" class="Button" name="SaveAndExit" value="Save and Return to Administrator List" />
                    	</div>                        
               	 	</div>
              </form>
           </div>        
      </div>
    </div>
</div>
</cfoutput>