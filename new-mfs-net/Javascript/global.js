// JavaScript Document
var FieldsToBeCleared = {
	Textbox: '#signupForm > li > input[type=text],.searchInput,.searchContainer > input[type=text]',
	Textarea: '#signupForm > li > textarea'	,
	PasswordLabel: '.labelTest label',
	PasswordInput: '.labelTest input',
	searchTextLabel: '.labelGroup label',
	searchTextInput: '.labelGroup input'	
};

var Url = {
	CategoryFeaturedProducts: '/ajax/GetCategoryFeaturedProducts.html',
	CategoryProducts: '/ajax/GetCategoryProducts.html',
	ProductReviews: '/ajax/GetProductReviews.html',
	SearchResults: '/ajax/GetSearchResults.html',
	WriteProductReview: '/product-review.html'

}

var jqZoomOptions = {  
	zoomType: 'standard',  
	lens: true,  
	preloadImages: true,  
	alwaysOn: false,  
	zoomWidth: 399,  
	zoomHeight: 300,  
	xOffset: 24,  
	yOffset: 0,  
	position: 'right',
	title: false,
	showEffect: 'fadeIn',
    fadeinSpeed: 'slow',
    hideEffect: 'fadeOut',
    fadeoutSpeed: 'slow'

	//...MORE OPTIONS  
};  

var Checkout = {
	ShippingPrefix: 'Ship',
	BillingPrefix: 'Bill',
	FieldArray: ['Company','FirstName','LastName','Email','Address','Address2','City','State','ZipCode','Country','PhoneNumber','PhoneNumberExt','PhoneNumberAlt','PhoneNumberAltExt']
};

var Html = {
	Loading: '<img class="calcImage" src="/images/calculating.gif" />'
};

