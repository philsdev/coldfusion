Current.ListPage = "index.cfm?event=Admin.Order.Management";	

Url.Search = "index.cfm?event=Admin.Order.Items.Search";
Url.Edit = "index.cfm?event=Admin.Order.Items.Information";
Url.Delete = 'index.cfm?event=Admin.Order.Items.Delete';
Url.View = "";

Form.Search = "#OrderItemsSearch";
Form.Edit = "#OrderItemsEditForm";

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

	$('.updateTotal').click( function() {
	//alert('hi');
	var thisSubtotal = parseFloat($('#Subtotal').val());
		if (isNaN(thisSubtotal)){
		thisSubtotal = 0;
		}
	//alert('Subtotal: ' + thisSubtotal);
	
	var thisTaxCharge = parseFloat($('#TaxCharge').val());
		if (isNaN(thisTaxCharge)){
		thisTaxCharge = 0;
		}
	//alert('taxcharge: ' + thisTaxCharge);
	
	var thisShippingCharge = parseFloat($('#ShippingCharge').val());
		if (isNaN(thisShippingCharge)){
		thisShippingCharge = 0;
		}
	//alert('ShippingCharge: ' + thisShippingCharge);
	
	var thisMiscCharge = parseFloat($('#MiscCharge').val());
	if (isNaN(thisMiscCharge)){
		thisMiscCharge = 0;
		}
	//alert('MiscCharge: ' + thisMiscCharge);

	var thisTotalCharge = thisSubtotal + thisTaxCharge + thisShippingCharge + thisMiscCharge;
	var FinalTotalCharge=Math.round(thisTotalCharge*100)/100  //returns number to 2 decimal places
	//alert('TotalCharge: ' + FinalTotalCharge);
	
	$('#TotalCharge').val(FinalTotalCharge);
 	
	});
	
	





	/*$(Form.Edit).validate({
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
	});  */
	
	
});