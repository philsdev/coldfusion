<cfparam name="URL.CommunityPostID" default="0" />

<!--- creating posts form the admin is now allowed, therefore form is only relevant for editing posts --->
<cfif URL.CommunityPostID EQ 0>
	<cflocation url="index.cfm?event=Admin.CommunityPost.Management" />
</cfif>


<cfinclude template="inc_Messages.cfm" />

<script type="text/javascript" src="/Javascript/CommunityPosts.js"></script>

<div class="TabbedPanels" id="TabbedPanels1">
<cfinclude template="inc_MainNavigation.cfm" />
	<div class="TabbedPanelsContentGroup">
		<div class="TabbedPanelsContent">
			<div class="formContainer">
				<div id="CommunityPostForm" class="inputForm">
					<form action="index.cfm?event=Admin.CommunityPost.Submit" method="post" id="CommunityPostEditForm">
						<cfoutput>
						<input type="hidden" name="CommunityPostID" id="CommunityPostID" value="<cfif Request.CommunityPost.ID GT 0>#Request.CommunityPost.ID#<cfelse>0</cfif>" />
						<input type="hidden" name="ReturnUrl" id="ReturnUrl" value="" />
						<h2 class="sectionTitle">Study Group Information</h2>
						<ul class="form">	
							<li>
								<label>User:</label>
								<span>#Request.CommunityPost.Username#</span>
							</li>
							<li>
								<label for="Type">Description:</label>
								<textarea name="Description">#Request.CommunityPost.Description#</textarea>
							</li>
							<li>
								<label for="Status">Status:</label>
								#request.StatusBox#
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
