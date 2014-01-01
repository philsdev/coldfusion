// JavaScript Document
var FieldsToBeCleared = {
	Textbox: '#signupForm > li > input[type=text],.searchInput,.searchContainer > input[type=text]',
	Textarea: '#signupForm > li > textarea'	,
	PasswordLabel: '.labelTest label',
	PasswordInput: '.labelTest input',
	searchTextLabel: '.labelGroup label',
	searchTextInput: '.labelGroup input'
	
}

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
	
$(document).ready( function(){
	//$('.scrollable').scrollable();
	
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
											
											
			$targetElm = $(this).parent('li').children('.personalize');
			$targetElm.toggle();
											
											
											
											
	})
	

	
	var options = {  
		zoomType: 'standard',  
		lens:true,  
		preloadImages: true,  
		alwaysOn:false,  
		zoomWidth: 399,  
		zoomHeight: 300,  
		xOffset:24,  
		yOffset:0,  
		position:'right'  
		//...MORE OPTIONS  
	};  
	$('.productImage').jqzoom(options);  
	
	
	$('.fancyImage').fancybox();
							
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
	