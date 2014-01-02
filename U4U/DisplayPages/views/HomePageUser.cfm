<!------------------------------------------------------------------------------------------

	HomePageUser.cfm

------------------------------------------------------------------------------------------->

<div id="content">
	<cfoutput>#Request.UserRecentActivity#</cfoutput>
	<cfoutput>#Request.LatestActivityWrapper#</cfoutput>
</div>

<div id="sidebar">
	
	<cfinclude template="#Request.ViewManager.getViewPath('Links.AccountDetails')#" />
	<cfinclude template="#Request.ViewManager.getViewPath('Links.Account')#" />	
	<cfinclude template="#Request.ViewManager.getViewPath('Links.Events')#" />
    <cfinclude template="#Request.ViewManager.getViewPath('Links.StudyGroups')#" />
    <cfinclude template="#Request.ViewManager.getViewPath('Links.Marketplace')#" />
    <cfinclude template="#Request.ViewManager.getViewPath('Links.Community')#" />	
	<cfinclude template="#Request.ViewManager.getViewPath('Links.Jobs')#" />	
	<cfinclude template="#Request.ViewManager.getViewPath('Links.Advertisements')#" />	
	

	<div class="module">
		<div class="moduleContent">
			<cfoutput>#Request.AdPlacementRight#</cfoutput>
		</div>
	</div>
	
</div>

<script type="text/javascript">

	$().ready( function() {
	
		GetLatestActivity('',1);
	
	});
	
</script>