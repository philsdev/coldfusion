Current.ListPage = "index.cfm?event=Admin.Community.Management";	

Url.Search = "index.cfm?event=Admin.Community.Search";
Url.Edit = "index.cfm?event=Admin.Community.Information";
Url.Delete = "index.cfm?event=Admin.Community.Delete";
Url.View = "";

Form.Search = "#CommunitySearch";
Form.Edit = "#CommunityEditForm";

$().ready( function() {	
	
	SetRowColors();
	
	$('a:contains("Edit")').live("click", function(){
		Current.RowID = $(this).parent('td').parent('tr').attr(Attribute.RowID);
		self.location.href = Url.Edit + "&CommunityID=" + Current.RowID;						 
	});
	
	$('a:contains("Delete")').live("click", function(){
		Current.Row = $(this).parent('td').parent('tr');
		Current.RowID = $(Current.Row).attr(Attribute.RowID);		
		if (confirm("O.K. to delete this community?")) {
			showGridLoader();
			$.get(Url.Delete, { CommunityID: Current.RowID },
	  			function(data){
					submitSearchForm();
	  			});
		}
		return false;
	});
		
	$(Form.Edit).validate({
		rules: {
			Title: { required: true, minlength: 2, maxlength: 50 },
			Description: { required: true, minlength: 4 }
		},
		errorPlacement: function(error, element) {
			error.insertAfter(element);
		},
		errorElement: "span"
	});
	
});
