Current.ListPage = "index.cfm?event=Admin.Order.Management";	

Url.Search = "index.cfm?event=Admin.Order.Shipping.Search";
Url.Edit = "index.cfm?event=Admin.Order.Shipping.Information";
Url.Delete = 'index.cfm?event=Admin.Order.Shipping.Delete';
Url.View = "";

Form.Search = "#OrderShippingSearch";
Form.Edit = "#OrderShippingEditForm";

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
			ShipFirstName: { required: true, minlength: 2, maxlength: FieldLimits.ShipFirstName },
			ShipLastName: { required: true, minlength: 2, maxlength: FieldLimits.ShipLastName },
			ShipAddress: { required: true, minlength: 2, maxlength: FieldLimits.ShipAddress },
			ShipCity: { required: true, minlength: 2, maxlength: FieldLimits.ShipCity },
			ShipZipCode: { required: true, minlength: 2, maxlength: FieldLimits.ShipZipCode },
			ShipCountry: { required: true },
			ShipPhoneNumber: { required: true, minlength: 4, maxlength: FieldLimits.ShipPhoneNumber },
			ShipEmailAddress: { required: true, email: true  }
		}
	});
	
	
});