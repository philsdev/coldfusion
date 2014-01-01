Current.ListPage = "index.cfm?event=Admin.Product.Option.Management";	

Url.Search = "index.cfm?event=Admin.Product.Option.Search";
Url.Edit = "index.cfm?event=Admin.Product.Option.Information";
Url.Delete = "index.cfm?event=Admin.Product.Option.Delete";
Url.View = "";

Form.Search = "#ProductOptionSearch";
Form.Edit = "#ProductOptionEditForm";

$().ready( function() {
	
	SetRowColors();
	
	$('a:contains("Edit")').live("click", function(){
		Current.RowID = $(this).parent('td').parent('tr').attr(Attribute.RowID);
		self.location.href = Url.Edit + "&OptionID=" + Current.RowID + "&ProductID=" + __ProductID;				 
	});
	
	$('a:contains("Delete")').live("click", function(){
		Current.Row = $(this).parent('td').parent('tr');
		Current.RowID = $(Current.Row).attr(Attribute.RowID);
		
		if (confirm("O.K. to delete this Option?")) {
			showGridLoader();
			$.get(Url.Delete, { OptionID: Current.RowID,
								ProductID: __ProductID },
	  			function(data){
					self.location.href = Current.ListPage + '&ProductID=' + __ProductID;
	  			});
		}
		return false;
	});
	
	$('button:contains("New")').live("click", function(){
		self.location.href = Url.Edit + "&OptionID=0&ProductID=" + __ProductID;				 
	});
	

	$(Form.Edit).validate({
		rules: {
			OptionName: { required: true, minlength: 2, maxlength: FieldLimits.OptionName },
			OutOfStock: { required: true },
			GroupID: { required: true },
			Required: { required: true }
		}
	}); 
	

});