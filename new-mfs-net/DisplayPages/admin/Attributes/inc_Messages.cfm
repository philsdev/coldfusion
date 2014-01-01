<CFPARAM name="URL.Message" default="" />
<cfscript>
	switch(URL.Message) {	
		case "Attribute.Added": {
			variables.Message = "Your attribute was added";	
			break;
		}
		case "Attribute.Updated": {
			variables.Message = "Your attribute was updated";	
			break;
		}
		case "Attribute.Deleted": {
			variables.Message = "Your attribute was deleted";	
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