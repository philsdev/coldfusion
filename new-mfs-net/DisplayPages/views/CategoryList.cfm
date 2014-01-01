<cfscript>
	variables.LinkManager = Request.ListenerManager.GetListener( "LinkManager" );
	variables.ImageManager = Request.ListenerManager.GetListener( "ImageManager" );	
	variables.CategoryImage = variables.ImageManager.GetImageUrl( FileName:request.CategoryDetails.ImageName, ImageCategory:"category", ImageType:"list" );
	variables.CategoryName = variables.LinkManager.GetDisplayName( request.CategoryDetails.CategoryName );	
	
	Request.Meta.Title = variables.CategoryName;
</cfscript>

<cfoutput>

<script type="text/javascript">
	var __CategoryID = '#URL.CategoryID#';
	var __VendorID = '#FORM.VendorID#';
	var __PriceID = '#FORM.PriceID#';
</script>

<div id="breadcrumb">
	<a href="">Home</a>
	<span>#variables.CategoryName#</span>
</div>

<!-- contentContainer nessesary for liquid layouts with static and percentage columns -->
<aside id="sidebar">
	<cfif Request.Subcategories.Recordcount>
		<div class="sideModule navModule module">		
			<h3>Shop by Category</h3> 
			<!--- LIST SUBCATEGORIES OF CURRENT CATEGORY --->
			<div class="moduleContent">
				<ul>
					<cfloop query="Request.Subcategories">
						<cfset variables.SubcategoryName = variables.LinkManager.GetDisplayName( request.Subcategories.CategoryName ) />
						<cfset variables.SubcategoryLink = variables.LinkManager.GetCategoryLink( CategoryID:request.Subcategories.CategoryID, CategoryTitle:variables.SubcategoryName ) />
						<li><a href="#variables.SubcategoryLink#">#variables.SubcategoryName#</a></li>
					</cfloop>
				</ul>
			</div>
		</div>
	</cfif>
	
	<cfif Request.Vendors.Recordcount>
		<div class="sideModule navModule module">
			<h3>Shop by brand</h3> 
			<div class="moduleContent">
				<ul>
					<cfloop query="Request.Vendors">
						<li><a class="vendorLink" vendorID="#Request.Vendors.VendorID#">#variables.LinkManager.GetDisplayName( request.Vendors.VendorName )#</a></li>
					</cfloop>
				</ul>
			</div>
		</div>
	</cfif>
	<div class="sideModule navModule module">
		<h3>Shop By Price Range</h3>
		<div class="moduleContent">
			<ul>
				<cfloop from="1" to="#ArrayLen(REQUEST.PriceRange)#" index="variables.ThisRange">
					<li><a class="priceRange" priceID="#variables.ThisRange#">#REQUEST.PriceRange[variables.ThisRange].Title#</a></li>
				</cfloop>
			</ul>
		</div>
	</div>
</aside>

<div id="contentContainer">
	<div id="content" class="contentSection">

		<!--- IF THERE IS A PROMOTION ASSOCIATED TO THIS CATEGORY REPLACE THE .catalogHeader SECTION WITH THE PROMOTION 
			<div id="promoSlot5" class="promo">
			</div>
		--->
		
		<header class="catalogHeader">
			<div id="intro" class="clearfix">
				<div class="introImage">
					<img src="#variables.CategoryImage#" style="width:156px;" />
				</div>
				<h1>#variables.CategoryName#</h1>
				<cfif LEN(request.CategoryDetails.CategoryDesc)>
					<p>#variables.LinkManager.GetDisplayDescription( request.CategoryDetails.CategoryDesc )#</p>
				<cfelse>
					<p>This is a placeholder description, because this category does not have one yet.</p>
					<p>Without it, the layout of this section is all screwed up!</p>
					<p>So what are you waiting for? Make it!</p>
				</cfif>
			</div>
		</header>
			
		<section id="categoryFeatured">
			#request.CategoryProductFeatureContent#			
		</section>
		
		<section id="categorySubcats">
			#request.CategoryProductContent#
		</section> 

	</div>
</div>
	  
</cfoutput>