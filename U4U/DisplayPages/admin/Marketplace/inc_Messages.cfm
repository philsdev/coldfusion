<CFPARAM name="URL.Message" default="" />
<CFPARAM name="URL.Tab" default="0" />

<cfscript>
	switch(URL.Message) {	
		case "Item.Added": {
			variables.CurrentSubTab = 0;
			variables.Message = "Your item was added";	
			break;
		}
		case "Item.Updated": {
			variables.CurrentSubTab = 0;
			variables.Message = "Your item was updated";	
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