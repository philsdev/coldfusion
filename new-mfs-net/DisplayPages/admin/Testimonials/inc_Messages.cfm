<CFPARAM name="URL.Message" default="" />
<cfscript>
	switch(URL.Message) {	
		case "Testimonial.Added": {
			variables.Message = "Your testimonial was added";	
			break;
		}
		case "Testimonial.Updated": {
			variables.Message = "Your testimonial was updated";	
			break;
		}
		case "Testimonial.Delete": {
			variables.Message = "Your testimonial was deleted";	
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