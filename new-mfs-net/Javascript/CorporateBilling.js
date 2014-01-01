Current.ListPage = "index.cfm?event=Admin.Corporate.Management";	

Url.Search = "index.cfm?event=Admin.Corporate.Billing.Search";
Url.Edit = "index.cfm?event=Admin.Corporate.Billing.Management";
Url.Delete = "";
Url.View = "";

Form.Search = "#CorporateBillingSearch";
Form.Edit = "#CorporateBillingEditForm";


$().ready( function() {	
		
	$(Form.Edit).validate({
		rules: {
			BillFirstName: { required: true, minlength: 2, maxlength: FieldLimits.BillFirstName },
			BillLastName: { required: true, minlength: 2, maxlength: FieldLimits.BillLastName },
			BillAddress: { required: true, minlength: 2, maxlength: FieldLimits.BillAddress },
			BillCity: { required: true, minlength: 2, maxlength: FieldLimits.BillCity },
			BillZipCode: { required: true, minlength: 2, maxlength: FieldLimits.BillZipCode },
			BillCountry: { required: true },
			BillPhoneNumber: { required: true, minlength: 4, maxlength: FieldLimits.BillPhoneNumber }
		}
	});
	
});