<CFPARAM name="URL.Message" default="" />
<cfscript>
	switch(URL.Message) {	
		case "Customer.Added": {
			variables.Message = "Your Customer was added";	
			break;
		}
		case "Customer.Updated": {
			variables.Message = "Your Customer was updated";	
			break;
		}
		case "Customer.Delete": {
			variables.Message = "Your Customer was deleted";	
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