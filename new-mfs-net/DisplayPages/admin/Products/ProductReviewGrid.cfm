<script type="text/javascript" src="/Javascript/ProductReviews.js"></script>

<div id="ProductForm" class="inputForm">
	<cfif URL.ProductID GT 0>
		<cfif request.ProductReviews.recordcount GT 0>
			<h2 class="sectionTitle">Reviews</h2>
			<table class="existingItemsTable" width="100%" cellspacing="0" cellpadding="0">
				<thead>
					<tr>
						<th class="left">Title</th>
						<th>Username</th>
						<th>Rating</th>
						<th>Date Created</th>
						<th>Is Approved?</th>
						<th>Functions</th>
					</tr>
				</thead>
				<tbody>
				<cfoutput query="request.ProductReviews">
					<tr rowid="#request.ProductReviews.ReviewID#">
						<td class="left">#request.ProductReviews.Title#</td>
						<td>#request.ProductReviews.Username#</td>
						<td>#request.ProductReviews.Rating#</td>
						<td>#request.ProductReviews.DateCreated#</td>
						<td>#YesNoFormat( request.ProductReviews.IsApproved )#</td>
						<td class="functions"><a>Edit</a> | <a>Delete</a></td>      
					</tr>
				</cfoutput>
				</tbody>                    
			</table>
		<cfelse>
			<p style="margin-left:10px;">There were no reviews found.</p>
		</cfif>
	<cfelse>
		<p style="margin-left:10px;">You must create and save the product details before adding reviews.</p>
	</cfif>
</div>

<!--- TODO: add pagination --->