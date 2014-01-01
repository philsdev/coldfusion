<cfscript>
	variables.LinkManager = Request.ListenerManager.GetListener( "LinkManager" );
</cfscript>
<!------------------------------------------------------------------------------------------

	CustomerInfo.cfm
	my-account.html

------------------------------------------------------------------------------------------->

<cfparam name="request.RegistryItems.recordcount" default="0">



<div id="breadcrumb">
	<a href="/" title="">Home</a>
	<span><a href="/my-account.html" title="">
	<cfif SESSION.User.UserType eq 1>
		Customer Account
	<cfelseif SESSION.User.UserType eq 2>
		Corporate Account
	</cfif></a>
	<a href="/view-registry.html" title="">Gift Registry</a>
	</span>
</div>
	
<!-- contentContainer nessesary for liquid layouts with static and percentage columns -->
<aside id="sidebar">
	<div class="sideModule navModule module">
			<h3>My Account</h3>
			<div class="moduleContent">
				<ul class="leftNav">
				    <li><a href="" title="">Account Homepage</a></li>
					<li><a href="" title="">Order History</a></li>
                    <li><a href="" title="">Track Orders</a></li>
					<li><a href="" title="">Edit Account Information</a></li>
					<li><a href="" title="" class="active">Gift Registry</a></li>
                    <li><a href="" title="">Log out</a></li>
				</ul>
			</div>
	</div>
                        
	<div class="sideModule navModule module">
			<h3>More Information</h3>
			<div class="moduleContent">
				<ul class="leftNav">
					<li><a href="" title="">About Us</a></li>
					<li><a href="" title="">Contact Us</a></li>
					<li><a href="" title="">Testimonials</a></li>
					<li><a href="" title="">Resources</a></li>
					<li><a href="" title="">Blog</a>
					<li><a href="" title="">Customer Service</a></li>
					<li><a href="" title="">Return Policy</a></li>
					<li><a href="" title="">How to Order</a></li>
					<li><a href="" title="">Shipping and Handling</a></li>
					<li><a href="" title="">Sitemap</a></li>
					<li><a href="" title="">Privacy</a></li>
					<li><a href="" title="">Security </a></li>
				</ul>
			</div>
	</div> 
</aside>

