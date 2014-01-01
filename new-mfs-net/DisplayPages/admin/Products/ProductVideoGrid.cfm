<script type="text/javascript" src="/Javascript/ProductVideos.js"></script>

<div id="ProductForm" class="inputForm">
	<cfif URL.ProductID GT 0>
		<cfif request.ProductVideos.recordcount GT 0>
			<h2 class="sectionTitle">Videos</h2>
			<table class="existingItemsTable" cellspacing="0" cellpadding="0">
				<thead>
					<tr>
						<th class="left">Title</th>
						<th>Youtube Key</th>
						<th>Date Created</th>
						<th>Status</th>
						<th>Functions</th>
					</tr>
				</thead>
				<tbody>
				<cfoutput query="request.ProductVideos">
					<tr rowid="#request.ProductVideos.VideoID#">
						<td class="left">#request.ProductVideos.Title#</td>
						<td><a href="http://www.youtube.com/watch_popup?v=#request.ProductVideos.VideoKey#" class="fancyTube">#request.ProductVideos.VideoKey#</a></td>
						<td>#request.ProductVideos.DateCreated#</td>
						<td>#request.ProductVideos.Status#</td>
						<td class="functions"><a>Edit</a> | <a>Delete</a></td>      
					</tr>
				</cfoutput>
				</tbody>                    
			</table>
		<cfelse>
			<p style="margin-left:10px;">There were no videos found.</p>
		</cfif>
	<cfelse>
		<p style="margin-left:10px;">You must create and save the product details before adding videos.</p>
	</cfif>
</div>