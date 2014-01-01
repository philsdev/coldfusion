Current.ListPage = "index.cfm?event=Admin.Promotion.Management";	

Url.Search = "index.cfm?event=Admin.Promotion.Search";
Url.Edit = "index.cfm?event=Admin.Promotion.Information";
Url.Delete = 'index.cfm?event=Admin.Promotion.Delete';
Url.View = "";

Form.Search = "#PromotionSearch";
Form.Edit = "#PromotionEditForm";

$().ready( function() {
	
	SetRowColors();
	
	$('a:contains("Edit")').live("click", function(){
		Current.RowID = $(this).parent('td').parent('tr').attr(Attribute.RowID);
		self.location.href = Url.Edit + "&PromotionID=" + Current.RowID;				 
	});
	
	$('a:contains("Delete")').live("click", function(){
		Current.Row = $(this).parent('td').parent('tr');
		Current.RowID = $(Current.Row).attr(Attribute.RowID);
		
		if (confirm("O.K. to delete this promotion?")) {
			showGridLoader();
			$.get(Url.Delete, { PromotionID: Current.RowID },
	  			function(data){
					submitSearchForm();
	  			});
		}
		return false;
	});

	$(Form.Edit).validate({
		rules: {
			PromotionName: { required: true, minlength: 2, maxlength: FieldLimits.PromotionName },
			PromotionCode: { required: true, minlength: 2, maxlength: FieldLimits.PromotionCode },
			Status: { required: true }
		}	
	});
	
});