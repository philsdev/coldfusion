Current.ListPage = "index.cfm?event=Admin.Customer.Management";	

Url.Search = "index.cfm?event=Admin.Customer.Billing.Search";
Url.Edit = "index.cfm?event=Admin.Customer.Billing.Management";
Url.Delete = "";
Url.View = "";

Form.Search = "#CustomerBillingSearch";
Form.Edit = "#CustomerBillingEditForm";


$().ready( function() {	
		
	$(Form.Edit).validate({
		rules: {
			BillAddress: { required: true, minlength: 2, maxlength: FieldLimits.BillAddress },
			BillCity: { required: true, minlength: 2, maxlength: FieldLimits.BillCity },
			BillZipCode: { required: true, minlength: 2, maxlength: FieldLimits.BillZipCode },
			BillCountry: { required: true },
			BillPhoneNumber: { required: true, minlength: 4, maxlength: FieldLimits.BillPhoneNumber }
		}
	});
	
});