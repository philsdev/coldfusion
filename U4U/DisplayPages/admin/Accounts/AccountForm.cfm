<cfparam name="URL.AccountID" default="0" />

<cfinclude template="inc_Messages.cfm" />

<script type="text/javascript" src="/Javascript/Accounts.js"></script>

<div class="TabbedPanels" id="TabbedPanels1">
<cfinclude template="inc_MainNavigation.cfm" />
	<div class="TabbedPanelsContentGroup">
		<div class="TabbedPanelsContent">
			<div class="formContainer">
				<div id="AccountForm" class="inputForm">
					<form action="index.cfm?event=Admin.Account.Submit" method="post" enctype="multipart/form-data" id="AccountEditForm">
						<cfoutput>
						<input type="hidden" name="AccountID" id="AccountID" value="<cfif Request.Account.ID GT 0>#Request.Account.ID#<cfelse>0</cfif>" />
						<input type="hidden" name="ReturnUrl" id="ReturnUrl" value="" />
						<h2 class="sectionTitle">User Information</h2>
						<ul class="form">
							<li>
								<label for="School">School:</label>
								#Request.SchoolBox#
							</li>
							<li>
								<label for="FirstName">First Name:</label>
								<input type="text" class="textinput" name="FirstName" id="FirstName" value="#Request.Account.FirstName#" />
							</li>
							<li>
								<label for="LastName">Last Name:</label>
								<input type="text" class="textinput" name="LastName" id="LastName" value="#Request.Account.LastName#" />
							</li>										
							<li>
								<label for="Street1">E-mail:</label>
								<input type="text" class="textinput" name="Email" id="Email" value="#Request.Account.Email#" />
							</li>
							<li>
								<label for="Username">Username:</label>
								<input type="text" class="textinput" name="Username" id="Username" value="#Request.Account.Username#" />
							</li>
							<li>
								<label for="Password">Password:</label>
								<input type="password" class="textinput" name="Password" id="Password" />
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
								<label>Signature:</label>
								<textarea name="Signature">#Request.Account.Signature#</textarea>
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
								<input type="text" class="textinput" name="AddressTitle" value="#Request.Account.AddressTitle#" />
							</li>
							<li>
								<label>Street 1:</label>
								<input type="text" class="textinput" name="Street1" value="#Request.Account.Street1#" />
							</li>
							<li>
								<label>Street 2:</label>
								<input type="text" class="textinput" name="Street2" value="#Request.Account.Street2#" />
							</li>
							<li>
								<label>City:</label>
								<input type="text" class="textinput" name="City" value="#Request.Account.City#" />
							</li>
							<li>
								<label>State:</label>
								#Request.StateBox#
							</li>
							<li>
								<label>ZIP Code:</label>
								<input type="text" class="textinput" name="ZipCode" value="#Request.Account.ZipCode#" />
							</li>	
							<li>
								<label>Phone Number:</label>
								<input type="text" class="textinput" name="PhoneNumber" value="#Request.Account.PhoneNumber#" />
							</li>
							<li>
								<label>URL:</label>
								<input type="text" class="textinput" name="URL" value="#Request.Account.URL#" />
							</li>
						</ul>
						<h2 class="sectionTitle">Additional Permissions</h2>
						<ul class="form">							
							<li>
								<label>Advertiser:</label>
								#Request.AdvertiserBox#
							</li>
							<li>
								<label>Dealer:</label>
								#Request.DealerBox#
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
