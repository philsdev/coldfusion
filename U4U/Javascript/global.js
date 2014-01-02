  $(document).ready( function(){    

		var initVal = new Array();
		var	initValTA = new Array();
		var i = 0;
		var j = 0;
		
		/* TEXT INPUT CLEARING */
		$.each( $('input[type=text]'), function(){
			$(this).value = $(this).attr('value');
			initVal[i] = $(this).attr('value');
			i++		
		})


		$('input[type=text]').focus(function(){
			var index = $('input[type=text]').index(this);
	 		if( $(this).attr('value') == initVal[index] ){
				$(this).attr('value', "");
			}
	 	});


		$('input[type=text]').blur( function(){
			var index = $('input[type=text]').index(this);
			if( $(this).attr('value') == "" ){
				$(this).attr('value', initVal[index]) 
			}
		});
	
	
		/* TEXT AREA CLEARING */
		$.each( $('textarea'), function(){
			initValTA[j] = $(this).html();
			j++		
			
		});


		$('textarea').focus(function(){
			var indexT = $('textarea').index(this);
	 		if( $(this).html(initValTA[indexT])){
				$(this).html("") ;
			}
	 	});


		$('textarea').blur( function(){
			var indexT = $('textarea').index(this);
			if( $(this).html("") ){
				$(this).html(initValTA[indexT]) 
			}
		});
		});