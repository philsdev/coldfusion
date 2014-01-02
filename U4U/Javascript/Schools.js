Current.ListPage = "index.cfm?event=Admin.School.Management";	

Url.Search = "index.cfm?event=Admin.School.Search";
Url.Edit = "index.cfm?event=Admin.School.Information";
Url.Delete = "index.cfm?event=Admin.School.Delete";
Url.View = "";

Form.Search = "#SchoolSearch";
Form.Edit = "#SchoolEditForm";

$().ready( function() {	
	
	SetRowColors();
	
	$('a:contains("Edit")').live("click", function(){
		Current.RowID = $(this).parent('td').parent('tr').attr(Attribute.RowID);
		self.location.href = Url.Edit + "&SchoolID=" + Current.RowID;						 
	});
	
	$('a:contains("Delete")').live("click", function(){
		Current.Row = $(this).parent('td').parent('tr');
		Current.RowID = $(Current.Row).attr(Attribute.RowID);		
		if (confirm("O.K. to delete this school?")) {
			showGridLoader();
			$.get(Url.Delete, { SchoolID: Current.RowID },
	  			function(data){
					submitSearchForm();
	  			});
		}
		return false;
	});
		
	$(Form.Edit).validate({
		rules: {
			Title: { required: true, minlength: 2, maxlength: 50 },
			Status: { required: true },
			AddressTitle: { required: true, maxlength: 50 },
			Street1: { required: true, maxlength: 50 },
			Street2: { maxlength: 50 },
			City: { required: true, maxlength: 50 },
			State: { required: true },
			ZipCode: { required: true, zipCode: true },
			PhoneNumber: { phone: true },
			URL: { url: true }			
		},
		errorPlacement: function(error, element) {
			error.insertAfter(element);
		},
		errorElement: "span"
	});
	
});
