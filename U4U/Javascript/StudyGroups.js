Current.ListPage = "index.cfm?event=Admin.StudyGroup.Management";	

Url.Search = "index.cfm?event=Admin.StudyGroup.Search";
Url.Edit = "index.cfm?event=Admin.StudyGroup.Information";
Url.Delete = "index.cfm?event=Admin.StudyGroup.Delete";
Url.View = "";

Form.Search = "#StudyGroupSearch";
Form.Edit = "#StudyGroupEditForm";

$().ready( function() {	
	
	SetRowColors();
	
	$('a:contains("Edit")').live("click", function(){
		Current.RowID = $(this).parent('td').parent('tr').attr(Attribute.RowID);
		self.location.href = Url.Edit + "&StudyGroupID=" + Current.RowID;						 
	});
	
	$('a:contains("Delete")').live("click", function(){
		Current.Row = $(this).parent('td').parent('tr');
		Current.RowID = $(Current.Row).attr(Attribute.RowID);		
		if (confirm("O.K. to delete this study group?")) {
			showGridLoader();
			$.get(Url.Delete, { StudyGroupID: Current.RowID },
	  			function(data){
					submitSearchForm();
	  			});
		}
		return false;
	});
	
	$('#SchoolOptions').change( function() {
		toggleStudyGroupOptions();
	});
		
	$(Form.Edit).validate({
		rules: {
			Title: { required: true, minlength: 2, maxlength: 50 },
			Description: { required: true, minlength: 4 },
			Course: { required: true },
			User: {required: true },
			Status: { required: true }
		},
		errorPlacement: function(error, element) {
			error.insertAfter(element);
		},
		errorElement: "span"
	});
	
});


