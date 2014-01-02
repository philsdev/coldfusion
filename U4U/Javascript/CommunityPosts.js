Current.ListPage = "index.cfm?event=Admin.CommunityPost.Management";	

Url.Search = "index.cfm?event=Admin.CommunityPost.Search";
Url.Edit = "index.cfm?event=Admin.CommunityPost.Information";
Url.Delete = "index.cfm?event=Admin.CommunityPost.Delete";
Url.View = "";

Form.Search = "#CommunityPostSearch";
Form.Edit = "#CommunityPostEditForm";

$().ready( function() {	
	
	SetRowColors();
	
	$('a:contains("Edit")').live("click", function(){
		Current.RowID = $(this).parent('td').parent('tr').attr(Attribute.RowID);
		self.location.href = Url.Edit + "&CommunityPostID=" + Current.RowID;						 
	});
	
	$('a:contains("Delete")').live("click", function(){
		Current.Row = $(this).parent('td').parent('tr');
		Current.RowID = $(Current.Row).attr(Attribute.RowID);		
		if (confirm("O.K. to delete this community post?")) {
			showGridLoader();
			$.get(Url.Delete, { CommunityPostID: Current.RowID },
	  			function(data){
					submitSearchForm();
	  			});
		}
		return false;
	});
		
	$(Form.Edit).validate({
		rules: {
			Description: { required: true, minlength: 4 },
			Status: { required: true }
		},
		errorPlacement: function(error, element) {
			error.insertAfter(element);
		},
		errorElement: "span"
	});
	
});
