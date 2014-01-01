Current.ListPage = "index.cfm?event=Admin.Product.Management";	

Url.Search = "index.cfm?event=Admin.Product.Search";
Url.Edit = "index.cfm?event=Admin.Product.Information";
Url.Delete = 'index.cfm?event=Admin.Product.Delete';
Url.View = "";

Form.Search = "#ProductSearch";
Form.Edit = "#ProductEditForm";

$().ready( function() {
	
	SetRowColors();
	
	$('a:contains("Edit")').live("click", function(){
		Current.RowID = $(this).parent('td').parent('tr').attr(Attribute.RowID);
		self.location.href = Url.Edit + "&ProductID=" + Current.RowID;				 
	});
	
	$('a:contains("Delete")').live("click", function(){
		Current.Row = $(this).parent('td').parent('tr');
		Current.RowID = $(Current.Row).attr(Attribute.RowID);
		
		if (confirm("O.K. to delete this product?")) {
			showGridLoader();
			$.get(Url.Delete, { ProductID: Current.RowID },
	  			function(data){
					submitSearchForm();
	  			});
		}
		return false;
	});
	
	$('a:contains("All")').click( function(){
		$('td.input').children('input').attr('checked', 'checked');
	});
	
	$('a:contains("None")').click( function(){
		$('td.input').children('input').removeAttr('checked');
	});
	
	$('#ProductCategoryOptionsContainer > select').live('change', function() {
		toggleOption('ProductSubcategory',false)
		toggleOption('ProductSubSubcategory',false);
		toggleOptions('ProductCategory','ProductSubcategory');		
	});
	
	$('#ProductSubcategoryOptionsContainer > select').live('change', function() {
		toggleOption('ProductSubSubcategory',false);
		toggleOptions('ProductSubcategory','ProductSubSubcategory');
	});

	$(Form.Edit).validate({
		rules: {
			ProductName: { required: true, minlength: 2, maxlength: FieldLimits.ProductName },
			ProductNumber: { required: true, minlength: 2, maxlength: FieldLimits.ProductNumber },
			Status: { required: true },
			ProductOutOfStockMessage: { required: false, maxlength: FieldLimits.ProductOutOfStockMessage }
		}
	});
	
});
