Current.ListPage = "index.cfm?event=Admin.Report.Management";	

Url.Edit = "index.cfm?event=Admin.Report.Search";
Url.UpsellProducts = 'index.cfm?event=Admin.Report.Product.Available';


Form.Search = "#ReportSearch";
Form.Edit = "#ReportEditForm";

$().ready( function() {
	
	SetRowColors();
	
	$('#ProductCategoryOptionsContainer > select').live('change', function() {
		toggleOption('ProductSubcategory',false)
		toggleOption('ProductSubSubcategory',false);
		toggleOptions('ProductCategory','ProductSubcategory');		
	});
	
	$('#ProductSubcategoryOptionsContainer > select').live('change', function() {
		toggleOption('ProductSubSubcategory',false);
		toggleOptions('ProductSubcategory','ProductSubSubcategory');
	});
	
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
	
	$(Form.Edit).submit( function() {
	
		$(Selector.SelectedProducts).attr('multiple','multiple');
		$(Selector.SelectedProducts).children('option').attr('selected','selected');
		
	
	});
	
});