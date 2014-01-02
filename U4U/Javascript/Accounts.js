Current.ListPage = "index.cfm?event=Admin.Account.Management";	

Url.Search = "index.cfm?event=Admin.Account.Search";
Url.Edit = "index.cfm?event=Admin.Account.Information";
Url.Delete = "index.cfm?event=Admin.Account.Delete";
Url.View = "";

Form.Search = "#AccountSearch";
Form.Edit = "#AccountEditForm";

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
		if (confirm("O.K. to delete this Account?")) {
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
			FirstName: { required: true, minlength: 2, maxlength: 50 },
			LastName: { required: true, minlength: 2, maxlength: 50 },
			Username: { required: true, minlength: 4, maxlength: 20 },
			Email: { required: true, email: true },
			School: { required: false },
			Password: { required: function(element) { return $('#AccountID').val() == 0; }, minlength: 6, maxlength: 20 },
			Status: { required: true }
		},
		submitHandler: function(form) {
			var SelectedUsername = $('#Username').val();
			var params = "username=" + SelectedUsername;
			$.post( 
				'index.cfm?event=User.Profile.CheckUsername', 
				params, 
				function(data) {
					if (data == 0) {
						form.submit();
					} else {
						alert('Username \'' + SelectedUsername + '\' is already taken');
					}
				}
			);
		}
	});
	
});