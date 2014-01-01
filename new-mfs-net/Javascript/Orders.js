Current.ListPage = "index.cfm?event=Admin.Order.Management";	

Url.Search = "index.cfm?event=Admin.Order.Search";
Url.Edit = "index.cfm?event=Admin.Order.Information";
Url.Delete = 'index.cfm?event=Admin.Order.Delete';
Url.View = "";

Form.Search = "#OrderSearch";
Form.Edit = "#OrderEditForm";

$().ready( function() {
	
	SetRowColors();
	
	$('a:contains("Edit")').live("click", function(){
		Current.RowID = $(this).parent('td').parent('tr').attr(Attribute.RowID);
		self.location.href = Url.Edit + "&OrderID=" + Current.RowID;				 
	});
	
	$('a:contains("Delete")').live("click", function(){
		Current.Row = $(this).parent('td').parent('tr');
		Current.RowID = $(Current.Row).attr(Attribute.RowID);
		
		if (confirm("O.K. to delete this order?")) {
			showGridLoader();
			$.get(Url.Delete, { OrderID: Current.RowID },
	  			function(data){
					submitSearchForm();
	  			});
		}
		return false;
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
			Status: { required: true }
		}		
	});
	
});