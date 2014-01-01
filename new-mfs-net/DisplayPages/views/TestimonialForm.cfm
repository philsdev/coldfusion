<cfscript>
	variables.LinkManager = Request.ListenerManager.GetListener( "LinkManager" );
</cfscript>
<!------------------------------------------------------------------------------------------

	Testimonials.cfm

------------------------------------------------------------------------------------------->


<div id="breadcrumb">
	<a href="/" title="">Home</a>
	<span>Testimonials</span>
</div>
	
<!-- contentContainer nessesary for liquid layouts with static and percentage columns -->
<aside id="sidebar">
	<div class="sideModule navModule module">
		<h3>Module Title</h3>
		<div class="moduleContent">
			<p>Put sidebar content here.</p>
		</div>
	</div>	
</aside>

	<div id="contentContainer">
	<div id="content" class="contentSection">
		<div class="post">
			<article class="entry-content ">
				<header class="articleHeader">
					<h1>Testimonials</h1>
				</header>
				
				
			<cfif findnocase('thanks', url.event )>
			<h3>Thank you for submitting a Testimonial.</h3>
			</cfif>
		
        	<section id="testimonialsList">
            	
                <ul class="contentList list_testimonials">
				<cfoutput query="Request.Testimonials">
					<li><blockquote><p>&ldquo;#Request.Testimonials.Description#&rdquo;</p>
					<cite>- #Request.Testimonials.FirstName# #Request.Testimonials.LastName#</cite>
					</blockquote></li>
				</cfoutput>
                </ul>
            </section>
							<div class="formContainer">
				<form method="post" action="/testimonials-thank-you.html" id="TestimonialForm">
					<input type="hidden" name="TestimonialID" id="TestimonialID" value="0" />
					<input type="hidden" name="ReturnUrl" id="ReturnUrl" value="testimonials.html" />
					<input type="hidden" name="IsApproved" id="IsApproved" value="0" />
					<input type="hidden" name="FrontEnd" id="FrontEnd" value="1" />
					
					<ul class="form vhh">
				
						<li class="required">
							<label>First Name:</label>
							<input type="text" class="textinput limitedField" name="FirstName" id="FirstName" value="">
						</li>
						<li>
							<label>Last Name:</label>
							<input type="text" class="textinput limitedField" name="LastName" id="LastName" value="">
						</li>
						<li>
							<label>Location:</label>
							<input type="text" class="textinput limitedField" name="Location" id="Location" value="">
						</li>
						<li class="required">
							<label>Comments:</label>
							<textarea class="textinput" name="Description"></textarea>
						</li>
						<li>
							<a class="button grayButton" id="TestimonialAdd">Submit Testimonial</a>
						</li>
					</ul>
				</form>
				</div>
			</article>
		</div>
	</div>
</div>

