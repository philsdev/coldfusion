$(function(){

	$('.sub_menu').css('display', 'none');
	 
    var config = {    
         sensitivity: 1, // number = sensitivity threshold (must be 1 or higher)    
         interval: 0,  // number = milliseconds for onMouseOver polling interval    
         over: doOpen,   // function = onMouseOver callback (REQUIRED)    
         timeout: 0,   // number = milliseconds delay before onMouseOut    
         out: doClose    // function = onMouseOut callback (REQUIRED)    
    };
	
   
    function doOpen() {
        $(this).addClass("hover");
        $('div:first',this).css('visibility', 'visible');
		$('div:first',this).show();
		
		var windowWidth = $(window).width();
		var count = $(this).children('.sub_menu').children('ul').length;
		var menuWidth = $(this).children('.sub_menu').children('ul:eq(0)').outerWidth()+1;
		var subMenuWidth = menuWidth*count
		
		var subMenuXPos = $(this).children('.sub_menu').offset()
		var subMenuArea = subMenuXPos.left + subMenuWidth
		
		var subMenuFromRight = (subMenuXPos.left + subMenuWidth) - windowWidth;
		var subMenuFromLeft = (subMenuXPos.left - windowWidth)+windowWidth;
		var futurePosFromLeft = subMenuFromLeft - subMenuWidth;
		
		
		//If the amount past the right side of the window is less than the amount past the left side of the window, dont change the styles
		// Need to figure out if it's both past the left and the right
		//alert(Math.abs(subMenuFromRight))
		
	
		/* ADJUST THE PLACEMENT OF MENUS IF NEAR THE EDGE OF THE SCREEN */
		if( subMenuArea >= windowWidth || subMenuXPos.left < 0 ){
			if( ( futurePosFromLeft < 0 && subMenuFromRight > 0) && (Math.abs(futurePosFromLeft) > Math.abs(subMenuFromRight)) ){
			
			}else{
				if( $(this).parent().attr('id') == 'fullNav'){
					$(this).children('.sub_menu').css('left', 'auto');
					$(this).children('.sub_menu').css('right', '0');
					
				}else{
					$(this).children('.sub_menu').css('left', 'auto')
					$(this).children('.sub_menu').css('right', '100%')
				}
			}
		
		}else{
			if( $(this).parent().attr('id') == 'fullNav'){
				$(this).children('.sub_menu').css('left', '0');
				$(this).children('.sub_menu').css('right', 'auto');
			}else{
				$(this).children('.sub_menu').css('left', '90%')
				$(this).children('.sub_menu').css('right', 'auto')
			}
		}
		
		/* if there are more than 2 child uls, make the width of the submenu div expand */
		if(count >= 2){
			$(this).children('.sub_menu').css('width',subMenuWidth )			
		}
		
		
    }
 
    function doClose() { 
		$('div:first',this).hide();
		$('div:first',this).css('visibility', 'hidden');
   		
		
			
			if( $(this).parent().attr('id') == 'fullNav'){
					$(this).children('.sub_menu').css('left', '0');
					$(this).children('.sub_menu').css('right', 'auto');
				}else{
					$(this).children('.sub_menu').css('left', '90%')
					$(this).children('.sub_menu').css('right', 'auto')
			}
		
	
		$(this).removeClass("hover");
		
		

    }

    $("ul.dropdown li").hoverIntent(config);
    $("ul.dropdown li:has(ul)").find("a:first").addClass("hasSub");
    $("ul.dropdown li ul li:has(ul)").find("a:first").append(" &raquo; ");

});