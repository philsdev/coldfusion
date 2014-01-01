<cfparam name="URL.TestimonialID" default="0" />

<cfinclude template="inc_Messages.cfm" />

<script type="text/javascript" src="/Javascript/Testimonials.js"></script>

<div class="TabbedPanels" id="TabbedPanels1">
<cfinclude template="inc_MainNavigation.cfm" />
	<div class="TabbedPanelsContentGroup">
		<div class="TabbedPanelsContent">
			<div class="formContainer">       		                 
				<div id="TestimonialForm" class="inputForm">
					<form action="index.cfm?event=Admin.Testimonial.Submit" method="post" id="TestimonialEditForm">
						<cfoutput>
						<input type="hidden" name="TestimonialID" id="TestimonialID" value="<cfif Request.Testimonial.TestimonialID GT 0>#Request.Testimonial.TestimonialID#<cfelse>0</cfif>" />
						<input type="hidden" name="ReturnUrl" id="ReturnUrl" value="" />
						<ul class="form">                        
							<li class="required">
								<label>First Name:</label>
								<input type="text" class="textinput limitedField" name="FirstName" id="FirstName" value="#Request.Testimonial.FirstName#">
							</li>
							<li>
								<label>Last Name:</label>
								<input type="text" class="textinput limitedField" name="LastName" id="LastName" value="#Request.Testimonial.LastName#">
							</li>
							<li>
								<label>Location:</label>
								<input type="text" class="textinput limitedField" name="Location" id="Location" value="#Request.Testimonial.Location#">
							</li>
							<li class="required">
								<label>Description:</label>
								<textarea class="textinput" name="Description">#request.Testimonial.Description#</textarea>
							</li>
							<li class="required">
								<label>Approved:</label>
								#request.ApprovedBox#
							</li>
							<li>
								<label>Date Created:</label>
								#DateFormat(request.Testimonial.DateCreated, 'mm/dd/yyyy')#&nbsp;
							</li>
							<li>
								<label>Date Last Modified:</label>
								#DateFormat(request.Testimonial.DateModified, 'mm/dd/yyyy')#&nbsp;
							</li>
						</ul>
						#Request.SubmitButtons#
						</cfoutput>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>