<cfinclude template="inc_Messages.cfm" />

<script type="text/javascript" src="/Javascript/Testimonials.js"></script>

<div class="TabbedPanels" id="TabbedPanels1">
<cfinclude template="inc_MainNavigation.cfm" />
	<div class="TabbedPanelsContentGroup">
		<div class="TabbedPanelsContent">
		
			<div id="navigation" >
				<form action="javascript:void(0)" method="post" id="TestimonialSearch">
					<h2 class="sectionTitle">Search Testimonials</h2>
					<ul class="form">
						<li>
							<label>First Name:</label>
							<input type="text" name="FirstName" value=""  />
						</li>
						<li>
							<label>Last Name:</label>
							<input type="text" name="LastName" value=""  />
						</li>
						<li>
							<label>Approved</label>
							<cfoutput>#request.ApprovedBox#</cfoutput>
						</li>
						<li>
							<label>Sort:</label>
							<cfoutput>#Request.SortBox#</cfoutput>
						</li>
						<li>
							<label>Order:</label>
							<cfoutput>#Request.SordBox#</cfoutput>
						</li>
					</ul>
					<div class="submitButtonContainer mb10">
						<button>Submit</button>
					</div>
				</form>
			</div>
			
			<div id="content">
				<div class="formContainer"><cfoutput>#request.TestimonialGrid#</cfoutput></div>
			</div>
			
		</div>
	</div>
</div>