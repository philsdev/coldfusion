Current.ListPage = "index.cfm?event=Admin.Product.Video.Management";	

Url.Search = "index.cfm?event=Admin.Product.Video.Search";
Url.Edit = "index.cfm?event=Admin.Product.Video.Information";
Url.Delete = 'index.cfm?event=Admin.Product.Video.Delete';
Url.View = "";

Form.Search = "#ProductVideoSearch";
Form.Edit = "#ProductVideoEditForm";

$().ready( function() {
	
	SetRowColors();
	
	$('a:contains("Edit")').live("click", function(){
		Current.RowID = $(this).parent('td').parent('tr').attr(Attribute.RowID);
		self.location.href = Url.Edit + "&VideoID=" + Current.RowID + "&ProductID=" + __ProductID;				 
	});
	
	$('a:contains("Delete")').live("click", function(){
		Current.Row = $(this).parent('td').parent('tr');
		Current.RowID = $(Current.Row).attr(Attribute.RowID);
		
		if (confirm("O.K. to delete this video?")) {
			showGridLoader();
			$.get(Url.Delete, { VideoID: Current.RowID },
	  			function(data){
					self.location.href = Current.ListPage + '?ProductID=' + __ProductID;
	  			});
		}
		return false;
	});

	$(Form.Edit).validate({
		rules: {
			ProductImageType: { required: true },
			ProductImageUpload: { required: false, accept: __ProductImageValidExtensionList }
		}	
	});
	
});