$().ready( function(){
	//$('.scrollable').scrollable();
	
	$.ajaxSetup({ cache:false });
	
	$('input').attr('autocomplete','off');
	
	/* JQUERY CUSTOM METHODS */
	
	jQuery.validator.addMethod("strongPassword", function(pw, element) {
		return this.optional(element) || ( pw.match(/[A-Z]/) && pw.match(/[a-z]/) && pw.match(/[0-9]/) && pw.length >= 8 && pw.length <= 20 );
		}, "Must contain at least 1 uppercase letter, 1 lowercase letter, 1 number and be between 8 and 20 characters"
	);
	
	jQuery.validator.addMethod("username", function(code, element) {
		return this.optional(element) || !(code.match(/[^A-Za-z0-9]/));
		}, "Username may only contain letters and/or numbers"
	);
	
	jQuery.validator.addMethod("zipCode", function(code, element) {
		code = code.replace(/\s+/g, ""); 
		code = code.toUpperCase();
		return this.optional(element) 
			|| code.match(/^[0-9]{5}$/) 
			|| code.match(/^[0-9]{5}.[0-9]{4}$/) 
			|| code.match(/^[A-Z][0-9][A-Z][0-9][A-Z][0-9]$/) 
			|| code.match(/^[A-Z][0-9][A-Z].[0-9][A-Z][0-9]$/);
		}, "Valid ZIP or Postal Code required"
	);
	
	jQuery.validator.addMethod("phoneNumber", function(phone_number, element) {
		phone_number = phone_number.replace(/\s+/g, ""); 
		return this.optional(element) || phone_number.length > 9 && phone_number.match(/^(1-?)?(\([2-9]\d{2}\)|[2-9]\d{2})-?[2-9]\d{2}-?\d{4}$/);
	}, "Please specify a valid phone number");
	
	jQuery.validator.addMethod("not", function(value, element, param) {
		return this.optional(element) || value != param;
	}, "Please enter a different value");
	
	jQuery.validator.addMethod("notEqualTo", function(value, element, param) {
		return this.optional(element) || value != $(param).val();
	}, "Please enter a different value");
	
	jQuery.validator.setDefaults("errorPlacement", function(error, element) {
		error.insertAfter(element)
	});
	
	jQuery.validator.setDefaults({
		errorElement: "span"
	});
	
	$('#additionalImages > li > a').click( function() {
		var thisDetailSrc = $(this).children('img').attr('detailSrc');
		var thisEnlargedSrc = $(this).children('img').attr('enlargedSrc');		
		var newImageSrc = '<img src="' + thisDetailSrc + '" style="width:273px" />';
		var newImageHtml = '<a href="' + thisEnlargedSrc + '" class="productImage imageTreatment1" rel="productDetailGallery">' + newImageSrc + '</a>';
			
		$('#productMedia > #productImage').html(newImageHtml);
		$('#productMedia > #productImage > a.productImage').jqzoom(jqZoomOptions);
	});
	
	
	/* PW CLEARING */
	
	$(FieldsToBeCleared.searchTextLabel).css('display', 'inline-block');
	
	$(FieldsToBeCleared.searchTextLabel).each( function(){
		if( $(this).parent(0).children('input').attr('value')){
			$(this).hide();
			$(this).parent(0).children('input').val($(this).parent(0).children('input').attr('value'));
			
		}else{
			
		};								  
													  
	});
	
	$(FieldsToBeCleared.searchTextLabel).click( function(){
		$(this).hide();
		$(this).parent(0).children('input').focus();
	});
	
	$(FieldsToBeCleared.searchTextInput).focus( function(){
		$(this).parent(0).children('label').hide()
	});
	
	$(FieldsToBeCleared.searchTextInput).blur( function(){
														
		if( $(this).attr('value')){
		
		}else{
	
			$(this).parent(0).children('label').show();
		}
	});
	
	$('.centralCycle').cycle({ 
		fx:     'fade', 
		speed:   1000,
		height:  385,
		fit: true,
		timeout: 5000, 
		next:   '#next2', 
		prev:   '#prev2',
		pager:  '#pager',
		pause:  1,
		
		 pagerAnchorBuilder: function(index, el) {
			return '<a href="#" class="navItem"></a>'; // whatever markup you want
		}
	
	});
	
	$('.grid .itemImage img').hide()
	$('.cycleContainer').css('visibility','visible');
	$('.cycleContainer').hide();
	$('.cycleContainer').fadeIn();
	$('.cycleFade').fadeIn();
	$('.cycleFade').cycle('fade');
	
	$("ul.tabs").tabs("div.panes > div");
	
	$('.personalizeTrigger').click( function(){											
		var targetElement = $(this).parent('li').children('.personalize');
		
		if ($(this).is(':checked')) {
			$(targetElement).show();				
		} else {
			$(targetElement).hide();
		}
	})
	

	
	
	$('a.productImage').jqzoom(jqZoomOptions);  
	
	
	$('.fancyImage').fancybox();
	
	$('.fancyTube').fancybox({
		'autodimensions':true,
		'transitionIn':'none',
		'transitionOut':'none',
		'type':'iframe',
		'padding':10
	});
	
	$('#searchProductsNav > a').live('click', function() {
		$('#searchProducts').html(Html.Loading);
				
		var TargetPage = $(this).attr('p');
		var TargetUrl = Url.SearchResults;
		var params = 'SearchString=' + $('#SearchString').val() + '&page=' + TargetPage;
		
		$.post( 
			TargetUrl, 
			params, 
			function(data) {
				$('#searchProducts').html(data);
			}
		);	
	});
	
	$('#featuredProductsNav > a').live('click', function() {
		$('#categoryFeatured').html(Html.Loading);
		scrollToElement('categoryFeatured');
		
		var TargetPage = $(this).attr('p');
		var TargetUrl = Url.CategoryFeaturedProducts;
		var params = 'ProductFeaturedCategory=' + __CategoryID + '&page=' + TargetPage;
		
		$.post( 
			TargetUrl, 
			params, 
			function(data) {
				$('#categoryFeatured').html(data);
			}
		);	
	});
	
	$('#categoryProductsNav > a').live('click', function() {	
		$('#categorySubcats').html(Html.Loading);
		scrollToElement('categorySubcats');
		
		var TargetPage = $(this).attr('p');
		var TargetUrl = Url.CategoryProducts;
		var params = GetCategoryProductParams() + '&page=' + TargetPage;
		
		$.post( 
			TargetUrl, 
			params, 
			function(data) {
				$('#categorySubcats').html(data);
			}
		);	
	});
	
	$('a.vendorLink').click( function() {		
		
		$('#categorySubcats').html(Html.Loading);
		scrollToElement('categorySubcats');
		
		$('a.vendorLink').removeClass('activeLink');
		$(this).addClass('activeLink');
		
		__VendorID = $(this).attr('vendorID');
		var TargetPage = 1;
		var TargetUrl = Url.CategoryProducts;
		var params = GetCategoryProductParams() + '&page=' + TargetPage;
		
		$.post( 
			TargetUrl, 
			params, 
			function(data) {
				$('#categorySubcats').html(data);
			}
		);	
	});
	
	$('a.priceRange').click( function() {	
		
		$('#categorySubcats').html(Html.Loading);
		scrollToElement('categorySubcats');
		
		$('a.priceRange').removeClass('activeLink');
		$(this).addClass('activeLink');
		
		__PriceID = $(this).attr('priceID');
		var TargetPage = 1;
		var TargetUrl = Url.CategoryProducts;
		var params = GetCategoryProductParams() + '&page=' + TargetPage;
		
		$.post( 
			TargetUrl, 
			params, 
			function(data) {
				$('#categorySubcats').html(data);
			}
		);	
	});
	
	$('.ViewOrder').click( function() {
		$(this).parent('form').submit();
	});
	
	$('#productReviewsNav > a').live('click', function() {
		$('#userReviews').html(Html.Loading);
		scrollToElement('productMoreInformation');
		
		var TargetPage = $(this).attr('p');
		var TargetUrl = Url.ProductReviews;
		var params = 'ProductID=' + __ProductID + '&page=' + TargetPage;
		
		$.post( 
			TargetUrl, 
			params, 
			function(data) {
				$('#userReviews').html(data);				
			}
		);	
	});
	
	$('.productReviewSummaryLink').click(function(){
		$('#productMoreInformation > ul.tabs > li > a:contains("Reviews")').trigger('click');
		scrollToElement('productMoreInformation');
	});
	
	$('.productReviewWriteLink').click(function(){
		$('#productMoreInformation > ul.tabs > li > a:contains("Reviews")').trigger('click');
		scrollToElement('productMoreInformation');
	});	
	
	$('.productReviewWrite').click(function(){
		$('#productMoreInformation > ul.tabs > li > a:contains("Reviews")').trigger('click');
		
		var TargetPage = $(this).attr('p');
		var TargetUrl = Url.WriteProductReview;
		var params = 'ProductID=' + __ProductID + '&page=' + TargetPage;
		
		$.post( 
			TargetUrl, 
			params, 
			function(data) {
				$('#userReviews').html(data);				
			}
		);	
		//$(location).attr('href',Url.WriteProductReview);
		
	});	
	
	$('.ProductOption').change(function() {
		RefreshProductPrice();
	});
	
	$('.personalizeTrigger').change(function() {
		RefreshProductPrice();
	});
	
	$('.personalizationLine').keyup(function() {
		RefreshPersonalizationLinePrice( $(this) );
	});
	
	$('.personalizationLine').blur(function() {
		RefreshProductPrice();
	});
	
	$('#TestimonialAdd').click( function() {
		$('#TestimonialForm').submit();
	});
	
	$('#TestimonialForm').validate({
		rules: {
			Description: { required: true, minlength: 2 },
			FirstName: { required:  true, minlength: 2, maxlength: 50 }
		}	
	});
	
	$('#ShoppingCartAdd').click( function() {
		$('#ShoppingCartForm').submit();
	});
	
	$('.RemoveItem').click( function() {
		if( confirm('O.K. to remove this item?') ) {
			$(this).parent('form').submit();
		}
	});
	
	$('.UpdateItem').click( function() {
		$(this).parent('form').submit();
	});
	
	$('.ReorderItem').click( function() {
		$(this).parent('form').submit();
	});
	
	$('#CopyShippingToBilling').change( function() {
		
		if (IsBillingSameAsShipping()) {
			DuplicateCheckoutFields();
		}
		
	});
	
	$('#ShipCountry').live('change', function(e) {

		 	var thisShipCountry = $(this).val();
            //alert($(this).val());
			//alert (thisShipCountry);

		//var thisShipCountry = $('#ShipCountry').val();
		//alert('State is required.');
		if (thisShipCountry == 'US') {
			alert('Shipping state is required.');
			$('#ShipState').show();
			$('#StateLabel').show();
			
		}
		else {
			$('#ShipState').hide().val('');
			$('#StateLabel').hide();
		}
				
	});
	
	$('#BillCountry').live('change', function(e) {

		 	var thisBillCountry = $(this).val();
            //alert($(this).val());
			//alert (thisShipCountry);

		//var thisShipCountry = $('#ShipCountry').val();
		//alert('State is required.');
		if (thisBillCountry == 'US') {
			alert('Billing state is required.');
			$('#BillState').show();
			$('#BillLabel').show();
			
		}
		else {
			$('#BillState').hide().val('');
			$('#BillLabel').hide();
		}
				
	});
	
	$('#ShippingFields > li > input, #ShippingFields > li > select').blur( function() {		
		if (IsBillingSameAsShipping()) {
			DuplicateCheckoutFields();
		}
	});
	
	$('.ViewRegistry').click( function() {
		$(this).parent('form').submit();
	});
	
});


