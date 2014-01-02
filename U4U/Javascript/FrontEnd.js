var PasswordField = "[name=Password]";
var baseStrengthClass = "PasswordStrength";
var StrengthArray = new Array("Fail","Poor","Weak","Mild","Strong");
var StrengthElement = 'div.PasswordStrength';

var DefaultSearchText = 'Search';

var Html = {
	Loading: '<img class="calcImage" src="/images/calculating.gif" />'
};

var FieldsToBeCleared = {
	Textbox: '#signupForm > li > input[type=text],.searchInput,.searchContainer > input[type=text]',
	Textarea: '#signupForm > li > textarea'	,
	PasswordLabel: '.labelTest label',
	PasswordInput: '.labelTest input'
}

var Regex = {
	username: '[^A-Za-z0-9]'
}

$().ready( function(){    

	var initialInputValues = new Array();
	var initialTextareaValues = new Array();
	var inputIndex = 0;
	var textareaIndex = 0;
	
	$.ajaxSetup({ cache:false });
	
	$('.datepicker').datepicker();
	
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

	/* TEXT INPUT CLEARING */
	$.each( $(FieldsToBeCleared.Textbox), function(){
		$(this).value = $(this).attr('value');
		initialInputValues[inputIndex] = $(this).attr('value');
		inputIndex++;
	})

	$(FieldsToBeCleared.Textbox).focus(function(){
		var thisIndex = $(FieldsToBeCleared.Textbox).index(this);
		if( $(this).attr('value') == initialInputValues[thisIndex] ){
			$(this).attr('value', "");
		}
	});

	$(FieldsToBeCleared.Textbox).blur( function(){
		var thisIndex = $(FieldsToBeCleared.Textbox).index(this);
		if( $(this).attr('value') == "" ){
			$(this).attr('value', initialInputValues[thisIndex]) 
		}
	});

	/* TEXT AREA CLEARING */
	$.each( $(FieldsToBeCleared.Textarea), function(){
		initialTextareaValues[textareaIndex] = $(this).html();
		textareaIndex++;	
	});

	$(FieldsToBeCleared.Textarea).focus(function(){
		var indexT = $(FieldsToBeCleared.Textarea).index(this);
		if( $(this).html(initialTextareaValues[thisIndex]) ){
			$(this).html("") ;
		}
	});

	$(FieldsToBeCleared.Textarea).blur( function(){
		var thisIndex = $(FieldsToBeCleared.Textarea).index(this);
		if( $(this).html("") ){
			$(this).html(initialTextareaValues[thisIndex]) 
		}
	});
	
	/* PW CLEARING */
	$(FieldsToBeCleared.PasswordLabel).css('display', 'block');
	
	$(FieldsToBeCleared.PasswordLabel).each( function(){
		
		if( $(this).parent(0).children('input').attr('value')){
			
		}else{
			
		};								  
													  
	});
	
	$(FieldsToBeCleared.PasswordLabel).click( function(){
		$(this).hide();
		$(this).parent(0).children('input').focus();
	});
	
	$(FieldsToBeCleared.PasswordInput).focus( function(){
		$(this).parent(0).children('label').hide()
	});
	
	$(FieldsToBeCleared.PasswordInput).blur( function(){
		if( $(this).attr('value')){

		}else{
			$(this).parent(0).children('label').show();
		}
	});
	
	/* FANCY BOX */
	
	$(".fancy").fancybox({
		'titleShow':false,
		'width':980
	});	
	
	$(".fancyPopup").fancybox({
		'width':600,
		'height':'75%',
		'autoScale':false,
		'transitionIn':'none',
		'transitionOut':'none',
		'type':'iframe',
		'padding':0
	});
	
	$(".fancyLink").fancybox({
		'titlePosition':'inside',
		'transitionIn':'none',
		'transitionOut':'none',
		'autodimensions':true
	});
	
	$('a.helpIcon').attr('title','HELP');
	
	$('a.fancyImage').fancybox();
	
	/* PAGINATION */
	
	$('div.wp-pagenavi > a').click( function() {
		scrollTop();
		var TargetPage = $(this).attr('p');
		$('#ListingsTargetPage').val( TargetPage );
		$('div.wp-pagenavi > a').attr('disabled','disabled');
		$('#ListingsForm').submit();
	});
	
	/* THE LATEST */
	
	$('.latestMore').live( 'click', function() {
		scrollUp( $('#LatestActivityHeader').position().top );
		var CurrentSec = GetLatestActivitySection();
		var NextPage = $(this).attr('nextPage');
		GetLatestActivity(CurrentSec,NextPage);
	});
	
	$('.latestViewAll').live( 'click', function() {
		var DestinationUrl = $(this).attr('destinationUrl');
		self.location.href = DestinationUrl;
	});
	
	$('a[section]').click( function() {
		scrollUp( $('#LatestActivityHeader').position().top );
		var sec = $(this).attr('section');
		GetLatestActivity(sec,1);
	});
	
	/* when the search form is submitted, results need to start at page one */
	$('#ListingsSubmitButton').click( function() {
		$('#ListingsTargetPage').val(1);
	});
	
	$('#Sort').change( function() {
		$('#ListingsForm').submit();
	});
	
	/* PLACEMENTS */
	
	$('.adPlacement').live( 'click', function() {
		var aid = $(this).attr('aid');
		var pid = $(this).attr('pid');
		var params = 'aid=' + aid + '&pid=' + pid;
		$.post( 
			'/ad-click.html', 
			params, 
			function(data) {}
		);	
	});
	
	$('.dealPlacement').live( 'click', function() {
		var did = $(this).attr('did');
		var params = 'did=' + did;
		$.post( 
			'/deal-click.html', 
			params, 
			function(data) {}
		);	
	});
	
	$(PasswordField).live( "keyup", function(){
		CheckPasswordStrength( this );
	});
	
	$('.forumReply').click( function() {
		$('#ForumPostReply').submit();
	});
	
	$('.quoteReply').click( function() {
		var postId = $(this).attr('postId');
		$('#ReplyPostID').val( postId );
		$('#ForumPostReply').submit();
	});
	
	$('.printBtn').click( function(){
		
		self.print();
		
	});
	
	$('#EmailList').validate({
		rules: {
			e: { required: true, maxlength: 100, email: true }
		},
		messages: {
			e: { required: 'Required', email: 'Required' }
		},
		submitHandler: function(form) {
			EmailListDestination = ( $('#EmailListUnsubscribe').is(':checked') ) ? '/email-list-unsubscribe.html' : '/email-list-subscribe.html';
			$('#EmailList').attr('action',EmailListDestination);
			form.submit();
		}
	});
	
	$('a.retry').click( function() {
		history.go(-1);
	});
	
});

