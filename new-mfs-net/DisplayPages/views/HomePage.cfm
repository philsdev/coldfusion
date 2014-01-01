<!--- contentContainer nessesary for liquid layouts with static and percentage columns --->
<div id="contentContainer">
	<div id="content" class="contentSection">

		<div id="centralArea"> 
			<a class="prev" id="prev2"></a>
			<div class="scrollable">
				<div class="items centralCycle">
					<div class="scrollableItem">
						<a href="http://www.matthewfsheehan.net"><img src="images/central-image-1.jpg"  /></a> 
					</div>
					<div class="scrollableItem">
						<a href="http://www.matthewfsheehan.net"><img src="images/central-image-2.jpg"  /></a>
					</div>
				</div>
			</div>
			<a class="next" id="next2"></a> 
		</div>

		<!--- PROMO SLOT #2 --->
		<div id="promoSlot2" class="promo clearfix">
			<a href="" title=""><img src="images/free-shipping-promotion-wide.jpg" /></a>
		</div>

		<!--- PROMO SLOT #3 --->
		<div id="promoSlot3" class="promo">
			<a href="" title=""><img src="images/free-shipping-promotion-460.jpg" /></a>
		</div>

		<!--- PROMO SLOT #4 --->
		<div id="promoSlot4" class="promo">
			<a href="" title=""><img src="images/gift-registry-promotion-460.jpg" /></a>
		</div>

		<div id="homeCategoryListing">         
			<!--- <cfinclude template="#Request.ViewManager.getViewPath('Viewlets.ProductFeatures')#" /> --->
			<cfinclude template="#Request.ViewManager.getViewPath('Viewlets.CategoryFeatures')#" />
		</div>
	</div>
</div>