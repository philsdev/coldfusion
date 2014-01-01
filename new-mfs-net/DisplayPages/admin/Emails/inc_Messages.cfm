<CFPARAM name="URL.Message" default="" />
<CFPARAM name="URL.Tab" default="0" />

<cfscript>
	switch(URL.Message) {	
		case "Email.Added": {
			variables.CurrentSubTab = 0;
			variables.Message = "Your e-mail was added";	
			break;
		}
		case "Email.Updated": {
			variables.CurrentSubTab = 0;
			variables.Message = "Your e-mail was updated";	
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