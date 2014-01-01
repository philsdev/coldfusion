Current.ListPage = "index.cfm?event=Admin.Customer.Management";	

Url.Search = "index.cfm?event=Admin.Customer.Search";
Url.Edit = "index.cfm?event=Admin.Customer.Information";
Url.Delete = "index.cfm?event=Admin.Customer.Delete";
Url.View = "";

Form.Search = "#CustomerSearch";
Form.Edit = "#CustomerEditForm";

Field.Password = "#Password";

$().ready( function() {	
	
	SetRowColors();
	
	$('a:contains("Edit")').live("click", function(){
		Current.RowID = $(this).parent('td').parent('tr').attr(Attribute.RowID);
		self.location.href = Url.Edit + "&AccountID=" + Current.RowID;						 
	});
	
	$('a:contains("Delete")').live("click", function(){
		Current.Row = $(this).parent('td').parent('tr');
		Current.RowID = $(Current.Row).attr(Attribute.RowID);		
		if (confirm("O.K. to delete this Customer?")) {
			showGridLoader();
			$.get(Url.Delete, { AccountID: Current.RowID },
	  			function(data){
					submitSearchForm();
	  			});
		}
		return false;
	});
		
	$(Form.Edit).validate({
		rules: {
			BillFirstName: { required: true, minlength: 2, maxlength: FieldLimits.BillFirstName },
			BillLastName: { required: true, minlength: 2, maxlength: FieldLimits.BillLastName },
			EmailAddress: { required: true, email: true },
			Status: { required: true },
			Username: { required: true, minlength: 4, maxlength: FieldLimits.Username }
		}
	});
	
});