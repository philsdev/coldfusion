<CFPARAM name="URL.Message" default="" />

<cfscript>
	switch(URL.Message) {	
		case "Page.Added": {
			variables.Message = "Your page was added";	
			break;
		}
		case "Page.Updated": {
			variables.Message = "Your Page was updated";	
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