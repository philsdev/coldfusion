Current.ListPage = "index.cfm?event=Admin.Order.Management";	

Url.Search = "index.cfm?event=Admin.Order.Billing.Search";
Url.Edit = "index.cfm?event=Admin.Order.Billing.Information";
Url.Delete = 'index.cfm?event=Admin.Order.Billing.Delete';
Url.View = "";

Form.Search = "#OrderBillingSearch";
Form.Edit = "#OrderBillingEditForm";

$().ready( function() {
	
	SetRowColors();
	
	$('a:contains("Edit")').live("click", function(){
		Current.RowID = $(this).parent('td').parent('tr').attr(Attribute.RowID);
		self.location.href = Url.Edit + "&OrderID=" + Current.RowID;				 
	});
	
	$('a:contains("Delete")').live("click", function(){
		Current.Row = $(this).parent('td').parent('tr');
		Current.RowID = $(Current.Row).attr(Attribute.RowID);
		
		if (confirm("O.K. to delete this order?")) {
			showGridLoader();
			$.get(Url.Delete, { OrderID: Current.RowID },
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
			BillAddress: { required: true, minlength: 2, maxlength: FieldLimits.BillAddress },
			BillCity: { required: true, minlength: 2, maxlength: FieldLimits.BillCity },
			BillZipCode: { required: true, minlength: 2, maxlength: FieldLimits.BillZipCode },
			BillCountry: { required: true },
			BillPhoneNumber: { required: true, minlength: 4, maxlength: FieldLimits.BillPhoneNumber },
			BillEmailAddress: { required: true, email: true  }
		}
	});
	
	
});