<cfparam name="URL.EventID" default="0" />

<cfinclude template="inc_Messages.cfm" />

<script type="text/javascript" src="/Javascript/Events.js"></script>

<div class="TabbedPanels" id="TabbedPanels1">
<cfinclude template="inc_MainNavigation.cfm" />
	<div class="TabbedPanelsContentGroup">
		<div class="TabbedPanelsContent">
			<div class="formContainer">
				<div id="EventsForm" class="inputForm">
					<form action="index.cfm?event=Admin.Event.Submit" method="post" enctype="multipart/form-data" id="EventEditForm">
						<cfoutput>
						<input type="hidden" name="IsBackEnd" value="1" />
						<input type="hidden" name="EventID" id="EventID" value="<cfif Request.Events.ID GT 0>#Request.Events.ID#<cfelse>0</cfif>" />
						<input type="hidden" name="ReturnUrl" id="ReturnUrl" value="" />
						<h2 class="sectionTitle">Events Information</h2>
						<ul class="form">							
							<li>
								<label for="School">School:</label>
								#Request.SchoolBox#
							</li>
							<li>
								<label for="Category">Category:</label>
								#Request.CategoryBox#
							</li>
							<li>
								<label for="User">User:</label>
								#request.UserBox#
							</li>
							<li>
								<label for="Title">Title:</label>
								<input type="text" class="textinput" name="Title" value="#Request.Events.Title#" />
							</li>
							<li>
								<label for="Type">Description:</label>
								<textarea name="Description">#Request.Events.Description#</textarea>
							</li>
							<li>
								<label for="Organizer">Organizer:</label>
								<input type="text" class="textinput" name="Organizer" value="#Request.Events.Organizer#" />
							</li>
							<li>
								<label for="StartDate">Start Date:</label>
								<input type="text" class="textinput datepicker" name="StartDate" value="#Request.Events.StartDate#" />
							</li>
							<li>
								<label>Start Time:</label>
								#request.StartTimeBoxes#
							</li>
							<li>
								<label for="EndDate">End Date:</label>
								<input type="text" class="textinput datepicker" name="EndDate" value="#Request.Events.EndDate#" />
							</li>
							<li>
								<label>End Time:</label>
								#request.EndTimeBoxes#
							</li>
							<li>
								<label for="Image">Image:</label>
								<input type="file" class="textinput" name="Image" />
								<cfif LEN(request.ItemFullsizePath)>
									[ Creative on file:	
									<a href="#Request.ItemOriginalPath#" class="fancyUploadPreview">Original</a> |
									<a href="#Request.ItemThumbnailPath#" class="fancyUploadPreview">Thumbnail</a> |
									<a href="#Request.ItemFullsizePath#" class="fancyUploadPreview">Full size</a> 
									]
								</cfif>
							</li>
							<li>
								<label for="Status">Status:</label>
								#request.StatusBox#
							</li>
						</ul>
						<h2 class="sectionTitle">Address</h2>
						<ul class="form">							
							<li>
								<label>Title:</label>
								<input type="text" class="textinput" name="AddressTitle" value="#Request.Events.AddressTitle#" />
							</li>
							<li>
								<label>Street 1:</label>
								<input type="text" class="textinput" name="Street1" value="#Request.Events.Street1#" />
							</li>
							<li>
								<label>Street 2:</label>
								<input type="text" class="textinput" name="Street2" value="#Request.Events.Street2#" />
							</li>
							<li>
								<label>City:</label>
								<input type="text" class="textinput" name="City" value="#Request.Events.City#" />
							</li>
							<li>
								<label>State:</label>
								#Request.StateBox#
							</li>
							<li>
								<label>ZIP Code:</label>
								<input type="text" class="textinput" name="ZipCode" value="#Request.Events.ZipCode#" />
							</li>	
							<li>
								<label>Phone Number:</label>
								<input type="text" class="textinput" name="PhoneNumber" value="#Request.Events.PhoneNumber#" />
							</li>
							<li>
								<label>URL:</label>
								<input type="text" class="textinput" name="URL" value="#Request.Events.URL#" />
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
