<script type="text/javascript" src="/Javascript/ProductReviews.js"></script>

<div id="ProductForm" class="inputForm">
	<form action="index.cfm?event=Admin.Product.Review.Submit" method="post" id="ProductReviewEditForm">
		<cfoutput>
		<input type="hidden" name="ReviewID" id="ReviewID" value="<cfif request.ProductReviewDetails.ReviewID GT 0>#request.ProductReviewDetails.ReviewID#<cfelse>0</cfif>" />
		<input type="hidden" name="ProductID" id="ProductID" value="#request.ProductReviewDetails.ProductID#" />
		
		<input type="hidden" name="ReturnUrl" id="ReturnUrl" value="" />
		<ul class="form">                        
			<li>
				<label>Review Title:</label>
				#request.ProductReviewDetails.Title#
			</li>
			<li>
				<label>Review UserName:</label>
				#request.ProductReviewDetails.Username#
			</li>
			<li>
				<label>Rating:</label>
				#request.ProductReviewDetails.Rating#
			</li>
			<li>
				<label>Pros:</label>
				#request.ProductReviewDetails.ProDescription#&nbsp;
			</li>
			<li>
				<label>Cons:</label>
				#request.ProductReviewDetails.ConDescription#&nbsp;
			</li>
			<li>
				<label>Is Approved:</label>
				#request.IsApproved#
			</li>
			
		</ul>
		#Request.SubmitButtons#
		</cfoutput>
	</form>
</div>