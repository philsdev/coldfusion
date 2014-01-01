Form.Edit = "#ProductUpsellEditForm";
Url.Edit = 'index.cfm?event=Admin.Product.Upsell.Information&ProductID=' + __ProductID;
Url.UpsellProducts = 'index.cfm?event=Admin.Product.Upsell.Available&ProductID=' + __ProductID;
Current.ListPage = 'index.cfm?event=Admin.Product.Management';

$().ready( function() {	
	
	$('span.FirstCharacter').children('a').click( function() {
		
		$('#AvailableProductsContainer').hide();
		$('#AvailableProductsWaiter').show();
	
		var SelectedSearchBy = $('#UpsellSearchBy').val();
		var SelectedFirstCharacter = $(this).text();
		var UpsellProductsUrl = Url.UpsellProducts + '&SearchBy=' + SelectedSearchBy + '&FirstCharacter=' + SelectedFirstCharacter;
		
		$.get(UpsellProductsUrl,
			function(data){
				$('#AvailableProducts').html(data);
				$('#AvailableProductsWaiter').hide();
				$('#AvailableProductsContainer').show();				
			}
		);			
		
	});
	
	$('.OptionAdd').click( function() {
		var ThisOptionHtml = $('#AvailableProducts').children('option:selected').clone();
		$(Selector.SelectedProducts).prepend(ThisOptionHtml);
	});

	$('.OptionRemove').click( function() {
		/* remove this item */
		$(Selector.SelectedProducts).children('option:selected').remove();
		
		/* select the first (if any) available item so focus is not lost */
		$(Selector.SelectedProducts).children('option').first().attr('selected','selected').focus();
	});
	
	$('.OptionMoveUp').click( function() {
		var SelectedOptionHtml = $(Selector.SelectedProducts).children('option:selected').clone();
		var SelectedOptionID = $(Selector.SelectedProducts).children('option:selected').val();
		var PrevOptionID = $(Selector.SelectedProducts).children('option:selected').prev().val();		
		
		/* if it's not in first position, move it up one position and re-select it */
		if (!(isNaN(PrevOptionID))) {
			$(Selector.SelectedProducts).children('option[value=' + SelectedOptionID + ']').remove();
			$(Selector.SelectedProducts).children('option[value=' + PrevOptionID + ']').before( SelectedOptionHtml );
			$(Selector.SelectedProducts).children('option[value=' + SelectedOptionID + ']').attr('selected','selected').focus();
		}
		
	});
	
	$('.OptionMoveDown').click( function() {
		var SelectedOptionHtml = $(Selector.SelectedProducts).children('option:selected').clone();
		var SelectedOptionID = $(Selector.SelectedProducts).children('option:selected').val();
		var NextOptionID = $(Selector.SelectedProducts).children('option:selected').next().val();		
		
		/* if it's not in last position, move it down one position and re-select it */
		if (!(isNaN(NextOptionID))) {
			$(Selector.SelectedProducts).children('option[value=' + SelectedOptionID + ']').remove();
			$(Selector.SelectedProducts).children('option[value=' + NextOptionID + ']').after( SelectedOptionHtml );
			$(Selector.SelectedProducts).children('option[value=' + SelectedOptionID + ']').attr('selected','selected').focus();
		}
		
	});
	
	$(Form.Edit).submit( function() {
	
		$(Selector.SelectedProducts).attr('multiple','multiple');
		$(Selector.SelectedProducts).children('option').attr('selected','selected');
		
	
	});
	
});