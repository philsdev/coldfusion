<CFPARAM name="URL.Message" default="" />
<cfscript>
	switch(URL.Message) {	
		case "Administrator.Added": {
			variables.Message = "Your administrator was added";	
			break;
		}
		case "Administrator.Updated": {
			variables.Message = "Your administrator was updated";	
			break;
		}
		default: {
			variables.Message = "";	
		}		
	}
</cfscript>

<script type="text/javascript">
	$().ready( function() {
		showMessage('<cfoutput>#variables.Message#</cfoutput>');
	});
</script>