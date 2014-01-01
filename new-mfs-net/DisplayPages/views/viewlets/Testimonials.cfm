<cfscript>
	variables.TestimonialManager = Request.ListenerManager.GetListener( "TestimonialManager" );
	variables.Testimonials = variables.TestimonialManager.GetDisplayTestimonials();
</cfscript>

<h3>&ldquo;We Deliver what others promise and will not be undersold&rdquo;</h3>
<div class="cycleFade">
	<cfoutput query="variables.Testimonials">
		<blockquote>
			<p>&ldquo;#variables.Testimonials.Description#&rdquo;</p>
			<p>- #variables.Testimonials.FirstName# #variables.Testimonials.LastName#</p>
		</blockquote>
	</cfoutput>
</div>