$(window).load(function(){
		
	//LOAD IMAGES AND OFFSET THEM FOR ALIGNMENT
	$('.grid .itemImage img').each( function(){
				
		var parentHeight = $(this).parents('.itemImage').height()
		var myHeight = $(this).height();
		var offset = parentHeight  -  myHeight ;
		
		if( myHeight < parentHeight){
		
			$(this).css( 'position', 'relative')
			$(this).css( 'top', offset)	
		}
		
		$(this).css('visibility','visible');
		$(this).fadeIn('fast');	
		
	});

	
			  
			  
})

function IsBillingSameAsShipping() {
	if ($('#CopyShippingToBilling').is(':checked')) {
		return true;
	} else {
		return false;
	}
}

function DuplicateCheckoutFields() {
	var ShippingFieldName = new String('');
	var BillingFieldName = new String('');
	
	$.each(Checkout.FieldArray, function(index, value) {
		ShippingFieldName = Checkout.ShippingPrefix + value;
		BillingFieldName = Checkout.BillingPrefix + value;
		
		$('#' + BillingFieldName).val( $('#' + ShippingFieldName).val() );
	});
}

function GetCategoryProductParams() {
	var params = new String();
	params = 'ProductCategory=' + __CategoryID + '&ProductVendor=' + __VendorID + '&ProductPriceID=' + __PriceID;
	return params;
}

