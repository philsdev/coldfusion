Current.ListPage = "index.cfm?event=Admin.Category.Management";	

Url.Search = "";
Url.Edit = "index.cfm?event=Admin.Category.Feature.Information";
Url.Delete = '';
Url.View = "";

Form.Search = "";
Form.Edit = "#ProductFeatureEditForm";

$().ready( function() {
	
	SetRowColors();
	
	$('a:contains("Edit")').live("click", function(){
		Current.RowID = $(this).parent('td').parent('tr').attr(Attribute.RowID);
		self.location.href = Url.Edit + "&CategoryID=" + Current.RowID;				 
	});
	
	$('a:contains("Delete")').live("click", function(){
		Current.Row = $(this).parent('td').parent('tr');
		Current.RowID = $(Current.Row).attr(Attribute.RowID);
		
		if (confirm("O.K. to delete this category?")) {
			showGridLoader();
			$.get(Url.Delete, { CategoryID: Current.RowID },
	  			function(data){
					submitSearchForm();
	  			});
		}
		return false;
	});
	
	
	$('.OptionAdd').click( function() {
	
		var thisProductSize = $(Selector.SelectedProducts).children('option').size();
		
		if (thisProductSize > 11) {
		alert('You can not have more than 12 featured products.');
		}
		else
		{
		var ThisOptionHtml = $('#AvailableProducts').children('option:selected').clone();
		$(Selector.SelectedProducts).prepend(ThisOptionHtml);
		}
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