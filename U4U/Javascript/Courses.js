Current.ListPage = "index.cfm?event=Admin.Course.Management";	

Url.Search = "index.cfm?event=Admin.Course.Search";
Url.Edit = "index.cfm?event=Admin.Course.Information";
Url.Delete = "index.cfm?event=Admin.Course.Delete";
Url.View = "";

Form.Search = "#CourseSearch";
Form.Edit = "#CourseEditForm";

$().ready( function() {	
	
	SetRowColors();
	
	$('a:contains("Edit")').live("click", function(){
		Current.RowID = $(this).parent('td').parent('tr').attr(Attribute.RowID);
		self.location.href = Url.Edit + "&CourseID=" + Current.RowID;						 
	});
	
	$('a:contains("Delete")').live("click", function(){
		Current.Row = $(this).parent('td').parent('tr');
		Current.RowID = $(Current.Row).attr(Attribute.RowID);		
		if (confirm("O.K. to delete this course?")) {
			showGridLoader();
			$.get(Url.Delete, { CourseID: Current.RowID },
	  			function(data){
					submitSearchForm();
	  			});
		}
		return false;
	});
		
	$(Form.Edit).validate({
		rules: {
			School: { required: true },
			Title: { required: true, minlength: 2, maxlength: 50 },
			Description: { required: true, minlength: 4 },
			Status: { required: true }
		},
		errorPlacement: function(error, element) {
			error.insertAfter(element);
		},
		errorElement: "span"
	});
	
});
