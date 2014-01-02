Current.ListPage = "index.cfm?event=Admin.Page.Management";	

Url.Search = "index.cfm?event=Admin.Page.Search";
Url.Edit = "index.cfm?event=Admin.Page.Information";
Url.Delete = "index.cfm?event=Admin.Page.Delete";
Url.View = "";

Form.Search = "#PageSearch";
Form.Edit = "#PageEditForm";

$().ready( function() {	
	
	SetRowColors();
	
	$('a:contains("Edit")').live("click", function(){
		Current.RowID = $(this).parent('td').parent('tr').attr(Attribute.RowID);
		self.location.href = Url.Edit + "&PageID=" + Current.RowID;						 
	});
	
	$('a:contains("Delete")').live("click", function(){
		Current.Row = $(this).parent('td').parent('tr');
		Current.RowID = $(Current.Row).attr(Attribute.RowID);		
		if (confirm("O.K. to delete this page?")) {
			showGridLoader();
			$.get(Url.Delete, { PageID: Current.RowID },
	  			function(data){
					submitSearchForm();
	  			});
		}
		return false;
	});
		
	$(Form.Edit).validate({
		rules: {
			Status: { required: true }
		},
		errorPlacement: function(error, element) {
			error.insertAfter(element);
		},
		errorElement: "span"
	});
	
});
