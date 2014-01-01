Current.ListPage = "index.cfm?event=Admin.Product.Review.Management";	

Url.Search = "index.cfm?event=Admin.Product.Review.Search";
Url.Edit = "index.cfm?event=Admin.Product.Review.Information";
Url.Delete = 'index.cfm?event=Admin.Product.Review.Delete';
Url.View = "";

Form.Search = "#ProductReviewSearch";
Form.Edit = "#ProductReviewEditForm";

$().ready( function() {
	
	SetRowColors();
	
	$('a:contains("Edit")').live("click", function(){
		Current.RowID = $(this).parent('td').parent('tr').attr(Attribute.RowID);
		self.location.href = Url.Edit + "&ReviewID=" + Current.RowID + "&ProductID=" + __ProductID;				 
	});
	
	$('a:contains("Delete")').live("click", function(){
		Current.Row = $(this).parent('td').parent('tr');
		Current.RowID = $(Current.Row).attr(Attribute.RowID);
		
		if (confirm("O.K. to delete this review?")) {
			showGridLoader();
			$.get(Url.Delete, { ReviewID: Current.RowID },
	  			function(data){
					self.location.href = Current.ListPage + '&ProductID=' + __ProductID;
	  			});
		}
		return false;
	});

	$(Form.Edit).validate({
		rules: {
			IsApproved: { required: true }
		}
	}); 
	

});