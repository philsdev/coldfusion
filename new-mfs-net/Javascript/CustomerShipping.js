Current.ListPage = "index.cfm?event=Admin.Customer.Management";	

Url.Search = "index.cfm?event=Admin.Customer.Shipping.Search";
Url.Edit = "index.cfm?event=Admin.Customer.Shipping.Management";
Url.Delete = "";
Url.View = "";

Form.Search = "#CustomerBShippingSearch";
Form.Edit = "#CustomerShippingEditForm";


$().ready( function() {	
		
	$(Form.Edit).validate({
		rules: {
			ShipAddress: { required: true, minlength: 2, maxlength: FieldLimits.ShipAddress },
			ShipCity: { required: true, minlength: 2, maxlength: FieldLimits.ShipCity },
			ShipZipCode: { required: true, minlength: 2, maxlength: FieldLimits.ShipZipCode },
			ShipCountry: { required: true },
			ShipPhoneNumber: { required: true, minlength: 4, maxlength: FieldLimits.ShipPhoneNumber }
		}
	});
	
});