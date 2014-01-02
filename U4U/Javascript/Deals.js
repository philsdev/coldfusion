Current.ListPage = "index.cfm?event=Admin.Deal.Management";	

Url.Search = "index.cfm?event=Admin.Deal.Search";
Url.Edit = "index.cfm?event=Admin.Deal.Information";
Url.Delete = "index.cfm?event=Admin.Deal.Delete";
Url.View = "";

Form.Search = "#DealSearch";
Form.Edit = "#DealEditForm";

$().ready( function() {	
	
	SetRowColors();
	
	$('a:contains("Edit")').live("click", function(){
		Current.RowID = $(this).parent('td').parent('tr').attr(Attribute.RowID);
		self.location.href = Url.Edit + "&DealID=" + Current.RowID;						 
	});
	
	$('a:contains("Delete")').live("click", function(){
		Current.Row = $(this).parent('td').parent('tr');
		Current.RowID = $(Current.Row).attr(Attribute.RowID);		
		if (confirm("O.K. to delete this deal?")) {
			showGridLoader();
			$.get(Url.Delete, { DealID: Current.RowID },
	  			function(data){
					submitSearchForm();
	  			});
		}
		return false;
	});
		
	$(Form.Edit).validate({
		rules: {
			Title: { required: true, minlength: 2, maxlength: 50 },
			Description: { required: true, minlength: 4 },
			Category: { required: true },
			User: { required: true },
			StartDate: { required: false, date: true },
			EndDate: { required: false, date: true },
			DestinationUrl: { required: true, url: true },
			Status: { required: true },
			AddressTitle: { required: true, maxlength: 50 },
			Street1: { required: true, maxlength: 50 },
			Street2: { required: false, maxlength: 50 },
			City: { required: true, maxlength: 50 },
			State: { required: true },
			ZipCode: { required: true, zipCode: true },
			PhoneNumber: { required: false, phone: true },
			URL: { required: false, url: true },
			MonetizationModel: { required: true },
			Budget: { required: true, number: true },
			CostPerClick: { required: true, number: true },
			CostPerThousandImpressions: { required: true, number: true },
			Image: { accept: "jpeg|jpg" }
		},
		errorPlacement: function(error, element) {
			error.insertAfter(element);
		},
		errorElement: "span"
	});
	
});