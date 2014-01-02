<CFPARAM name="URL.Message" default="" />
<CFPARAM name="URL.Tab" default="0" />

<cfscript>
	switch(URL.Message) {	
		case "Event.Added": {
			variables.CurrentSubTab = 0;
			variables.Message = "Your event was added";	
			break;
		}
		case "Event.Updated": {
			variables.CurrentSubTab = 0;
			variables.Message = "Your event was updated";	
			break;
		}
		default: {
			variables.CurrentSubTab = URL.Tab;
			variables.Message = "";	
		}		
	}
</cfscript>



<script type="text/javascript">
	$().ready( function() {
		showMessage('<cfoutput>#variables.Message#</cfoutput>');
	});
</script>