
<script type="text/javascript" src="/Javascript/Attributes.js"></script>

<div id="ProductForm" class="inputForm">
	<cfif URL.ProductID GT 0>
		<cfif request.Attribute.RecordCount GT 0>
			<h2 class="sectionTitle">Attributes</h2>
			<table class="existingItemsTable" width="100%" cellspacing="0" cellpadding="0">
				<thead>
					<tr>
						<th class="left">Attribute Name</th>
						<th>Active?</th>
						<th>Functions</th>
					</tr>
				</thead>
				<tbody>
				<cfoutput query="request.Attribute" group="GroupID">
					<tr rowid="#request.Attribute.ProductAttributeID#">
						<td class="left">#request.Attribute.ProductAttributeName#</td>
						<td>#YesNoFormat( request.Attribute.ProductAttributeStatus )#</td>
						<td class="functions"><a>Edit</a> | <a>View Options</a> | <a>Delete</a></td>      
					</tr>
				</cfoutput>
				<tr rowid="0">
						<td class="left">Add New Attribute</td>
						<td></td>
						<td class="functions"><a>Edit</a></td>      
					</tr>
				</tbody>                    
			</table>
		<cfelse>
			<p style="margin-left:10px;">There were no attributes found.</p>
		</cfif>
	<cfelse>
		<p style="margin-left:10px;">You must create and save the product details before adding attributes.</p>
	</cfif>
</div>

<!--- TODO: add pagination --->