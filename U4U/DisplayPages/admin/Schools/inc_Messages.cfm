<CFPARAM name="URL.Message" default="" />
<CFPARAM name="URL.Tab" default="0" />

<cfscript>
	switch(URL.Message) {	
		case "School.Added": {
			variables.CurrentSubTab = 0;
			variables.Message = "Your school was added";	
			break;
		}
		case "School.Updated": {
			variables.CurrentSubTab = 0;
			variables.Message = "Your school was updated";	
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