<div id="contentContainer">
	<div id="content" class="contentSection">
	<cfif IsDefined("SESSION.User.LoggedIN") and SESSION.User.LoggedIN eq 1>
	<div class="post">
      <article class="entry-content ">
        <header class="articleHeader">
          <h1>Registry Name</h1>
        </header>
        <div class="module registryModule">
		<cfoutput>
        <dl class="smaller">
          <dd><strong>Event Type:</strong> #request.RegistryDetails.registry_type_code#</dd>
          <dd><strong>Event Date:</strong> #dateformat(request.RegistryDetails.event_date,"long")#</dd>
          <dd><strong>Registry Code: </strong> #request.RegistryDetails.registry_code#</dd>
          <dd><strong>Creator's Name:</strong> #request.RegistryDetails.BillFirstname# #request.RegistryDetails.BillLastName#</dd>
          <dd><strong>Direct Link:</strong> http://matthewfsheehan.amp.com/index.cfm?event=registryView&amp;registry_code=#request.RegistryDetails.registry_code# </dd>
        </dl>
		</cfoutput>
        </div>
        <h2>Wish List</h2>
        <p>Browse our catalog to add more items to your registry.</p>
		<cfoutput query="request.RegistryItems" group="Registry_Item_ID">
		<cfset ProductLink = variables.LinkManager.GetProductLink( ProductID:ProductID, ProductTitle:ProductName ) />	
        <form name="wishlist" id="wishlist" action="?event=registryAdd2Cart" method="post" onsubmit="return _CF_checkwishlist(this)">
          <table width="100%" border="0" cellspacing="0" cellpadding="2" class="itemsTable wishList">
            <tbody>
              <tr>
                <td><cfif ImageName NEQ "">
					<!--- <a href="#ProductLink#&amp;Registry_Item_ID=#Registry_Item_ID#"><img src="/images/products/fe_#ImageName#" border="0" title="#ProductName#" style=" display:inline; float:none; margin:0; padding:0;"></a> --->
					<a href="#ProductLink#"><img src="/images/products/fe_#ImageName#" border="0" title="#ProductName#" style=" display:inline; float:none; margin:0; padding:0;"></a>
					</cfif>
				</td>
                <td valign="top" style="vertical-align:top"><h4><a href="#ProductLink#">#ProductName# ?Registry_Item_ID=#Registry_Item_ID#</a></h4>
                  <table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <thead>
                      <tr>
                        <th class="itemCol">Item Info:</th>
                        <th class="wantCol"><strong>Want:</strong></th>
                        <th class="haveCol"><strong>Have:</strong></th>
                        <th class="priceCol"><strong>Price:</strong></th>
                        <th class="qtyCol"><strong>Quantity:</strong></th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr>
                        <td valign="top"><ul class="itemInfoList">
                            <li> <strong>No:</strong> #request.RegistryItems.productid# </li>
							<cfif ProductAttributeName NEQ "">
                            <li><strong>Options:</strong><br>
							<cfoutput group="ProductAttributeName">
							  #ProductAttributeName#: #OptionName# <br>
                              <input type="hidden" name="#Registry_Item_ID#_OPTIONID" value="11">
                              <input type="hidden" name="#Registry_Item_ID#_OPTION_1" value="Sterling Silver">
							</cfoutput>
                            </li>
							 </cfif>
                          </ul></td>
                        <td><input name="#Registry_Item_ID#_WANT" type="text" value="#qty_want#" size="2" id="#Registry_Item_ID#_WANT">
                          <input name="#Registry_Item_ID#_HAVE" type="hidden" value="#qty_have#" size="2" id="#Registry_Item_ID#_HAVE">
                        </td>
                        <td>#qty_have#</td>
                        <td>#dollarformat(ProductOurPrice)#</td>
                        <td><input name="#Registry_Item_ID#_QUANTITY" type="text" size="2" id="#Registry_Item_ID#_QUANTITY">
                        </td>
                      </tr>
                    </tbody>
                  </table></td>
                <td valign="middle" style="padding:10px;"><a href="?event=registryItemDelete&amp;Registry_Item_ID=25&amp;registry_id=10" title="Delete Item"><img src="http://matthewfsheehan.amp.com/images/btn-delete.png" alt="delete item" style="border:0"></a>
                  <input type="hidden" value="10" name="#Registry_Item_ID#_REGISTRY_ID">
                  <input type="hidden" value="" name="#Registry_Item_ID#_ENGRAVELINE1">
                  <input type="hidden" value="bring_750.jpg" name="#Registry_Item_ID#_IMAGE">
                  <input type="hidden" value="3" name="#Registry_Item_ID#_ATTRIBUTECOUNT">
                  <input type="hidden" value="1" name="#Registry_Item_ID#_CURRIMAGEVIEWCOUNTER">
                  <input type="hidden" value="" name="#Registry_Item_ID#_ENGRAVEFONT">
                  <input type="hidden" value="" name="#Registry_Item_ID#_ENGRAVELINE1">
                  <input type="hidden" value="" name="#Registry_Item_ID#_ENGRAVELINE2">
                  <input type="hidden" value="" name="#Registry_Item_ID#_ENGRAVELINE3">
                  <input type="hidden" value="" name="#Registry_Item_ID#_GOLDSTAMPFONT">
                  <input type="hidden" value="" name="#Registry_Item_ID#_GOLDSTAMPLINE1">
                  <input type="hidden" value="" name="#Registry_Item_ID#_GOLDSTAMPLINE2">
                  <input type="hidden" value="" name="#Registry_Item_ID#_ITEMNUM">
                  <input type="hidden" value="" name="#Registry_Item_ID#_MEMORIALFONT">
                  <input type="hidden" value="" name="#Registry_Item_ID#_MEMORIALLINE1">
                  <input type="hidden" value="" name="#Registry_Item_ID#_MEMORIALLINE2">
                  <input type="hidden" value="0" name="#Registry_Item_ID#_PRODUCTDISCOUNTPRICE">
                  <input type="hidden" value="1395" name="#Registry_Item_ID#_PRODUCTID">
                  <input type="hidden" value="750" name="#Registry_Item_ID#_PRODUCTITEMNUMBER">
                  <input type="hidden" value="0" name="#Registry_Item_ID#_PRODUCTLISTPRICE">
                  <input type="hidden" value="European Designed Bishop*s Ring" name="#Registry_Item_ID#_PRODUCTNAME">
                  <input type="hidden" value="875" name="#Registry_Item_ID#_PRODUCTOURPRICE">
                  <input type="hidden" value="875" name="#Registry_Item_ID#_PURCHASEPRICE">
                  <input type="hidden" value="25" name="#Registry_Item_ID#_REGISTRY_ITEM_ID">
                  <input type="hidden" value="0" name="#Registry_Item_ID#_ProductWeight">
                  <input type="hidden" value="" name="#Registry_Item_ID#_UPDATEITEM">
                </td>
              </tr>
			  </tbody>
          </table>
          <div style="text-align:center;">
            <input type="submit" name="ADD2LIST" value="Update Wants" class="button">
            &nbsp;&nbsp;&nbsp;
			<!--- <a class="addToCart" id="ShoppingCartAdd"></a> --->
            <input type="submit" name="ADD2CART" value="Add Item(s) to Cart" class="button">
          </div>
          <input type="hidden" value="25" name="processlist">
          <input type="hidden" value="25,25,25" name="managerlist">
        </form>
		</cfoutput>
      </article>
			
		</div>	
		<cfelse>
			<p>This page is not available to you.  Please login to see you account information.
		</cfif>	
	
</div>
</div>

