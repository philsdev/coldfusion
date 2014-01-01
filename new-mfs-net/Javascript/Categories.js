Current.ListPage = "index.cfm?event=Admin.Category.Management";	

Url.Search = "index.cfm?event=Admin.Category.Search";
Url.Edit = "index.cfm?event=Admin.Category.Information";
Url.Delete = 'index.cfm?event=Admin.Category.Delete';
Url.View = "";

Form.Search = "#CategorySearch";
Form.Edit = "#CategoryEditForm";

$().ready( function() {
	
	SetRowColors();
	var thisCategoryID = $('#CategoryID').val();
			
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

	$(Form.Edit).validate({
		
		rules: {
			CategoryName: { required: true, minlength: 2, maxlength: FieldLimits.CategoryName },
			CategoryDescription: { required: true },
			CategoryParent: { required: false, not: thisCategoryID },
			DisplayPosition: { required: true, digits: true },
			CategoryImageUpload: { required: false, accept: __CategoryImageValidExtensionList },
			Status: { required: true }
		}	
	});
	
});