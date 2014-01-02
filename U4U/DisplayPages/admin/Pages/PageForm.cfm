<cfparam name="URL.PageID" default="0" />

<cfinclude template="inc_Messages.cfm" />

<script type="text/javascript" src="/Javascript/Pages.js"></script>
<script type="text/javascript" src="/ckeditor/ckeditor.js"></script>
<script type="text/javascript" src="/ckeditor/adapters/jquery.js"></script>

<div class="TabbedPanels" id="TabbedPanels1">
<cfinclude template="inc_MainNavigation.cfm" />
	<div class="TabbedPanelsContentGroup">
		<div class="TabbedPanelsContent">
			<div class="formContainer">
				<div id="PageForm" class="inputForm">
					<form action="index.cfm?event=Admin.Page.Submit" method="post" id="PageEditForm">
						<cfoutput>
						<input type="hidden" name="IsBackEnd" value="1" />
						<input type="hidden" name="PageID" id="PageID" value="<cfif Request.Page.ID GT 0>#Request.Page.ID#<cfelse>0</cfif>" />
						<input type="hidden" name="ReturnUrl" id="ReturnUrl" value="" />
						<h2 class="sectionTitle">Page Information</h2>
						<ul class="form">
							<li>
								<label for="PageTitle">Page Title:</label>
								<input type="text" class="textinput" name="PageTitle" id="PageTitle" value="#Request.Page.PageTitle#" />
							</li>
							<li>
								<label for="PageTitle">Search Title:</label>
								<input type="text" class="textinput" name="SearchTitle" id="SearchTitle" value="#Request.Page.SearchTitle#" />
							</li>
							<li>
								<label for="PageTitle">Page Description:</label>
								<textarea name="PageDescription" id="PageDescription">#Request.Page.PageDescription#</textarea>
							</li>
							<li>
								<label for="PageTitle">Page Body:</label>
								<div class="EditorContainer">
									<textarea name="PageBody" id="PageBody">#Request.Page.PageBody#</textarea>
								</div>
							</li>
							<li>
								<label for="MetaTitle">Meta Title:</label>
								<textarea name="MetaTitle" id="MetaTitle">#Request.Page.MetaTitle#</textarea>
							</li>
							<li>
								<label for="MetaDescription">Meta Description:</label>
								<textarea name="MetaDescription" id="MetaDescription">#Request.Page.MetaDescription#</textarea>
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

<script type="text/javascript">
	$().ready( function() {
		$('#PageBody').ckeditor(
			function() {}
		);	
	});
</script>
