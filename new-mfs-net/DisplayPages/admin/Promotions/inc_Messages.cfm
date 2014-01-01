<CFPARAM name="URL.Message" default="" />
<cfscript>
	switch(URL.Message) {	
		case "Promotion.Added": {
			variables.Message = "Your promotion was added";	
			break;
		}
		case "Promotion.Updated": {
			variables.Message = "Your promotion was updated";	
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