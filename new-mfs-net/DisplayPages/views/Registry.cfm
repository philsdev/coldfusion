<cfscript>
	variables.LinkManager = Request.ListenerManager.GetListener( "LinkManager" );
</cfscript>
<!------------------------------------------------------------------------------------------

	CustomerInfo.cfm
	my-account.html

------------------------------------------------------------------------------------------->

<cfparam name="request.RegistryList.recordcount" default="">

<div id="breadcrumb">
	<a href="/" title="">Home</a>
	<span><a href="/my-account.html" title="">
	<cfif SESSION.User.UserType eq 1>
		Customer Account
	<cfelseif SESSION.User.UserType eq 2>
		Corporate Account
	</cfif></a>
	Gift Registry Homepage
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
								<h1>Gift Registry Homepage</h1>
						</header>
		          		<div id="registryApp">
						<div class="module registryModule l45">
							<h3>Active Registry: <strong><a href="?event=registryView&amp;registry_code=WED3_UAD8"><em>Another Registry</em></a></strong></h3>
							<div class="moduleContent smaller" >
							<p>You can add products to your active registry directly from our product catalog.</p>
							</div>
						</div>
			<div class="module registryModule r45">
			<h3>Find Registry By Code:</h3>
			<div class="moduleContent">
			<form action="/view-registry-search.html" method="post">
				<ul class="form hhh">
				<li class="labelGroup"><label>Registry Code:</label>
				<input type="text" class="textinput" name="registry_code"> </li>
			    <li>
				<input type="submit" value="Find Registry" class="button">
			    </li>
			    </ul>
			</form>
			</div>
			</div>
		
			<header class="cb"><a href="?event=registryEdit&registry_id=new" class="fr"><img src="http://matthewfsheehan.amp.com/images/plus-circle-frame.png" alt="Add Registry">&nbsp;Add a Registry</a>
			<h2> My Registries:</h2> </small>
			</header>
			<cfif request.RegistryList.recordcount gt 0>
			<table id="registryTable" cellpadding="0" cellspacing="0" border="0" class="itemsTable" summary="Registry List">
				<thead>
				<tr>
					<th class="setCol"></th>
					<th class="nameCol">Name</th>
					<th class="typeCol" align="left">Type</th>
					<th class="dateCol" align="center">Date</th>
					<th class="actionsCol" align="center">Actions</th>
				</tr>
				</thead>
				<tbody>
				<cfoutput query="request.RegistryList">
				
				<tr rowid="#RegistryID#">
				<td align="center">
				<cfif active_flag EQ 1>
					<img src="http://matthewfsheehan.amp.com/images/tick.png" alt="Active Registry">Active</td> 
				<cfelse>
					<a href="?event=registrySetCart&registry_id=#RegistryID#">Set To Active</a></td>
				</cfif>
				<td><strong>#Registry_Name#</strong><br><strong>Registry Code:</strong> #Registry_Code#</td>
				<td>#registry_type_code#</td> 
				<td align="center">#DateFormat(event_date, 'mm/dd/yyyy')#</td>
				<td align="right">
				<form action="/view-registry-details.html" method="post">
				<input type="hidden" name="registry_id" value="#RegistryID#">
					<a class="ViewRegistry">View</a> &nbsp;|&nbsp; 
					<a href="?event=registryEdit&registry_id=#RegistryID#">Edit</a> &nbsp;|&nbsp; 
					<a href="?event=registryToggle&registry_id=#RegistryID#" onclick="return confirm('Delete #Registry_Type_catalog_ID# named #Registry_Name#' );">Delete</a>    
					</form>
					</td>
				</tr>
					
				<!--- 	<td>
					<form action="/view-registry-details.html" method="post">
					<input type="hidden" value="#request.RegistryList.RegistryID#" name="RegistryID" >
					<a class="ViewRegistry">View</a></form>
					</td> 
					
				</tr> --->
				
				</cfoutput>
				</tbody>
				</table>
			<cfelseif request.RegistryList.recordcount eq 0 or request.RegistryList.recordcount eq "">
				<p>There are no Registries at this time</p>
			</cfif>
			
			<!--- <p></p>
			<h3>My Registries/WishLists</h3>
			<cfif request.Registry.recordcount gt 0>
			<table cellpadding="0" cellspacing="0" border="0" summary="Shopping Cart">
			<thead>
				<tr>
					<th align="left">Active</th>
					<th align="left" >Name</th>
					<th align="center" >Type</th>
					<th align="center">Date </th>
					<th align="center">Actions</th>
				</tr>
			</thead>
			<tbody>
			<tr>
				<td class="bold">#Active_Flag#</td>
				<td>#Registry_Name#</td>
				<td>#Registry_Type_catalog_ID#</td>
				<td>#DateFormat(event_date, 'mm/dd/yyyy')#</td>
				<td class="functions"><a>View</a> | <a>Edit</a> | <a>Delete</a></td> 
			</tr>
			</tbody>
			</table>
			<cfelse>
			<p>You have no registries or wishlists at this time.</p>
			</cfif>
			 --->
		<cfelse>
			<p>This page is not available to you.  Please login to see you account information.
		</cfif>	
	</div>
	
			</article>
		</div>
	</div>
</div>

