Current.ListPage = "index.cfm?event=Admin.Administrator.Management";	

Url.Search = "index.cfm?event=Admin.Administrator.Search";
Url.Edit = "index.cfm?event=Admin.Administrator.Information";
Url.Delete = 'index.cfm?event=Admin.Administrator.Delete';
Url.View = "";

Form.Search = "#AdministratorSearch";
Form.Edit = "#AdministratorEditForm";

$().ready( function() {
	
	SetRowColors();
	
	$('a:contains("Edit")').live("click", function(){
		Current.RowID = $(this).parent('td').parent('tr').attr(Attribute.RowID);
		self.location.href = Url.Edit + "&AdminID=" + Current.RowID;				 
	});
	
	$('a:contains("Delete")').live("click", function(){
		Current.Row = $(this).parent('td').parent('tr');
		Current.RowID = $(Current.Row).attr(Attribute.RowID);
		
		if (confirm("O.K. to delete this administrator?")) {
			showGridLoader();
			$.get(Url.Delete, { AdminID: Current.RowID },
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

	$(Form.Edit).validate({
		rules: {
			FirstName: { required: true, minlength: 2, maxlength: FieldLimits.FirstName },
			LastName: { required: true, minlength: 2, maxlength: FieldLimits.LastName },
			Username: { required: true, minlength: 4, maxlength: FieldLimits.Username },
			Password: { required: function(element) { return $('#AdminID').val() == 0; } },
			PasswordConfirm: { equalTo: Field.Password },
			Status: { required: true }
		}		
	});
	
});