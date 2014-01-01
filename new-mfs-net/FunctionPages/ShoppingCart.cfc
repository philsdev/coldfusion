<cfcomponent hint="ShoppingCart" extends="MachII.framework.Listener">

	<cfscript>
		This.ProductOptionPrefix = "ProductOption__";
		
		/* make sure cart exists in user's session */
		VerifyCart();
	</cfscript>
	
	<cffunction name="VerifyCart" access="public" output="no" returntype="void">
	
		<cfset var loc_HasCart = false />
		
		<cflock type="readonly" scope="session" timeout="10">
			<cfif StructKeyExists( SESSION, "cart" )>
				<cfset loc_HasCart = true />
			</cfif>
		</cflock>
		
		<cfif NOT loc_HasCart>
			<cfset InitializeCart() />
		</cfif>
	
	</cffunction>
	
	<cffunction name="InitializeCart" access="public" output="no" returntype="void">
		
		<!--- TODO: add promo code/discount --->
		
		<cflock type="exclusive" scope="session" timeout="10">
			<cfscript>
				/* cart */
				SESSION.Cart = StructNew();
				
				/* array of items in cart */
				SESSION.Cart.Items = ArrayNew(1);
				
				/* totals */
				SESSION.Cart.Totals = StructNew();	
				SESSION.Cart.Totals.ItemCount = 0;	
				SESSION.Cart.Totals.ItemTotal = 0;	
				SESSION.Cart.Totals.OrderTotal = 0;	
				
				/* shipping info  */
				SESSION.Cart.ShippingInfo = StructNew();	
				SESSION.Cart.ShippingInfo.FirstName = "";
				SESSION.Cart.ShippingInfo.LastName = "";
				SESSION.Cart.ShippingInfo.Email = "";
				SESSION.Cart.ShippingInfo.Address = "";
				SESSION.Cart.ShippingInfo.Address2 = "";
				SESSION.Cart.ShippingInfo.City = "";
				SESSION.Cart.ShippingInfo.State = "";
				SESSION.Cart.ShippingInfo.ZIPCode = "";
				SESSION.Cart.ShippingInfo.Country = "US";
				SESSION.Cart.ShippingInfo.Province = "";
				SESSION.Cart.ShippingInfo.PhoneNumber = "";
				SESSION.Cart.ShippingInfo.PhoneNumberExt = "";
				SESSION.Cart.ShippingInfo.PhoneNumberAlt = "";
				SESSION.Cart.ShippingInfo.PhoneNumberAltExt = "";
				SESSION.Cart.ShippingInfo.Company = "";
				
				/* billing info  */
				SESSION.Cart.BillingInfo = StructNew();	
				SESSION.Cart.BillingInfo.FirstName = "";
				SESSION.Cart.BillingInfo.LastName = "";
				SESSION.Cart.BillingInfo.Email = "";
				SESSION.Cart.BillingInfo.Address = "";
				SESSION.Cart.BillingInfo.Address2 = "";
				SESSION.Cart.BillingInfo.City = "";
				SESSION.Cart.BillingInfo.State = "";
				SESSION.Cart.BillingInfo.ZIPCode = "";
				SESSION.Cart.BillingInfo.Country = "US";
				SESSION.Cart.BillingInfo.Province = "";
				SESSION.Cart.BillingInfo.PhoneNumber = "";
				SESSION.Cart.BillingInfo.PhoneNumberExt = "";
				SESSION.Cart.BillingInfo.PhoneNumberAlt = "";
				SESSION.Cart.BillingInfo.PhoneNumberAltExt = "";
				SESSION.Cart.BillingInfo.Company = "";
			</cfscript>
		</cflock>
		
	</cffunction>
	
	<cffunction name="GetTotals" access="public" output="no" returntype="struct">
		
		<cfset var loc_Totals = StructNew() />
		
		<cflock type="readonly" scope="session" timeout="10">
			<cfif StructKeyExists(SESSION, "Cart") AND StructKeyExists(SESSION.Cart, "Totals")>
				<cfset loc_Totals = SESSION.Cart.Totals />
			</cfif>
		</cflock>
		
		<cfreturn loc_Totals />
	</cffunction>
	
	<cffunction name="GetShippingInfo" access="public" output="no" returntype="struct">
		
		<cfset var loc_ShippingInfo = StructNew() />
		
		<cflock type="readonly" scope="session" timeout="10">
			<cfif StructKeyExists(SESSION.Cart, "ShippingInfo")>
				<cfset loc_ShippingInfo = SESSION.Cart.ShippingInfo />
			</cfif>
		</cflock>
		
	<cfif SESSION.Cart.ShippingInfo.FirstName EQ "">
		<cfif IsDefined("SESSION.User")>
			<cfif StructKeyExists(SESSION.User, "UserID")>
				<cfif SESSION.User.UserType EQ "2">
				
					<!--- Get Corporate/Dealer shipping info --->
					<cfscript>
					variables.CorporateManager = Request.ListenerManager.GetListener( "CorporateManager" );
					variables.CorporateShipping = variables.CorporateManager.GetCorporateDetails(SESSION.User.UserID);
					
					/* shipping info  */
					//SESSION.Cart.ShippingInfo = StructNew();	
					SESSION.Cart.ShippingInfo.FirstName = variables.CorporateShipping.SHIPFIRSTNAME;
					SESSION.Cart.ShippingInfo.LastName = variables.CorporateShipping.SHIPLASTNAME;
					SESSION.Cart.ShippingInfo.Email = variables.CorporateShipping.EmailAddress;
					SESSION.Cart.ShippingInfo.Address = variables.CorporateShipping.SHIPADDRESS;
					SESSION.Cart.ShippingInfo.Address2 = variables.CorporateShipping.SHIPADDRESS2;
					SESSION.Cart.ShippingInfo.City = variables.CorporateShipping.SHIPCITY;
					SESSION.Cart.ShippingInfo.State = variables.CorporateShipping.SHIPSTATE;
					SESSION.Cart.ShippingInfo.ZIPCode = variables.CorporateShipping.SHIPZIPCODE;
					SESSION.Cart.ShippingInfo.Province = variables.CorporateShipping.SHIPProvince;
					SESSION.Cart.ShippingInfo.Country = variables.CorporateShipping.SHIPCOUNTRY;
					SESSION.Cart.ShippingInfo.PhoneNumber = variables.CorporateShipping.SHIPPHONENUMBER;
					SESSION.Cart.ShippingInfo.PhoneNumberExt = variables.CorporateShipping.SHIPPHONEEXT;
					SESSION.Cart.ShippingInfo.PhoneNumberAlt = variables.CorporateShipping.SHIPALTNUMBER;
					SESSION.Cart.ShippingInfo.PhoneNumberAltExt = variables.CorporateShipping.SHIPALTEXT;
					SESSION.Cart.ShippingInfo.Company = variables.CorporateShipping.Company;
					</cfscript>
					
				<cfelseif SESSION.User.UserType EQ "1">
					<!--- Get Customer/Account shipping info  --->
					<cfscript>
					variables.CustomerManager = Request.ListenerManager.GetListener( "CustomerManager" );
					variables.CustomerShipping = variables.CustomerManager.GetCustomerDetails(SESSION.User.UserID);
					
					/* shipping info  */
					//SESSION.Cart.ShippingInfo = StructNew();	
					SESSION.Cart.ShippingInfo.FirstName = variables.CustomerShipping.SHIPFIRSTNAME;
					SESSION.Cart.ShippingInfo.LastName = variables.CustomerShipping.SHIPLASTNAME;
					SESSION.Cart.ShippingInfo.Email = variables.CustomerShipping.EmailAddress;
					SESSION.Cart.ShippingInfo.Address = variables.CustomerShipping.SHIPADDRESS;
					SESSION.Cart.ShippingInfo.Address2 = variables.CustomerShipping.SHIPADDRESS2;
					SESSION.Cart.ShippingInfo.City = variables.CustomerShipping.SHIPCITY;
					SESSION.Cart.ShippingInfo.State = variables.CustomerShipping.SHIPSTATE;
					SESSION.Cart.ShippingInfo.ZIPCode = variables.CustomerShipping.SHIPZIPCODE;
					SESSION.Cart.ShippingInfo.Province = variables.CustomerShipping.SHIPProvince;
					SESSION.Cart.ShippingInfo.Country = variables.CustomerShipping.SHIPCOUNTRY;
					SESSION.Cart.ShippingInfo.PhoneNumber = variables.CustomerShipping.SHIPPHONENUMBER;
					SESSION.Cart.ShippingInfo.PhoneNumberExt = variables.CustomerShipping.SHIPPHONEEXT;
					SESSION.Cart.ShippingInfo.PhoneNumberAlt = variables.CustomerShipping.SHIPALTNUMBER;
					SESSION.Cart.ShippingInfo.PhoneNumberAltExt = variables.CustomerShipping.SHIPALTEXT;
					SESSION.Cart.ShippingInfo.Company = "";
					
					</cfscript>
					
				</cfif> 
				
			</cfif>
		</cfif>
	</cfif>
		
		<cfreturn loc_ShippingInfo />
	</cffunction>
	
	<cffunction name="GetBillingInfo" access="public" output="no" returntype="struct">
		
		<cfset var loc_BillingInfo = StructNew() />
		
		<cflock type="readonly" scope="session" timeout="10">
			<cfif StructKeyExists(SESSION.Cart, "BillingInfo")>
				<cfset loc_BillingInfo = SESSION.Cart.BillingInfo />
			</cfif>
		</cflock>
		
	<cfif SESSION.Cart.BillingInfo.FirstName EQ "">
		<cfif IsDefined("SESSION.User")>
			<cfif StructKeyExists(SESSION.User, "UserID")>
				<cfif SESSION.User.UserType EQ "2">
				
					<!--- Get Dealer shipping info --->
					<cfscript>
					variables.CorporateManager = Request.ListenerManager.GetListener( "CorporateManager" );
					variables.CorporateShipping = variables.CorporateManager.GetCorporateDetails(SESSION.User.UserID);
					
					/* shipping info  */
					//SESSION.Cart.ShippingInfo = StructNew();	
					SESSION.Cart.BillingInfo.FirstName = variables.CorporateShipping.BillFIRSTNAME;
					SESSION.Cart.BillingInfo.LastName = variables.CorporateShipping.BillLASTNAME;
					SESSION.Cart.BillingInfo.Email = variables.CorporateShipping.EmailAddress;
					SESSION.Cart.BillingInfo.Address = variables.CorporateShipping.BillADDRESS;
					SESSION.Cart.BillingInfo.Address2 = variables.CorporateShipping.BillADDRESS2;
					SESSION.Cart.BillingInfo.City = variables.CorporateShipping.BillCITY;
					SESSION.Cart.BillingInfo.State = variables.CorporateShipping.BillSTATE;
					SESSION.Cart.BillingInfo.ZIPCode = variables.CorporateShipping.BillZIPCODE;
					SESSION.Cart.BillingInfo.Province = variables.CorporateShipping.SHIPProvince;
					SESSION.Cart.BillingInfo.Country = variables.CorporateShipping.BillCOUNTRY;
					SESSION.Cart.BillingInfo.PhoneNumber = variables.CorporateShipping.BillPHONENUMBER;
					SESSION.Cart.BillingInfo.PhoneNumberExt = variables.CorporateShipping.BillPHONEEXT;
					SESSION.Cart.BillingInfo.PhoneNumberAlt = variables.CorporateShipping.BillALTNUMBER;
					SESSION.Cart.BillingInfo.PhoneNumberAltExt = variables.CorporateShipping.BillALTEXT;
					SESSION.Cart.BillingInfo.Company = variables.CorporateShipping.Company;
					</cfscript>
					
				<cfelseif SESSION.User.UserType EQ "1">
					<!--- Get Account shipping info  --->
					<cfscript>
					variables.CustomerManager = Request.ListenerManager.GetListener( "CustomerManager" );
					variables.CustomerShipping = variables.CustomerManager.GetCustomerDetails(SESSION.User.UserID);
					
					/* shipping info  */
					//SESSION.Cart.ShippingInfo = StructNew();	
					SESSION.Cart.BillingInfo.FirstName = variables.CustomerShipping.BillFIRSTNAME;
					SESSION.Cart.BillingInfo.LastName = variables.CustomerShipping.BillLASTNAME;
					SESSION.Cart.BillingInfo.Email = variables.CustomerShipping.EmailAddress;
					SESSION.Cart.BillingInfo.Address = variables.CustomerShipping.BillADDRESS;
					SESSION.Cart.BillingInfo.Address2 = variables.CustomerShipping.BillADDRESS2;
					SESSION.Cart.BillingInfo.City = variables.CustomerShipping.BillCITY;
					SESSION.Cart.BillingInfo.State = variables.CustomerShipping.BillSTATE;
					SESSION.Cart.BillingInfo.ZIPCode = variables.CustomerShipping.BillZIPCODE;
					SESSION.Cart.BillingInfo.Province = variables.CustomerShipping.SHIPProvince;
					SESSION.Cart.BillingInfo.Country = variables.CustomerShipping.BillCOUNTRY;
					SESSION.Cart.BillingInfo.PhoneNumber = variables.CustomerShipping.BillPHONENUMBER;
					SESSION.Cart.BillingInfo.PhoneNumberExt = variables.CustomerShipping.BillPHONEEXT;
					SESSION.Cart.BillingInfo.PhoneNumberAlt = variables.CustomerShipping.BillALTNUMBER;
					SESSION.Cart.BillingInfo.PhoneNumberAltExt = variables.CustomerShipping.BillALTEXT;
					SESSION.Cart.BillingInfo.Company = "";
					
					</cfscript>
					
				</cfif> 
			</cfif>
		</cfif>
	</cfif>
			
		<cfreturn loc_BillingInfo />
	</cffunction>
	
	<cffunction name="GetItemCount" access="public" output="no" returntype="numeric">
		<cfset var loc_ItemCount = 0 />
				
		<cflock type="readonly" scope="session" timeout="10">
			<cfif StructKeyExists(SESSION, "Cart") AND StructKeyExists(SESSION.Cart, "Totals")>
				<cfset loc_ItemCount = SESSION.Cart.Totals.ItemCount />
			</cfif>
		</cflock>
		
		<cfreturn loc_ItemCount />
	</cffunction>
	
	<cffunction name="GetItems" access="public" output="no" returntype="array">	
		<cfset var loc_Items = "" />
	
		<cflock type="exclusive" scope="session" timeout="10">
			<cfif NOT StructKeyExists(SESSION.Cart, "Items")>
				<cfset SESSION.Cart.Items = ArrayNew(1) />
			</cfif>
			
			<cfset loc_Items = SESSION.Cart.Items />
		</cflock>
		
		<cfreturn loc_Items />
	</cffunction>
	
	<cffunction name="AddItem" access="public" output="no" returntype="void">
		<cfargument name="ProductID" type="numeric" required="yes" />
		<cfargument name="ProductQuantity" type="numeric" required="yes" />
		
		<cfset var loc_ProductID = Arguments.ProductID />
		<cfset var loc_ProductDetails = "" />
		<cfset var loc_ThisAttribute = "" />
		<cfset var loc_ThisItem = "" />
		<cfset var loc_ThisLineNumber = 0 />
		<cfset var loc_ThisLineText = "" />
		<cfset var loc_ThisLineLength = 0 />
		<cfset var loc_ThisLineOverage = 0 />
		<cfset var loc_ThisLineSurcharge = 0 />
		<cfset var loc_ThisItemSurcharge = 0 />
		<cfset var loc_PersonalizationBaseCharge = 0 />
		<cfset var loc_PersonalizationSurcharge = 0 />
		<cfset var loc_SelectedOptionList = "0" />
		<cfset var loc_NewProductPrice = 0 />
		<cfset var loc_NewProductPriceIncrease = 0 />
		<cfset var loc_FormFields = StructCopy( Arguments ) />
		<cfset var loc_FormFieldList = StructKeyList(loc_FormFields) />
		<cfset var loc_ItemStruct = StructNew() />
		<cfset var loc_OptionsStruct = "" />
		<cfset var loc_LinkManager = Request.ListenerManager.GetListener( "LinkManager" ) />
		<cfset var loc_ProductImageManager = Request.ListenerManager.GetListener( "ProductImageManager" ) />
		
		<!---
			<cfdump var="#loc_FormFieldList#">
			<cfabort>
		--->
		
		<cfloop list="#loc_FormFieldList#" index="loc_ThisAttribute">
			<cfif LEFT( loc_ThisAttribute, LEN(This.ProductOptionPrefix) ) EQ This.ProductOptionPrefix AND IsNumeric(loc_FormFields[loc_ThisAttribute])>
				<cfset loc_SelectedOptionList = ListAppend( loc_SelectedOptionList, loc_FormFields[loc_ThisAttribute] ) />
			</cfif>
		</cfloop>
		
		<cfquery datasource="#request.dsource#" name="loc_ProductDetails">
			SELECT			P.ProductID,
							P.ProductName,
							P.ProductItemNumber,
							CASE
								WHEN P.ProductDiscountPrice > 0 THEN P.ProductDiscountPrice
								ELSE P.ProductOurPrice
							END AS ProductPrice,
							POA.Price AS OptionPrice,
							POA.AddPrice AS OptionAddPrice,
							POA.OptionID,
							PO.OptionName,
							PO.GroupID,
							PA.ProductAttributeName,
							PI.ImageName
							
			FROM			Products P
			
			LEFT JOIN		ProductOptionsAssoc POA 
			ON				P.ProductID = POA.ProductID
			AND				POA.OptionID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#loc_SelectedOptionList#" list="true" />)
			
			LEFT JOIN  		ProductOptions PO ON POA.OptionID = PO.OptionID
			LEFT JOIN   	ProductAttributes PA ON PO.GroupID = PA.ProductAttributeID
			LEFT JOIN		ProductImages PI ON P.ProductID = PI.ProductID AND PI.ImageTypeID = 1
			
			WHERE			P.ProductID = <cfqueryparam cfsqltype="cf_sql_integer" value="#loc_ProductID#" />
			
			ORDER BY		GroupID,
							OptionPrice,
							OptionAddPrice,
							OptionID
		</cfquery>
		
		<!---
			<cfdump var="#loc_ProductDetails#">
			<cfabort>
		--->
		
		<cfif NOT loc_ProductDetails.Recordcount>
			<cfthrow message="Product could not be found!" />
		</cfif>
	
		<cflock type="exclusive" scope="session" timeout="10">
			
			<cfif NOT StructKeyExists(SESSION.Cart, "Items")>
				<cfset SESSION.Cart.Items = ArrayNew(1) />
			</cfif>
			
			<!--- remove item from cart if it exists already --->
			<cfset RemoveItem( ProductID:loc_ProductID ) />
			
			<!--- set product-level values --->
			<cfset loc_ItemStruct.ProductID = loc_ProductDetails.ProductID />
			<cfset loc_ItemStruct.ProductName = loc_LinkManager.GetDisplayName( loc_ProductDetails.ProductName ) />	
			<cfset loc_ItemStruct.ProductLink = loc_LinkManager.GetProductLink( ProductID:loc_ProductDetails.ProductID, ProductTitle:loc_ProductDetails.ProductName ) />			
			<cfset loc_ItemStruct.ProductImage = loc_ProductImageManager.GetProductImageUrl( FileName:loc_ProductDetails.ImageName, ImageType:"list" ) />
			<cfset loc_ItemStruct.ProductPrice = loc_ProductDetails.ProductPrice />			
			<cfset loc_ItemStruct.ProductQuantity = Arguments.ProductQuantity />			
			<cfset loc_ItemStruct.ProductOptions = ArrayNew(1) />
			
			<!--- set personalization --->
			<cfset loc_ItemStruct.ProductPersonalization.Options = StructNew() />
			
			<cfloop collection="#REQUEST.Personalization#" item="loc_ThisItem">
				<cfif StructKeyExists( ARGUMENTS, loc_ThisItem )>
					<cfset loc_ItemStruct.ProductPersonalization.Options[loc_ThisItem] = StructNew() />
					<cfset loc_ItemStruct.ProductPersonalization.Options[loc_ThisItem].Font = ARGUMENTS[loc_ThisItem & "__font"] />
					<cfset loc_ItemStruct.ProductPersonalization.Options[loc_ThisItem].Lines = ArrayNew(1) />
					
					<cfset loc_PersonalizationBaseCharge = loc_PersonalizationBaseCharge + REQUEST.Personalization[loc_ThisItem].BaseCharge />
					
					<cfloop from="1" to="#REQUEST.Personalization[loc_ThisItem].Lines#" index="loc_ThisLineNumber">
						<cfset loc_ThisLineText = ARGUMENTS[loc_ThisItem & "__" & loc_ThisLineNumber] />
						<cfset ArrayAppend( loc_ItemStruct.ProductPersonalization.Options[loc_ThisItem].Lines, loc_ThisLineText ) />
												
						<!--- determine length of current line --->
						<cfset loc_ThisLineLength = LEN( loc_ThisLineText ) />
						
						<!--- determine surcharge for current line, if it's over line max --->
						<cfif loc_ThisLineLength GT REQUEST.Personalization[loc_ThisItem].CharacterLineMax>
							<cfset loc_ThisLineOverage = loc_ThisLineLength - REQUEST.Personalization[loc_ThisItem].CharacterLineMax />
							<cfset loc_ThisLineSurcharge = loc_ThisLineOverage * REQUEST.Personalization.GoldStamp.CharacterSurcharge />
							<cfset loc_ThisItemSurcharge = loc_ThisItemSurcharge + loc_ThisLineSurcharge />
						</cfif>
						
					</cfloop>
					
					<cfset loc_PersonalizationSurcharge = loc_PersonalizationSurcharge + loc_ThisItemSurcharge />
					
				</cfif>
			</cfloop>
			
			<cfset loc_ItemStruct.ProductPersonalization.BaseCharge = loc_PersonalizationBaseCharge />
			<cfset loc_ItemStruct.ProductPersonalization.Surcharge = loc_PersonalizationSurcharge />
			<cfset loc_ItemStruct.ProductPersonalization.TotalCharge = loc_PersonalizationBaseCharge + loc_PersonalizationSurcharge />
			
			<!--- configure options --->
			<cfloop query="loc_ProductDetails">
			
				<!--- products w/o options will have one row with null option values --->
				<cfif IsNumeric( OptionID )>
					<cfset loc_OptionsStruct = StructNew() />
					<cfset loc_OptionsStruct.AttributeID = GroupID />
					<cfset loc_OptionsStruct.AttributeName = loc_LinkManager.GetDisplayName( ProductAttributeName ) />
					<cfset loc_OptionsStruct.OptionID = OptionID />
					<cfset loc_OptionsStruct.OptionName = loc_LinkManager.GetDisplayName( OptionName ) />
					
					<!--- configure options that set new base price --->
					<cfset loc_OptionsStruct.OptionPrice = OptionPrice />
					<cfif loc_OptionsStruct.OptionPrice GT 0>
						<cfset loc_NewProductPrice = loc_OptionsStruct.OptionPrice />
					</cfif>
					
					<!--- configure options that increase price --->
					<cfset loc_OptionsStruct.OptionAddPrice = OptionAddPrice />
					<cfif loc_OptionsStruct.OptionAddPrice GT 0>
						<cfset loc_NewProductPriceIncrease = loc_NewProductPriceIncrease + loc_OptionsStruct.OptionAddPrice />
					</cfif>
					
					<cfset ArrayAppend( loc_ItemStruct.ProductOptions, loc_OptionsStruct ) />
				</cfif>
			</cfloop>
			
			<cfif loc_NewProductPrice GT 0>
				<cfset loc_ItemStruct.ProductPrice = loc_NewProductPrice />
			</cfif>
			
			<cfif loc_NewProductPriceIncrease GT 0>
				<cfset loc_ItemStruct.ProductPrice = loc_ItemStruct.ProductPrice + loc_NewProductPriceIncrease />
			</cfif>
			
			<!--- add personalization pricing --->
			<cfif loc_ItemStruct.ProductPersonalization.TotalCharge GT 0>
				<cfset loc_ItemStruct.ProductPrice = loc_ItemStruct.ProductPrice + loc_ItemStruct.ProductPersonalization.TotalCharge />
			</cfif>
			
			<cfset loc_ItemStruct.ProductSubtotal = loc_ItemStruct.ProductPrice * loc_ItemStruct.ProductQuantity />
			
			<cfset ArrayAppend( SESSION.Cart.Items, loc_ItemStruct ) />
			
		</cflock>
		
	</cffunction>
	
	<cffunction name="UpdateItemQuantity" access="public" output="no" returntype="void">
		<cfargument name="ProductID" type="numeric" required="yes" />
		<cfargument name="Quantity" type="numeric" required="yes" />
		
		<cfset var loc_ProductID = Arguments.ProductID />
		<cfset var loc_Quantity = Arguments.Quantity />
		<cfset var loc_ItemIndex = "" />
		
		<cflock type="exclusive" scope="session" timeout="10">
			
			<cfif NOT StructKeyExists(SESSION.Cart, "Items")>
				<cfset SESSION.Cart.Items = ArrayNew(1) />
			</cfif>
			
			<cfloop from="#ArrayLen(SESSION.Cart.Items)#" to="1" step="-1" index="loc_ItemIndex">
				<cfif SESSION.Cart.Items[loc_ItemIndex].ProductID EQ loc_ProductID>
					<cfif loc_Quantity EQ 0>
						<cfset RemoveItem( ProductID:loc_ProductID ) />
					<cfelse>
						<cfset SESSION.Cart.Items[loc_ItemIndex].ProductQuantity = loc_Quantity />
						<cfset SESSION.Cart.Items[loc_ItemIndex].ProductSubTotal = loc_Quantity * SESSION.Cart.Items[loc_ItemIndex].ProductPrice />
					</cfif>
				</cfif>
			</cfloop>
			
		</cflock>
		
	</cffunction>
	
	<cffunction name="RemoveItem" access="public" output="no" returntype="void">
		<cfargument name="ProductID" type="numeric" required="yes" />
	
		<cfset var loc_ProductID = Arguments.ProductID />
		<cfset var loc_ItemIndex = "" />		
	
		<cflock type="exclusive" scope="session" timeout="10">
			
			<cfif NOT StructKeyExists(SESSION.Cart, "Items")>
				<cfset SESSION.Cart.Items = ArrayNew(1) />
			</cfif>
			
			<cfloop from="#ArrayLen(SESSION.Cart.Items)#" to="1" step="-1" index="loc_ItemIndex">
				<cfif SESSION.Cart.Items[loc_ItemIndex].ProductID EQ loc_ProductID>
					<cfset ArrayDeleteAt( SESSION.Cart.Items, loc_ItemIndex ) />
				</cfif>
			</cfloop>
			
		</cflock>
		
	</cffunction>

	<cffunction name="RefreshCartTotals" access="public" output="no" returntype="void">
	
		<cfset var loc_ItemIndex = "" />
		<cfset var loc_ItemCount = 0 />
		<cfset var loc_ItemTotal = 0 />
		<cfset var loc_OrderTotal = 0 />
	
		<cflock type="exclusive" scope="session" timeout="10">
		
			<cfif StructKeyExists( SESSION.Cart, "Items" )>
				<cfset loc_ItemCount = ArrayLen(SESSION.Cart.Items) />
				
				<cfloop from="1" to="#loc_ItemCount#" index="loc_ItemIndex">
					<cfset loc_ItemTotal = loc_ItemTotal + SESSION.Cart.Items[loc_ItemIndex].ProductSubTotal />
				</cfloop>
			</cfif>
			
			<cfif NOT StructKeyExists( SESSION.Cart, "Totals" )>
				<cfset SESSION.Cart.Totals = StructNew() />
			</cfif>
			
			<cfset SESSION.Cart.Totals.ItemCount = loc_ItemCount />
			<cfset SESSION.Cart.Totals.ItemTotal = loc_ItemTotal />
						
			<!--- TODO: factor in promo code amount --->
			
			<cfset SESSION.Cart.Totals.OrderTotal = loc_ItemTotal />
			
		</cflock>
	
	</cffunction>	
	
	<cffunction name="UpdateInfo" access="public" output="no" returntype="void">
		<cfargument name="ShipFirstName" type="string" required="yes" />
		<cfargument name="ShipLastName" type="string" required="yes" />
		<cfargument name="ShipEmail" type="string" required="yes" />
		<cfargument name="ShipAddress" type="string" required="yes" />
		<cfargument name="ShipAddress2" type="string" required="no" default=""  />
		<cfargument name="ShipCity" type="string" required="yes" />
		<cfargument name="ShipState" type="string" required="no" default=""  />
		<cfargument name="ShipProvince" type="string" required="no" default=""  />
		<cfargument name="ShipZipCode" type="string" required="yes" />
		<cfargument name="ShipCountry" type="string" required="yes" />
		<cfargument name="ShipPhoneNumber" type="string" required="yes" />
		<cfargument name="ShipPhoneNumberExt" default="" />
		<cfargument name="ShipPhoneNumberAlt" default=""  />
		<cfargument name="ShipPhoneNumberAltExt" default="" />
		<cfargument name="ShipCompany" default="" />

		<cfargument name="BillFirstName" type="string" required="yes" />
		<cfargument name="BillLastName" type="string" required="yes" />
		<cfargument name="BillEmail" type="string" required="yes" />
		<cfargument name="BillAddress" type="string" required="yes" />
		<cfargument name="BillAddress2" type="string" required="no" default=""  />
		<cfargument name="BillCity" type="string" required="yes" />
		<cfargument name="BillState" type="string" required="no" default=""  />
		<cfargument name="BillProvince" type="string" required="no" default=""  />
		<cfargument name="BillZipCode" type="string" required="yes" />
		<cfargument name="BillCountry" type="string" required="yes" />
		<cfargument name="BillPhoneNumber" type="string" required="yes" />
		<cfargument name="BillPhoneNumberExt" default=""  />
		<cfargument name="BillPhoneNumberAlt" default="" />
		<cfargument name="BillPhoneNumberAltExt" default="" />
		<cfargument name="BillCompany" default="" />
	
		<cflock type="exclusive" scope="session" timeout="10">
			<cfscript>
				SESSION.Cart.ShippingInfo.FirstName = Arguments.ShipFirstName;
				SESSION.Cart.ShippingInfo.LastName = Arguments.ShipLastName;
				SESSION.Cart.ShippingInfo.Email = Arguments.ShipEmail;
				SESSION.Cart.ShippingInfo.Address = Arguments.ShipAddress;
				SESSION.Cart.ShippingInfo.Address2 = Arguments.ShipAddress2;
				SESSION.Cart.ShippingInfo.City = Arguments.ShipCity;
				SESSION.Cart.ShippingInfo.State = Arguments.ShipState;
				SESSION.Cart.ShippingInfo.ZipCode = Arguments.ShipZipCode;
				SESSION.Cart.ShippingInfo.Province = Arguments.ShipProvince;
				SESSION.Cart.ShippingInfo.Country = Arguments.ShipCountry;
				SESSION.Cart.ShippingInfo.PhoneNumber = Arguments.ShipPhoneNumber;
				SESSION.Cart.ShippingInfo.PhoneNumberExt = Arguments.ShipPhoneNumberExt;
				SESSION.Cart.ShippingInfo.PhoneNumberAlt = Arguments.ShipPhoneNumberAlt;
				SESSION.Cart.ShippingInfo.PhoneNumberAltExt = Arguments.ShipPhoneNumberAltExt;
				SESSION.Cart.ShippingInfo.Company = Arguments.ShipCompany;
				
				SESSION.Cart.BillingInfo.FirstName = Arguments.BillFirstName;
				SESSION.Cart.BillingInfo.LastName = Arguments.BillLastName;
				SESSION.Cart.BillingInfo.Email = Arguments.BillEmail;
				SESSION.Cart.BillingInfo.Address = Arguments.BillAddress;
				SESSION.Cart.BillingInfo.Address2 = Arguments.BillAddress2;
				SESSION.Cart.BillingInfo.City = Arguments.BillCity;
				SESSION.Cart.BillingInfo.State = Arguments.BillState;
				SESSION.Cart.BillingInfo.ZipCode = Arguments.BillZipCode;
				SESSION.Cart.BillingInfo.Province = Arguments.BillProvince;
				SESSION.Cart.BillingInfo.Country = Arguments.BillCountry;
				SESSION.Cart.BillingInfo.PhoneNumber = Arguments.BillPhoneNumber;
				SESSION.Cart.BillingInfo.PhoneNumberExt = Arguments.BillPhoneNumberExt;
				SESSION.Cart.BillingInfo.PhoneNumberAlt = Arguments.BillPhoneNumberAlt;
				SESSION.Cart.BillingInfo.PhoneNumberAltExt = Arguments.BillPhoneNumberAltExt;
				SESSION.Cart.BillingInfo.Company = Arguments.BillCompany;
			</cfscript>
		</cflock>	
	
	</cffunction>
	
</cfcomponent>