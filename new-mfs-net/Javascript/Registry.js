Current.ListPage = "index.cfm?event=Admin.Registry.Management";	

Url.Search = "index.cfm?event=Admin.Registry.Search";
Url.Edit = "index.cfm?event=Admin.Registry.Information";
Url.Delete = 'index.cfm?event=Admin.Registry.Delete';
Url.View = "";

Form.Search = "#RegistrySearch";
Form.Edit = "#RegistryEditForm";

$().ready( function() {
	
	SetRowColors();
	
	$('a:contains("Edit")').live("click", function(){
		Current.RowID = $(this).parent('td').parent('tr').attr(Attribute.RowID);
		self.location.href = Url.Edit + "&RegistryID=" + Current.RowID;				 
	});
	
	$('a:contains("Delete")').live("click", function(){
		Current.Row = $(this).parent('td').parent('tr');
		Current.RowID = $(Current.Row).attr(Attribute.RowID);
		
		if (confirm("O.K. to delete this Registry?")) {
			showGridLoader();
			$.get(Url.Delete, { RegistryID: Current.RowID },
	  			function(data){
					submitSearchForm();
	  			});
		}
		return false;
	});

	$(Form.Edit).validate({
		rules: {
			Description: { required: true, minlength: 2 },
			FirstName: { required:  true, minlength: 2, maxlength: FieldLimits.FirstName }, 
			IsApproved: { required: true }
		}	
	});
	
});