<CFPARAM name="URL.Message" default="" />
<cfscript>
	switch(URL.Message) {	
		case "Vendor.Added": {
			variables.Message = "Your vendor was added";	
			break;
		}
		case "Vendor.Updated": {
			variables.Message = "Your vendor was updated";	
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