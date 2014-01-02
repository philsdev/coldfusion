<cfinclude template="inc_Messages.cfm" />

<script type="text/javascript" src="/Javascript/CommunityPosts.js"></script>

<div class="TabbedPanels" id="TabbedPanels1">
<cfinclude template="inc_MainNavigation.cfm" />
	<div class="TabbedPanelsContentGroup">
		<div class="TabbedPanelsContent">
		
			<div id="navigation" >
				<form action="javascript:void(0)" method="post" id="CommunityPostSearch">
					<h2 class="sectionTitle">Search Community Posts</h2>
					<ul class="form">
						<li>
							<label>Description:</label>
							<input type="text" name="Description" value=""  />
						</li>
						<li>
							<label>Community:</label>
							<cfoutput>#Request.CommunityBox#</cfoutput>
						</li>
						<li>
							<label>Status:</label>
							<cfoutput>#Request.StatusBox#</cfoutput>
						</li>
						<li>
							<label>Sort:</label>
							<cfoutput>#Request.SortBox#</cfoutput>
						</li>
					</ul>
					<div class="submitButtonContainer mb10">
						<button>Submit</button>
					</div>
				</form>
			</div>
			
			<div id="content">
				<div class="formContainer"><cfoutput>#Request.CommunityPostGrid#</cfoutput></div>
			</div>
			
		</div>
	</div>
</div>