Current.ListPage = "index.cfm?event=Admin.DealCategory.Management";	

Url.Search = "index.cfm?event=Admin.DealCategory.Search";
Url.Edit = "index.cfm?event=Admin.DealCategory.Information";
Url.Delete = "index.cfm?event=Admin.DealCategory.Delete";
Url.View = "";

Form.Search = "#DealCategorySearch";
Form.Edit = "#DealCategoryEditForm";

$().ready( function() {	
	
	SetRowColors();
	
	$('a:contains("Edit")').live("click", function(){
		Current.RowID = $(this).parent('td').parent('tr').attr(Attribute.RowID);
		self.location.href = Url.Edit + "&DealCategoryID=" + Current.RowID;						 
	});
	
	$('a:contains("Delete")').live("click", function(){
		Current.Row = $(this).parent('td').parent('tr');
		Current.RowID = $(Current.Row).attr(Attribute.RowID);		
		if (confirm("O.K. to delete this deal category?")) {
			showGridLoader();
			$.get(Url.Delete, { DealCategoryID: Current.RowID },
	  			function(data){
					submitSearchForm();
	  			});
		}
		return false;
	});
		
	$(Form.Edit).validate({
		rules: {
			Title: { required: true, minlength: 2, maxlength: 50 },
			Description: { required: true, minlength: 4 },
			Status: { required: true }
		},
		errorPlacement: function(error, element) {
			error.insertAfter(element);
		},
		errorElement: "span"
	});
	
});
