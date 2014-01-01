<cfscript>
	variables.LinkManager = Request.ListenerManager.GetListener( "LinkManager" );
</cfscript>
	
<cfparam name="request.Categories" default="" />

<cfif request.Categories.recordcount GT 0>
	<h2 class="sectionTitle">Categories</h2>
	<table class="existingItemsTable" width="100%" cellspacing="0" cellpadding="0">
		<thead>
			<tr>
				<th class="left">Category Name</th>
				<th>Status</th>
				<th>Functions</th>
			</tr>
		</thead>
		<tbody>
		<cfoutput query="request.Categories" group="Category1ID">
			<tr rowid="#Category1ID#" class="tree" level="1">
				<td class="level1 <cfif Level1Count GT 0>plus</cfif>">#variables.LinkManager.GetDisplayName( Category1Name )#</td>
				<td>#Status1#</td>
				<td class="functions"><a>Edit</a> | <a>Delete</a></td>      
			</tr>
			<cfoutput group="Category2ID">
				<cfif Level1Count GT 0>
					<tr rowid="#Category2ID#" class="tree" level="2" parent="#Category2Parent#" style="display:none">
						<td class="level2 <cfif Level2Count GT 0>plus</cfif>">#variables.LinkManager.GetDisplayName( Category2Name )#</td>
						<td>#Status2#</td>
						<td class="functions"><a>Edit</a> | <a>Delete</a></td>      
					</tr>	
					<cfif Level2Count GT 0>
						<cfoutput>
							<tr rowid="#Category3ID#" class="tree" level="3" parent="#Category3Parent#" grandparent="#Category2Parent#" style="display:none">
								<td class="level3">#variables.LinkManager.GetDisplayName( Category3Name )#</td>
								<td>#Status3#</td>
								<td class="functions"><a>Edit</a> | <a>Delete</a></td>      
							</tr>			
						</cfoutput>
					</cfif>
				</cfif>
			</cfoutput>
		</cfoutput>
		</tbody>                    
	</table>
<cfelse>
	<p style="margin-left:10px;">There were no categories found.</p>
</cfif>