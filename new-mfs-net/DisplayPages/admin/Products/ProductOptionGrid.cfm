<script type="text/javascript" src="/Javascript/ProductOptions.js"></script>

<div id="ProductForm" class="inputForm">
	<cfif URL.ProductID GT 0>
		<cfif request.Options.recordcount GT 0>
			<h2 class="sectionTitle">Options</h2>
			<table class="existingItemsTable" width="100%" cellspacing="0" cellpadding="0" border="0">
				<thead>
					<tr>
						<th class="left">Attribute Name</th>
						<th class="left">Option Name</th>
						<th>Required?</th>
						<th>Functions</th>
					</tr>
				</thead>
				<tbody>
				<cfoutput query="request.Options" group="ProductAttributeID">
					<tr rowid="#ProductAttributeID#" class="tree" level="1">
						<td class="level1 plus"><strong>#request.Options.ProductAttributeName#</strong></td>
						<td colspan="3">&nbsp;</th>
					</tr>
					<cfoutput>
					<tr rowid="#request.Options.OptionID#" class="tree" level="2" parent="#ProductAttributeID#" style="display:none" >
						<td class="level2">&nbsp;</td>
						<td class="left">#request.Options.OptionName#</td>
						<td>#YesNoFormat( request.Options.Required )#</td>
						<td class="functions"><a>Edit</a> | <a>Delete</a></td>      
					</tr>
					</cfoutput>
				</cfoutput>
				</tbody>                    
			</table>
		<cfelse>
			<p style="margin-left:10px;">There were no Options found.</p>
		</cfif>
	<cfelse>
		<p style="margin-left:10px;">You must create and save the product details before adding options.</p>
	</cfif>
</div>
<p>
<button>Add New Option</button>			