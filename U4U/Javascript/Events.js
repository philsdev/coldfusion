Current.ListPage = "index.cfm?event=Admin.Event.Management";	

Url.Search = "index.cfm?event=Admin.Event.Search";
Url.Edit = "index.cfm?event=Admin.Event.Information";
Url.Delete = "index.cfm?event=Admin.Event.Delete";
Url.View = "";

Form.Search = "#EventSearch";
Form.Edit = "#EventEditForm";

$().ready( function() {	
	
	SetRowColors();
	
	$('a:contains("Edit")').live("click", function(){
		Current.RowID = $(this).parent('td').parent('tr').attr(Attribute.RowID);
		self.location.href = Url.Edit + "&EventID=" + Current.RowID;						 
	});
	
	$('a:contains("Delete")').live("click", function(){
		Current.Row = $(this).parent('td').parent('tr');
		Current.RowID = $(Current.Row).attr(Attribute.RowID);		
		if (confirm("O.K. to delete this event?")) {
			showGridLoader();
			$.get(Url.Delete, { EventID: Current.RowID },
	  			function(data){
					submitSearchForm();
	  			});
		}
		return false;
	});
		
	$(Form.Edit).validate({
		rules: {
			Category: { required: true },
			User: { required: true },
			Title: { required: true, minlength: 2, maxlength: 50 },
			Description: { required: true, minlength: 4 },
			Organizer: { required: false, minlength: 2, maxlength: 50 },
			StartDate: {required: false },
			Status: { required: true },
			AddressTitle: { required: true, maxlength: 50 },
			Street1: { required: false, maxlength: 50 },
			Street2: { required: false, maxlength: 50 },
			City: { required: false, maxlength: 50 },
			State: { required: false },
			ZipCode: { required: false, zipCode: true },
			PhoneNumber: { required: false, phone: true },
			URL: { url: true }			
		},
		errorPlacement: function(error, element) {
			error.insertAfter(element);
		},
		errorElement: "span"
	});
	
});
