<CFPARAM name="URL.Message" default="" />
<CFPARAM name="URL.Tab" default="0" />

<cfscript>
	switch(URL.Message) {	
		case "Course.Added": {
			variables.CurrentSubTab = 0;
			variables.Message = "Your course was added";	
			break;
		}
		case "Course.Updated": {
			variables.CurrentSubTab = 0;
			variables.Message = "Your course was updated";	
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