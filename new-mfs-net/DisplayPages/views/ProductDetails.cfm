<cfscript>
	variables.LinkManager = Request.ListenerManager.GetListener( "LinkManager" );
	variables.ImageManager = Request.ListenerManager.GetListener( "ImageManager" );
	variables.ProductName = variables.LinkManager.GetDisplayName( request.ProductDetails.ProductName );
	Request.Meta.Title = variables.ProductName;
</cfscript>

<cfoutput>
<script type="text/javascript">
	var __ProductID = new Number(#URL.ProductID#);
	var __ProductPrice = new Number(#request.ProductDetails.ProductPrice#);
</script>

<!-- main area -->
<div id="breadcrumb">
	<a href="/">Home</a>
	<cfloop query="request.ProductNavigationCategories">
		<cfset variables.CategoryName = variables.LinkManager.GetDisplayName( request.ProductNavigationCategories.CategoryName ) />
		<cfset variables.CategoryLink = variables.LinkManager.GetCategoryLink( CategoryID:request.ProductNavigationCategories.CategoryID, CategoryTitle:variables.CategoryName ) />
		<a href="#variables.CategoryLink#">#variables.CategoryName#</a>
	</cfloop>
	<span>#variables.ProductName#</span>
</div>
	  
<!-- contentContainer nessesary for liquid layouts with static and percentage columns -->
<div id="contentContainer">
	<div id="content" class="contentSection">
		<div id="productBrief" class="clearfix">
			<div id="productMedia">
				<div id="productImage" class="clearfix2" >
					<!--- width must be set on the image to center it .  Image Max-Width: 268px.  No Max Height--->
					<cfset variables.ProductDetailImageUrl = variables.ImageManager.GetImageUrl( FileName:request.ProductImages.ImageName, ImageCategory:"product", ImageType:"detail" ) />
					<cfset variables.ProductEnlargedImageUrl = variables.ImageManager.GetImageUrl( FileName:request.ProductImages.ImageName, ImageCategory:"product", ImageType:"enlarged" ) />
					<a href="#variables.ProductEnlargedImageUrl#" class="productImage imageTreatment1" rel="productDetailGallery" >
						<img src="#variables.ProductDetailImageUrl#" style="width:273px;" />
					</a>
				</div>

				<ul class="hlist clearfix cb" id="viewingOptions">
					<li><a href="#variables.ProductEnlargedImageUrl#" title="" class="iconLink viewLink enlargeIcon fancyImage">Enlarge</a></li>
					<cfif request.ProductVideos.RecordCount>
						<li><a href="http://www.youtube.com/watch_popup?v=#request.ProductVideos.VideoKey#" class="iconLink viewLink playIcon fancyTube">Play Video</a></li>
					</cfif>
					<li><a title="" class="iconLink viewLink printIcon">Print</a></li>
				</ul>
              
				<ul class="hlist clearfix imageDisplay" id="additionalImages">
					<!--- MAX WIDTH - Alternate images: 60px; --->
					<cfloop query="request.ProductImages">
						<cfset variables.ProductThumbnailUrl = variables.ImageManager.GetImageUrl( FileName:request.ProductImages.ImageName, ImageCategory:"product", ImageType:"thumbnail" ) />
						<cfset variables.ProductDetailUrl = variables.ImageManager.GetImageUrl( FileName:request.ProductImages.ImageName, ImageCategory:"product", ImageType:"detail" ) />
						<cfset variables.ProductEnlargedUrl = variables.ImageManager.GetImageUrl( FileName:request.ProductImages.ImageName, ImageCategory:"product", ImageType:"enlarged" ) />
						<li>
							<a><img		src="#variables.ProductThumbnailUrl#" 
										detailSrc="#variables.ProductDetailUrl#" 
										enlargedSrc="#variables.ProductEnlargedUrl#" 
										style="width:51px;"/></a>
						</li>
					</cfloop>
				</ul>
			</div>
			<div id="productSetup">
				<header class="productHeader">
					<h1>#variables.ProductName#</h1>
					<div class="headerFunctions">
						<ul>
							<li>Item Number: #request.ProductDetails.ProductItemNumber#</li>
							<li>
								<cfif request.ProductReviews.RecordCount>
									<span class="rating stars-#NumberFormat(request.ProductReviewSummary.RatingAvg)#"></span>
									<a class="productReviewSummaryLink">(#NumberFormat(request.ProductReviewSummary.RatingCount)# customer reviews )</a>
								<cfelse>
									(0 customer reviews)
								</cfif>
								|
								<a class="productReviewWriteLink">Write a review</a>
							</li>
						</ul>
					</div>
				</header>		

				<form method="post" action="/add-item-to-shopping-cart.html" id="ShoppingCartForm">
					<input type="hidden" name="ProductID" value="#URL.ProductID#" />	
					
					<!--- IF THERE ARE NO ATTRIBUTES OR SHORT DESCRIPTION, GET RID OF THE "productOptions" div --->
					<div id="productOptions">
						<p>#variables.LinkManager.GetDisplayDescription( request.ProductDescriptions.ProductShortDesc )#</p>
						<ul class="form vvv optionsForm">
							<cfoutput>#request.ProductOptionContent#</cfoutput>								
						</ul>                 
						<ul id="personlizationForm" class="form vvv optionsForm">
							<cfloop collection="#REQUEST.Personalization#" item="variables.ThisOption">
								<cfif Request.ProductDetails[variables.ThisOption][1] EQ 1>
									<li class="inline personalizeOption" 
										baseCharge="#REQUEST.Personalization[variables.ThisOption].BaseCharge#" 
										characterLineMax="#REQUEST.Personalization[variables.ThisOption].CharacterLineMax#" 
										characterSurcharge="#REQUEST.Personalization[variables.ThisOption].CharacterSurcharge#"
									>
										<input type="checkbox" class="personalizeTrigger" name="#variables.ThisOption#" />
										<label><span class="red">#REQUEST.Personalization[variables.ThisOption].Title# Available!</span> Personalize this item?</label>
										<div class="personalize clearfix">
											<p class="moduleCol1">
												#REQUEST.Personalization[variables.ThisOption].Title# - Minimum charge of 
												<strong>#DollarFormat(REQUEST.Personalization[variables.ThisOption].BaseCharge)#</strong> 
												for a maximum of 
												#REQUEST.Personalization[variables.ThisOption].CharacterLineMax#
												characters across 
												#REQUEST.Personalization[variables.ThisOption].Lines#
												lines. You will automatically be charged an additional 
												#DollarFormat(REQUEST.Personalization[variables.ThisOption].CharacterSurcharge)# 
												per character over the initial 
												#REQUEST.Personalization[variables.ThisOption].CharacterLineMax# characters.
											</p>
											<ul class="moduleCol2">
												<cfloop from="1" to="#REQUEST.Personalization[variables.ThisOption].Lines#" index="variables.ThisIndex">
													<li>
														<label>Line #variables.ThisIndex# <span class="personalizationLineSurcharge"></span></label>
														<input	type="text" 
																class="personalizationLine" 
																name="#variables.ThisOption#__#variables.ThisIndex#"
																characterLineMax="#REQUEST.Personalization[variables.ThisOption].CharacterLineMax#" 
																characterSurcharge="#REQUEST.Personalization[variables.ThisOption].CharacterSurcharge#"
																lineSurcharge="0"
														/>
													</li>
												</cfloop>
												<li><!---  class="labelGroup" --->
													<label>Font</label>
													<select name="#variables.ThisOption#__font"  style="width:150px">
														<cfloop query="Request.Fonts">
															<option value="#Request.Fonts.FontName#">#Request.Fonts.FontName#</option>
														</cfloop>
													</select>
												</li>
											</ul>
										</div>
									</li>
								</cfif>
							</cfloop>
						</ul>
					</div>

					<div id="cartSetup">
						<aside class="module cartModule clearfix">
							<div class="moduleContent">
								<dl class="meta mb10">
									<cfif request.ProductDetails.ProductDiscountPrice GT 0>
										<dd class="price strike">Our Price: #DollarFormat(request.ProductDetails.ProductOurPrice)#</dd>
										<dd class="salePrice">Special: <span id="ProductDisplayPrice">#DollarFormat(request.ProductDetails.ProductDiscountPrice)#</span></dd>
									<cfelse>
										<dd class="price">Our Price: <span id="ProductDisplayPrice">#DollarFormat(request.ProductDetails.ProductOurPrice)#</span></dd>
									</cfif>
								</dl>						
								<ul class="form vii">
									<li>
										<label>Quantity:</label>
										<input type="text" class="quantityInput" name="ProductQuantity" />
									</li>
									<li>
										<a class="addToCart" id="ShoppingCartAdd"></a>
									</li>
									<li>
										<a class="button grayButton">Add to wishlist</a>
									</li>
								</ul>
							</div>
						</aside>
					</div>
				
				</form>
			</div>
		</div>

		<div id="productMoreInformation">
			<ul class="tabs">
				<li><a  title="">Overview</a></li>
				<li><a  title="">Reviews</a></li>
			</ul>
			<div class="panes clearfix">
				<div>
					<p>#variables.LinkManager.GetDisplayDescription( request.ProductDescriptions.ProductLongDesc )#</p>
				</div>
				<div>#Request.ProductReviewContent#</div>
			</div>
		</div>

		#Request.ProductUpsellContent#

	</div>
</div>
	  
</cfoutput>

<script type="text/javascript">
	$().ready( function() {
	
		RefreshProductPrice();				
	
		$('#ShoppingCartForm').validate({
			rules: {
				ProductQuantity: { required: true, digits: true }
				<cfif LISTLEN(request.RequiredOptionsList)>
					<cfloop list="#Request.RequiredOptionsList#" index="variables.ThisOptionName">
						, <cfoutput>#variables.ThisOptionName#</cfoutput>: { required: true }
					</cfloop>
				</cfif>
			},
			messages: {
				ProductQuantity: ''
			}
		});
		
	});
</script>
