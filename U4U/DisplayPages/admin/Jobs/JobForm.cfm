<cfparam name="URL.JobID" default="0" />

<cfinclude template="inc_Messages.cfm" />

<script type="text/javascript" src="/Javascript/Jobs.js"></script>

<div class="TabbedPanels" id="TabbedPanels1">
<cfinclude template="inc_MainNavigation.cfm" />
	<div class="TabbedPanelsContentGroup">
		<div class="TabbedPanelsContent">
			<div class="formContainer">
				<div id="JobForm" class="inputForm">
					<form action="index.cfm?event=Admin.Job.Submit" method="post" enctype="multipart/form-data" id="JobEditForm">
						<cfoutput>
						<input type="hidden" name="IsBackEnd" value="1" />
						<input type="hidden" name="JobID" id="JobID" value="<cfif Request.Job.ID GT 0>#Request.Job.ID#<cfelse>0</cfif>" />
						<input type="hidden" name="ReturnUrl" id="ReturnUrl" value="" />
						<h2 class="sectionTitle">Job Information</h2>
						<ul class="form">							
							<li>
								<label for="Category">Category:</label>
								#Request.CategoryBox#
							</li>
							<li>
								<label for="User">User:</label>
								#Request.UserBox#
							</li>
							<li>
								<label for="Title">Title:</label>
								<input type="text" class="textinput" name="Title" value="#Request.Job.Title#" />
							</li>
							<li>
								<label for="Description">Description:</label>
								<textarea name="Description">#Request.Job.Description#</textarea>
							</li>
							<li>
								<label for="CompanyName">Company Name:</label>
								<input type="text" class="textinput" name="CompanyName" value="#Request.Job.CompanyName#" />
							</li>
							<li>
								<label for="ContactName">Contact Name:</label>
								<input type="text" class="textinput" name="ContactName" value="#Request.Job.ContactName#" />
							</li>
							<li>
								<label for="ReplyEmail">Reply E-mail:</label>
								<input type="text" class="textinput" name="ReplyEmail" value="#Request.Job.ReplyEmail#" />
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
								<input type="text" class="textinput" name="AddressTitle" value="#Request.Job.AddressTitle#" />
							</li>
							<li>
								<label>Street 1:</label>
								<input type="text" class="textinput" name="Street1" value="#Request.Job.Street1#" />
							</li>
							<li>
								<label>Street 2:</label>
								<input type="text" class="textinput" name="Street2" value="#Request.Job.Street2#" />
							</li>
							<li>
								<label>City:</label>
								<input type="text" class="textinput" name="City" value="#Request.Job.City#" />
							</li>
							<li>
								<label>State:</label>
								#Request.StateBox#
							</li>
							<li>
								<label>ZIP Code:</label>
								<input type="text" class="textinput" name="ZipCode" value="#Request.Job.ZipCode#" />
							</li>	
							<li>
								<label>Phone Number:</label>
								<input type="text" class="textinput" name="PhoneNumber" value="#Request.Job.PhoneNumber#" />
							</li>
							<li>
								<label>URL:</label>
								<input type="text" class="textinput" name="URL" value="#Request.Job.URL#" />
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
