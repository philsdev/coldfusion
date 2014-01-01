Current.ListPage = "index.cfm?event=Admin.Vendor.Management";	

Url.Search = "index.cfm?event=Admin.Vendor.Search";
Url.Edit = "index.cfm?event=Admin.Vendor.Information";
Url.Delete = 'index.cfm?event=Admin.Vendor.Delete';
Url.View = "";

Form.Search = "#VendorSearch";
Form.Edit = "#VendorEditForm";

$().ready( function() {
	
	SetRowColors();
	
	$('a:contains("Edit")').live("click", function(){
		Current.RowID = $(this).parent('td').parent('tr').attr(Attribute.RowID);
		self.location.href = Url.Edit + "&VendorID=" + Current.RowID;				 
	});
	
	$('a:contains("Delete")').live("click", function(){
		Current.Row = $(this).parent('td').parent('tr');
		Current.RowID = $(Current.Row).attr(Attribute.RowID);
		
		if (confirm("O.K. to delete this vendor?")) {
			showGridLoader();
			$.get(Url.Delete, { VendorID: Current.RowID },
	  			function(data){
					submitSearchForm();
	  			});
		}
		return false;
	});

	$(Form.Edit).validate({
		rules: {
			VendorName: { required: true, minlength: 2, maxlength: FieldLimits.VendorName },
			Status: { required: true }
		}	
	});
	
});