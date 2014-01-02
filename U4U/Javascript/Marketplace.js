Current.ListPage = "index.cfm?event=Admin.Marketplace.Management";	

Url.Search = "index.cfm?event=Admin.Marketplace.Search";
Url.Edit = "index.cfm?event=Admin.Marketplace.Information";
Url.Delete = "index.cfm?event=Admin.Marketplace.Delete";
Url.View = "";

Form.Search = "#MarketplaceSearch";
Form.Edit = "#MarketplaceEditForm";

$().ready( function() {	
	
	SetRowColors();
	
	$('a:contains("Edit")').live("click", function(){
		Current.RowID = $(this).parent('td').parent('tr').attr(Attribute.RowID);
		self.location.href = Url.Edit + "&ItemID=" + Current.RowID;						 
	});
	
	$('a:contains("Delete")').live("click", function(){
		Current.Row = $(this).parent('td').parent('tr');
		Current.RowID = $(Current.Row).attr(Attribute.RowID);		
		if (confirm("O.K. to delete this item?")) {
			showGridLoader();
			$.get(Url.Delete, { ItemID: Current.RowID },
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
			Category: { required: true },
			User: { required: true },			
			StartDate: { required: false, date: true },
			EndDate: { required: false, date: true },
			Price: { required: true, number: true, range: [1,100000] }, 
			Image: { required: false, accept: 'jpeg|jpg' },
			Status: { required: true }
		}
	});
	
});
