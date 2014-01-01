Current.ListPage = "index.cfm?event=Admin.Attribute.Management";		

Url.Search = "index.cfm?event=Admin.Attribute.Search";
Url.Edit = "index.cfm?event=Admin.Attribute.Information";
Url.Delete = "index.cfm?event=Admin.Attribute.Delete";
Url.View =  "";

Form.Search = "#AttributeSearch";
Form.Edit = "#AttributeEditForm";

$().ready( function() {
	
	SetRowColors();
	
	$('a:contains("Edit")').live("click", function(){
		Current.RowID = $(this).parent('td').parent('tr').attr(Attribute.RowID);
		self.location.href = Url.Edit + "&ProductAttributeID=" + Current.RowID;						 
	});
	
	
	$('a:contains("Delete")').live("click", function(){
		Current.Row = $(this).parent('td').parent('tr');
		Current.RowID = $(Current.Row).attr(Attribute.RowID);
		
		if (confirm("O.K. to delete this attribute?")) {
			showGridLoader();
			$.get(Url.Delete, { ProductAttributeID: Current.RowID },
	  			function(data){
					self.location.href = Current.ListPage;
	  			});
		}
		return false;
	});

	$(Form.Edit).validate({
		rules: {
			ProductAttributeName: { required: true, minlength: 2, maxlength: FieldLimits.ProductAttributeName },
			ProductAttributeStatus: { required: true }
		}
	}); 
	

});