<CFPARAM name="URL.Message" default="" />
<CFPARAM name="URL.Tab" default="0" />

<cfscript>
	switch(URL.Message) {	
		case "Account.Added": {
			variables.CurrentSubTab = 0;
			variables.Message = "Your account was added";	
			break;
		}
		case "Account.Updated": {
			variables.CurrentSubTab = 0;
			variables.Message = "Your account was updated";	
			break;
		}
		case "Account.Card.Added": {
			variables.CurrentSubTab = 3;
			variables.Message = "Your card was added";	
			break;
		}
		case "Account.Card.Updated": {
			variables.CurrentSubTab = 3;
			variables.Message = "Your card was updated";	
			break;
		}
		case "Account.Location.Added": {
			variables.CurrentSubTab = 1;
			variables.Message = "Your location was added";	
			break;
		}
		case "Account.Location.Updated": {
			variables.CurrentSubTab = 1;
			variables.Message = "Your location was updated";	
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