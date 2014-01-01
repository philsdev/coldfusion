Current.ListPage = "index.cfm?event=Admin.Email.Management";	

Url.Search = "index.cfm?event=Admin.Email.Search";
Url.Edit = "index.cfm?event=Admin.Email.Information";
Url.Delete = 'index.cfm?event=Admin.Email.Delete';
Url.Refresh = 'index.cfm?event=Admin.Email.Refresh';
Url.CSV = 'index.cfm?event=Admin.Email.CSV';
Url.View = "";

Form.Search = "#EmailSearch";
Form.Edit = "#EmailEditForm";

$().ready( function() {
	
	SetRowColors();

//edit one email account	
	$('a:contains("Edit")').live("click", function(){
		Current.RowID = $(this).parent('td').parent('tr').attr(Attribute.RowID);
		self.location.href = Url.Edit + "&EmailID=" + Current.RowID;				 
	});

//delete one email account
	$('a:contains("Delete")').live("click", function(){
		Current.Row = $(this).parent('td').parent('tr');
		Current.RowID = $(Current.Row).attr(Attribute.RowID);
		
		if (confirm("O.K. to delete this e-mail?")) {
			showGridLoader();
			$.get(Url.Delete, { EmailID: Current.RowID },
	  			function(data){
					submitSearchForm();
	  			});
		}
		return false;
	});
	
//delete multiple emails at one time
	$('button:contains("Delete")').live("click", function(){
				
		//var thisGroupEmail = $('input[name=DeleteGroupEmail]:checked').val();
		var arr = new Array();
		 $('input:checkbox:checked').each( function() {
		   arr.push($(this).val());
		 });
		 var thisGroupEmail = arr.join(', ');
		
		//alert(thisGroupEmail); 

		if (confirm("O.K. to delete ALL selected e-mails?")) {
			showGridLoader();
			$.get(Url.Delete, { EmailID: thisGroupEmail },
	  			function(data){
					submitSearchForm();
	  			});
		}
		return false;
	});
	
//create CSV file
	$('button:contains("Create")').live("click", function(){
		var fileLocation = 'http://sheehan.amp.com/DisplayPages/admin/Emails/';
		//alert(fileLocation); 
		var arr = new Array();
		 $('input:checkbox:checked').each( function() {
		   arr.push($(this).val());
		 });
		var thisGroupEmail = arr.join(', ');
		 
		if (confirm("O.K. to Create CSV file with ALL selected e-mails?")) {
		 	showGridLoader();
			$.get(Url.CSV, { EmailID: thisGroupEmail },
	  			function(data){
					submitSearchForm();
	  			});
			window.open(fileLocation + 'EmailAddress.xls','dn','width=1,height=1,toolbar=no,top=300,left=400,right=1,scrollbars=no,locaton=1,resizable=1');
			}
		return false;
	});
	
// select all emails with checkbox
	$('#selectall').live('click', function(){

		 $("INPUT[type='checkbox']").attr('checked', true);
		/*$("INPUT[type='checkbox']").each(function(){
	        	if (this.checked == false) {
				this.checked = true;
			} else {
				this.checked = false;
			}
		});*/
	
	});

// unselect all emails with checkbox
	$('#selectnone').live('click', function(){
		$("INPUT[type='checkbox']").attr('checked', false);
	});
		 
	$(Form.Edit).validate({
		rules: {
			Email: { required: true, minlength: 2, maxlength: FieldLimits.Email },
			Emailname: { required: true, minlength: 2, maxlength: FieldLimits.Emailname },
			IsSubscribed: { required: true}
		}		
	});
	
});