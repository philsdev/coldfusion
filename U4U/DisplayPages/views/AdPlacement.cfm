<!------------------------------------------------------------------------------------------

	AdPlacement.cfm

------------------------------------------------------------------------------------------->

<cfoutput query="Request.Placement">
	<a	href="#Request.Placement.DestinationUrl#" 
		target="_blank" 
		class="adPlacement" 
		aid="#Request.Placement.ID#" 
		pid="#Request.Placement.PlacementID#">
			<img	src="/images/advertisement/#Request.Placement.ID#.#Request.Placement.FileExtension#" 
					alt="#Request.Placement.Title#" 
					width="#Request.Placement.Width#" 
					height="#Request.Placement.Height#" 
					border="0" />
	</a>
</cfoutput>