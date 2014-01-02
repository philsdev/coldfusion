Current.ListPage = "index.cfm?event=Admin.Email.Management";	

Url.Search = "index.cfm?event=Admin.Email.Search";
Url.Edit = "index.cfm?event=Admin.Email.Information";
Url.Delete = "index.cfm?event=Admin.Email.Delete";
Url.View = "";

Form.Search = "#EmailSearch";
Form.Edit = "#EmailEditForm";

$().ready( function() {	
	
	SetRowColors();
	
	$('a:contains("Edit")').live("click", function(){
		Current.RowID = $(this).parent('td').parent('tr').attr(Attribute.RowID);
		self.location.href = Url.Edit + "&EmailID=" + Current.RowID;						 
	});
	
	$('a:contains("Delete")').live("click", function(){
		Current.Row = $(this).parent('td').parent('tr');
		Current.RowID = $(Current.Row).attr(Attribute.RowID);		
		if (confirm("O.K. to delete this e-mail?")) {
			showGridLoader();
			$.get(Url.Delete, { EmailID: Current.RowID },
	  			function(data){
					submitSearchForm();
	  			});
		}
		return false;
	});
		
	$(Form.Edit).validate({
		rules: {
			Email: { required: true, email: true },
			Status: { required: true }
		},
		errorPlacement: function(error, element) {
			error.insertAfter(element);
		},
		errorElement: "span"
	});
	
});
