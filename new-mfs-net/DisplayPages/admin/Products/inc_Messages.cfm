<CFPARAM name="URL.Message" default="" />
<cfscript>
	switch(URL.Message) {	
		case "Product.Added": {
			variables.Message = "Your product was added";	
			break;
		}
		case "Product.Updated": {
			variables.Message = "Your product was updated";	
			break;
		}
		case "Product.Upsell.Updated": {
			variables.Message = "Your product upsells were updated";	
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