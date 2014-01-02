Current.ListPage = "index.cfm?event=Admin.Advertisement.Management";	

Url.Search = "index.cfm?event=Admin.Advertisement.Search";
Url.Edit = "index.cfm?event=Admin.Advertisement.Information";
Url.Delete = "index.cfm?event=Admin.Advertisement.Delete";
Url.View = "";

Form.Search = "#AdvertisementSearch";
Form.Edit = "#AdvertisementEditForm";

$().ready( function() {	
	
	SetRowColors();
	
	$('a:contains("Edit")').live("click", function(){
		Current.RowID = $(this).parent('td').parent('tr').attr(Attribute.RowID);
		self.location.href = Url.Edit + "&AdvertisementID=" + Current.RowID;						 
	});
	
	$('a:contains("Delete")').live("click", function(){
		Current.Row = $(this).parent('td').parent('tr');
		Current.RowID = $(Current.Row).attr(Attribute.RowID);		
		if (confirm("O.K. to delete this advertisement?")) {
			showGridLoader();
			$.get(Url.Delete, { AdvertisementID: Current.RowID },
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
			Type: { required: true },
			Size: { required: true },
			User: { required: true },
			Image: { required: true, accept: "jpeg|jpg|gif" },
			IsHouseAdvertisement: { required: true },
			MonetizationModel: { required: true },
			Budget: { required: true, number: true },
			CostPerClick: { required: true, number: true },
			CostPerThousandImpressions: { required: true, number: true },
			DestinationUrl: { required: true, url: true },
			Placement: { required: true },
			Status: { required: true }
		},
		errorPlacement: function(error, element) {
			error.insertAfter(element);
		},
		errorElement: "span"
	});
	
});
