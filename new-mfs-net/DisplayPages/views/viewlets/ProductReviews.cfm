<div id="userReviews">
	<dl class="reviewStats">
		<cfif request.ProductReviews.RecordCount>
			<dt><strong><cfoutput>#NumberFormat(request.ProductReviewSummary.RatingCount)#</cfoutput> User Reviews</strong></dt>
			<dd>Average Rating: <span class="rating stars-<cfoutput>#NumberFormat(request.ProductReviewSummary.RatingAvg)#</cfoutput>"></span></dd>
		<cfelse>
			<dd>There are currently no reviews for this product.</dd>
		</cfif>
		<dd class="mt10">
			<a class="button fancyLink productReviewWrite">Write a review</a>
		</dd>
	</dl>
	<cfoutput query="request.ProductReviews">
		<dl>
			<dd class="rating stars-#request.ProductReviews.Rating#"></dd>
			<dd class="title">#request.ProductReviews.Title#</dd>
			<dd><strong>Pros:</strong> #request.ProductReviews.ProDescription#</dd>
			<dd><strong>Cons:</strong> #request.ProductReviews.ConDescription#</dd>
			<dd class="name2"><strong>Submitted by:</strong> #request.ProductReviews.Username#</dd>
		</dl>
	</cfoutput>
	<cfoutput>#Request.GridPagination#</cfoutput>
</div>