function RefreshPersonalizationLinePrice(element) {
	var ThisCharacterLineMax = new Number( $(element).attr('characterLineMax') );
	var ThisCharacterSurcharge = new Number( $(element).attr('characterSurcharge') );
	var ThisLineLength = new Number( $(element).val().length );
	var ThisLineSurcharge = new Number(0);
	var ThisLineSurchargeHtml = new String('');
		
	if (ThisLineLength > ThisCharacterLineMax) {
		ThisLineSurcharge = (ThisLineLength - ThisCharacterLineMax) * ThisCharacterSurcharge;				
		ThisLineSurchargeHtml = '[Add \$' + ThisLineSurcharge.toFixed(2) + ']';	
	} else {
		ThisLineSurchargeHtml = '';
	}
	
	$(element).attr('lineSurcharge',ThisLineSurcharge);
	$(element).parent('li').children('label').children('.personalizationLineSurcharge').html(ThisLineSurchargeHtml);
}

function RefreshProductPrice() {
	var ThisProductPrice = new Number();
	var ThisProductAddPrice = new Number();
	var NewProductPrice = new Number(__ProductPrice);
	var NewProductDisplayPrice = new String('');
	
	/* factor in absolute prices */
	
	$('.ProductOption').children('option:selected').each( function() {
	
		ThisProductPrice = $(this).attr('price');
		
		if (Number(ThisProductPrice) > 0) {
			NewProductPrice = Number(ThisProductPrice);
		}
	});
	
	/* factor in price adjustments */
	$('.ProductOption').children('option:selected').each( function() {
	
		ThisProductAddPrice = new Number( $(this).attr('addPrice') );
		
		if (ThisProductAddPrice > 0) {
			NewProductPrice += ThisProductAddPrice;
		}
	});
	
	/* factor in personalization */
	$('.personalizeTrigger:checked').each( function() {
		var ThisBaseCharge = new Number( $(this).parent('li.personalizeOption').attr('baseCharge') );
		var ThisLineSurcharge = new Number(0);
				
		if (ThisBaseCharge > 0) {
			NewProductPrice += ThisBaseCharge;
		}
		
		$(this).parent('li.personalizeOption').children('div.personalize').children('ul').children('li').children('.personalizationLine').each( function() {
			ThisLineSurcharge = Number( $(this).attr('lineSurcharge') );
			
			if (ThisLineSurcharge > 0) {			
				NewProductPrice += ThisLineSurcharge;
			}
		});		
	});
	
	$('#ProductDisplayPrice').html( formatPrice(NewProductPrice) );
}

function formatPrice(OriginalPrice) {
	var FormattedPrice = new String('');
	
	FormattedPrice = '\$' + OriginalPrice.toFixed(2);
	/* TODO: add comma delimiter(s) */
	
	return FormattedPrice;
}

function scrollToElement(elementName) {
	var yPos = $('#' + elementName).position().top;
	
	$('html,body').animate(
		{ scrollTop: yPos },
		{ duration: 100 }
	);	
}
	