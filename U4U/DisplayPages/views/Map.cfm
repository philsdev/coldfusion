<!------------------------------------------------------------------------------------------

	Map.cfm

------------------------------------------------------------------------------------------->

<style type="text/css">
	#map { width: 500px; height: 375px; border: 1px solid black; background-color: white; }
</style>

<cfset variables.Message = "" />
<cfset variables.Unavailable = "Sorry, a map is not available at this time." />

<cfif NOT Request.Address.RecordCount>
	<cfset variables.Message = variables.Unavailable />
<cfelse>

	<cfset VARIABLES.Address = REQUEST.Address.Street1 & ", " & REQUEST.Address.City & ", " & REQUEST.Address.State & ", " & REQUEST.Address.ZipCode /> 

	<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
	<script type="text/javascript">
		
		$().ready( function() {
			renderMap('<cfoutput>#JSStringFormat(VARIABLES.Address)#</cfoutput>');
		});

	</script>
	
</cfif>

<div id="content">
	<header class="contentListHeader clearfix">
		<h1>Map</h1>
	</header>

	<div id="map"><cfoutput>#variables.Message#</cfoutput></div>
</div>

