Current.ListPage = "index.cfm?event=Admin.Corporate.Management";	

Url.Search = "index.cfm?event=Admin.Corporate.Search";
Url.Edit = "index.cfm?event=Admin.Corporate.Information";
Url.Delete = "index.cfm?event=Admin.Corporate.Delete";
Url.View = "";

Form.Search = "#CorporateSearch";
Form.Edit = "#CorporateEditForm";

Field.Password = "#Password";

$().ready( function() {	
	
	SetRowColors();
	
	$('a:contains("Edit")').live("click", function(){
		Current.RowID = $(this).parent('td').parent('tr').attr(Attribute.RowID);
		self.location.href = Url.Edit + "&DealerID=" + Current.RowID;						 
	});
	
	$('a:contains("Delete")').live("click", function(){
		Current.Row = $(this).parent('td').parent('tr');
		Current.RowID = $(Current.Row).attr(Attribute.RowID);		
		if (confirm("O.K. to delete this Company?")) {
			showGridLoader();
			$.get(Url.Delete, { DealerID: Current.RowID },
	  			function(data){
					submitSearchForm();
	  			});
		}
		return false;
	});
		
	$(Form.Edit).validate({
		rules: {
		
			Company: { required: true, minlength: 2, maxlength: FieldLimits.Company },
			FirstName: { required: true, minlength: 2, maxlength: FieldLimits.FirstName },
			LastName: { required: true, minlength: 2, maxlength: FieldLimits.LastName },
			PhoneNumber: { required: true, minlength: 2, maxlength: FieldLimits.PhoneNumber },
			EmailAddress: { required: true, email: true },
			YearsInBusiness: { required: true, minlength: 1, maxlength: FieldLimits.YearsInBusiness },
			DiscountPercent: { required: true, minlength: 1, maxlength: FieldLimits.DiscountPercent },
			Username: { required: true, minlength: 4, maxlength: FieldLimits.Username },
			TaxExempt: { required: true },
			Status: { required: true }
		}
	});
	
});