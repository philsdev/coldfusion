Current.ListPage = "index.cfm?event=Admin.Product.Image.Management";	

Url.Search = "index.cfm?event=Admin.Product.Image.Search";
Url.Edit = "index.cfm?event=Admin.Product.Image.Information";
Url.Delete = 'index.cfm?event=Admin.Product.Image.Delete';
Url.View = "";

Form.Search = "#ProductImageSearch";
Form.Edit = "#ProductImageEditForm";

$().ready( function() {
	
	SetRowColors();
	
	$('a:contains("Edit")').live("click", function(){
		Current.RowID = $(this).parent('td').parent('tr').attr(Attribute.RowID);
		self.location.href = Url.Edit + "&ImageID=" + Current.RowID + "&ProductID=" + __ProductID;				 
	});
	
	$('a:contains("Delete")').live("click", function(){
		Current.Row = $(this).parent('td').parent('tr');
		Current.RowID = $(Current.Row).attr(Attribute.RowID);
		
		if (confirm("O.K. to delete this image?")) {
			showGridLoader();
			$.get(Url.Delete, { ImageID: Current.RowID },
	  			function(data){
					self.location.href = Current.ListPage + '?ProductID=' + __ProductID;
	  			});
		}
		return false;
	});

	$('button:contains("New")').live("click", function(){
		self.location.href = Url.Edit + "&ImageID=0&ProductID=" + __ProductID;				 
	});
	
	$(Form.Edit).validate({
		rules: {
			ProductImageType: { required: true },
			ProductImageUpload: { required: false, accept: __ProductImageValidExtensionList }
		}	
	});
	
});