<CFPARAM name="URL.Message" default="" />
<CFPARAM name="URL.Tab" default="0" />

<cfscript>
	switch(URL.Message) {	
		case "Deal.Added": {
			variables.CurrentSubTab = 0;
			variables.Message = "Your deal was added";	
			break;
		}
		case "Deal.Updated": {
			variables.CurrentSubTab = 0;
			variables.Message = "Your deal was updated";	
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