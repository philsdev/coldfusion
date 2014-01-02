<CFPARAM name="URL.Message" default="" />
<CFPARAM name="URL.Tab" default="0" />

<cfscript>
	switch(URL.Message) {	
		case "Community.Added": {
			variables.CurrentSubTab = 0;
			variables.Message = "Your community was added";	
			break;
		}
		case "Community.Updated": {
			variables.CurrentSubTab = 0;
			variables.Message = "Your community was updated";	
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