function CheckPasswordStrength(element) {	
	var StrengthVal = $(element).val();	
	var HasUpper = /[A-Z]+/.test(StrengthVal);
	var HasLower = /[a-z]+/.test(StrengthVal);
	var HasNumber = /[0-9]+/.test(StrengthVal);
	var HasLength = (StrengthVal.length >= 8) ? true : false;
	var TotalStrength = parseInt(HasUpper + HasLower + HasNumber + HasLength);
	var StrengthLabel = StrengthArray[TotalStrength];

	$(StrengthElement).html(StrengthLabel).removeClass().addClass(baseStrengthClass + ' ' + StrengthLabel).show();
}

function GetLatestActivity(sec,pg) {
	$('#LatestActivity').html( Html.Loading );
	$('a[section]').parent('li').removeClass('active');
	$('a[section=' + sec + ']').parent('li').addClass('active');
	var params = "section=" + sec + "&page=" + pg;
	$.post( 
		'/latest-activity.html', 
		params, 
		function(data) {
			$('#LatestActivity').html(data);
		}
	);
	var vURL = '/latest/'+sec+'/#'+pg;
	_gaq.push(['_trackPageview', vURL ]);
	
}

function GetLatestActivitySection() {
	return $('.theLatest').children('li.active').children('a').attr('section');
}

function renderMap(address) {
		
	var geocoder = new google.maps.Geocoder();
	var coords = {};	
	geocoder.geocode( { 'address': address}, function(results, status) {

		if (status == google.maps.GeocoderStatus.OK && results[0].geometry.location) {
		
			coords.lat = results[0].geometry.location.lat();
			coords.long = results[0].geometry.location.lng();
			
			var latLong = new google.maps.LatLng(coords.lat, coords.long);
			var mapOptions = {
				zoom: 16,
				center: latLong,
				mapTypeId: google.maps.MapTypeId.ROADMAP
			};
			
			var map = new google.maps.Map(document.getElementById('map'), mapOptions);
			var marker = new google.maps.Marker({
				position: latLong, 
				map: map, 
				title: address
			});  
			 
		} else {
			$('#map').html("<cfoutput>#variables.Unavailable#</cfoutput>");
		}
		
	});
	
}

function scrollTop() {
	$('html,body').animate(
		{ scrollTop: 0 },
		{ duration: 100 }
	);	
}

function scrollUp(y) {
	$('html,body').animate(
		{ scrollTop: y },
		{ duration: 100 }
	);	
}