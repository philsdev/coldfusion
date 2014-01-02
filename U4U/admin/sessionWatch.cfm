
<!---
Author:		Greg Alton	(greg@cfdev.com)
Company:	CFDev.com	
Date: 		10/01/2001

--->


<cfif IsDefined("url.sessionwatch")>
<html>
<head><title></title></head>
<body>
<table width="100%"><tr><td align="center"><form>
Session extended.<br>
<input type="submit" onClick="window.close();" value="OK">
</form></td></tr>
</table>
<script>
window.close();
</script>
</body></html>
<cfabort>
</cfif>

<cfparam name="attributes.launchTime" default="20">

<cfoutput>
<cfset thisLaunchTime = (attributes.launchTime * 60 * 1000)>

<script language="Javascript">
	function watchSession() {
		timerID = setTimeout("refreshSession()", #thisLaunchTime#);
	}
	
	function refreshSession() {
		if (confirm("Your session will timeout in 60 seconds. Would you like to extend the session?")) {
			
			
			serverCall = window.open(document.location.href.split("?")[0]+"?sessionwatch=1&<cfif IsDefined("URLTOKEN")>#URLToken#</cfif>", "RefreshSession", "width=1, height=1");
			watchSession();
		}
	}

	watchSession();
</script>
</cfoutput>