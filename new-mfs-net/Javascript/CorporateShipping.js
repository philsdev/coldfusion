Current.ListPage = "index.cfm?event=Admin.Corporate.Management";	

Url.Search = "index.cfm?event=Admin.Corporate.Shipping.Search";
Url.Edit = "index.cfm?event=Admin.Corporate.Shipping.Management";
Url.Delete = "";
Url.View = "";

Form.Search = "#CorporateShippingSearch";
Form.Edit = "#CorporateShippingEditForm";


$().ready( function() {	
		
	$(Form.Edit).validate({
		rules: {
			ShipFirstName: { required: true, minlength: 2, maxlength: FieldLimits.ShipFirstName },
			ShipLastName: { required: true, minlength: 2, maxlength: FieldLimits.ShipLastName },
			ShipAddress: { required: true, minlength: 2, maxlength: FieldLimits.ShipAddress },
			ShipCity: { required: true, minlength: 2, maxlength: FieldLimits.ShipCity },
			ShipZipCode: { required: true, minlength: 2, maxlength: FieldLimits.ShipZipCode },
			ShipCountry: { required: true },
			ShipPhoneNumber: { required: true, minlength: 4, maxlength: FieldLimits.ShipPhoneNumber }
		}
	});
	
});