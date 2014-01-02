Current.ListPage = "index.cfm?event=Admin.Job.Management";	

Url.Search = "index.cfm?event=Admin.Job.Search";
Url.Edit = "index.cfm?event=Admin.Job.Information";
Url.Delete = "index.cfm?event=Admin.Job.Delete";
Url.View = "";

Form.Search = "#JobSearch";
Form.Edit = "#JobEditForm";

$().ready( function() {	
	
	SetRowColors();
	
	$('a:contains("Edit")').live("click", function(){
		Current.RowID = $(this).parent('td').parent('tr').attr(Attribute.RowID);
		self.location.href = Url.Edit + "&JobID=" + Current.RowID;						 
	});
	
	$('a:contains("Delete")').live("click", function(){
		Current.Row = $(this).parent('td').parent('tr');
		Current.RowID = $(Current.Row).attr(Attribute.RowID);		
		if (confirm("O.K. to delete this job?")) {
			showGridLoader();
			$.get(Url.Delete, { JobID: Current.RowID },
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
			CompanyName: { required: true, minlength: 2, maxlength: 50 },
			ContactName: { required: true, minlength: 2, maxlength: 50 },
			ReplyEmail: { required: true, email: true },
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
