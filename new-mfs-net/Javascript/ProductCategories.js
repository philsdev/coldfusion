Current.ListPage = 'index.cfm?event=Admin.Product.Management';

Url.Search = '';
Url.Edit = 'index.cfm?event=Admin.Product.Category.Management&ProductID=' + __ProductID;
Url.Delete = '';
Url.View = '';

Form.Search = '';
Form.Edit = '#ProductCategoryEditForm';

$().ready( function() {	

	/*$('a:contains("Edit")').live("click", function(){
		Current.RowID = $(this).parent('td').parent('tr').attr(Attribute.RowID);
		Current.parent = $(this).parent('td').parent('tr').attr(Attribute.parent);
		Current.grandparent = $(this).parent('td').parent('tr').attr(Attribute.grandparent);
		self.location.href = Url.Edit + "&CategoryID=" + Current.RowID + "&parent=" + Current.parent + "&grandparent=" + Current.grandparent;				 
	});*/
	
		$('input[level=2]').click( function() {
			var RowID = $(this).parent('td').parent('tr').attr(Attribute.RowID);
			var parentRowID = $(this).parent('td').parent('tr').attr(Attribute.Parent);
			
			//var ThisID = $(this).val();
			if( $(this).is(':checked') ) {
				$('input[parentid=' + parentRowID + ']').attr('checked','checked');
			} else {	
				//$('input[parentid=' + parentRowID + ']').removeAttr('checked');
			}
		});
	
		$('input[level=3]').click( function() {

			var RowID = $(this).parent('td').parent('tr').attr(Attribute.RowID);
			var parentRowID = $(this).parent('td').parent('tr').attr(Attribute.Parent);
			var grandparentRowID = $(this).parent('td').parent('tr').attr(Attribute.Grandparent);
			
					
			//var ThisID = $(this).val();
			if( $(this).is(':checked') ) {
				$('input[parentid=' + parentRowID + ']').attr('checked','checked');
				$('input[parentid=' + grandparentRowID + ']').attr('checked','checked');
			} else {	
				//$('input[parentid=' + parentRowID + ']').removeAttr('checked');
				//$('input[parentid=' + grandparentRowID + ']').removeAttr('checked');
			}
		});
		
		
	/*$(Form.Edit).submit( function() {
	
		$(Selector.SelectedCategories).attr('multiple','multiple');
		$(Selector.SelectedCategories).children('option').attr('selected','selected');
		
	
	});*/
	
});