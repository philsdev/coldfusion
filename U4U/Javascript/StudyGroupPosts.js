Current.ListPage = "index.cfm?event=Admin.StudyGroupPost.Management";	

Url.Search = "index.cfm?event=Admin.StudyGroupPost.Search";
Url.Edit = "index.cfm?event=Admin.StudyGroupPost.Information";
Url.Delete = "index.cfm?event=Admin.StudyGroupPost.Delete";
Url.View = "";

Form.Search = "#StudyGroupPostSearch";
Form.Edit = "#StudyGroupPostEditForm";

$().ready( function() {	
	
	SetRowColors();
	
	$('a:contains("Edit")').live("click", function(){
		Current.RowID = $(this).parent('td').parent('tr').attr(Attribute.RowID);
		self.location.href = Url.Edit + "&StudyGroupPostID=" + Current.RowID;						 
	});
	
	$('a:contains("Delete")').live("click", function(){
		Current.Row = $(this).parent('td').parent('tr');
		Current.RowID = $(Current.Row).attr(Attribute.RowID);		
		if (confirm("O.K. to delete this study group post?")) {
			showGridLoader();
			$.get(Url.Delete, { StudyGroupPostID: Current.RowID },
	  			function(data){
					submitSearchForm();
	  			});
		}
		return false;
	});
	
	$('#SchoolOptions').change( function() {
		toggleStudyGroupOptions();
	});
	
	$('#CourseOptions').live( 'change', function() {
		toggleStudyGroupPostOptions();
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
