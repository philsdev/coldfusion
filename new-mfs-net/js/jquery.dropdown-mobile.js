$(function(){

	//$('.sub_menu').hide();

 
      $("span.expand").click(function(){
		
		var targetObj = $(this).parent('li').children('.sub_menu')
	    $(targetObj).toggle();	
		
		return false;
								 
	});
	
   // $("ul.dropdown li:has(ul)").find("a:first").addClass("hasSub");
  //  $("ul.dropdown li ul li:has(ul)").find("a:first").append(" &raquo; ");

});