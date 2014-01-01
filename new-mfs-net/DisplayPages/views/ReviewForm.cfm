<cfscript>
	variables.LinkManager = Request.ListenerManager.GetListener( "LinkManager" );
</cfscript>

<div class="formContainer">
	<ul class="form">
		<li>
			<label>Product:</label>
			<cfoutput>#variables.LinkManager.GetDisplayName( Request.ProductDetails.ProductName )#</cfoutput>
		</li>
		<li>
			<label>Rating:</label>
			<input type="radio" name="Rating" value="5" /> 5: Great
		</li>
		<li>
			<label>&nbsp;</label>
			<input type="radio" name="Rating" value="4" /> 4: Above Average
		</li>
		<li>
			<label>&nbsp;</label>
			<input type="radio" name="Rating" value="3" /> 3: Average
		</li>
		<li>
			<label>&nbsp;</label>
			<input type="radio" name="Rating" value="2" /> 2: Below Average
		</li>
		<li>
			<label>&nbsp;</label>
			<input type="radio" name="Rating" value="1" /> 1: Poor
		</li>
		<li>
			<label>Summary:</label>
			<input type="text" name="Summary" />
		</li>
		<li>
			<label>Comments:</label>
			<input type="text" name="Comments" />
		</li>
		<li>
			<label>Name:</label>
			<input type="text" name="FullName" />
		</li>
		<li>
			<label>&nbsp;</label>
			<input type="checkbox" name="ShowReview" value="1" /> ShowReview
		</li>
		<li>
			<label>Email:</label>
			<input type="text" name="Email" />
		</li>
		<li>
			<label>&nbsp;</label>
			<input type="checkbox" name="SignMeUp" value="1" />SignMeUp
		</li>
	</ul>
	<a class="button fancyLink SubmitReview">Submit Review</a>
</div>