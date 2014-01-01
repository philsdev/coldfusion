<script type="text/javascript" src="/Javascript/ProductVideos.js"></script>

<div id="ProductVideoForm" class="inputForm">
	<form action="index.cfm?event=Admin.Product.Video.Submit" method="post" enctype="multipart/form-data" id="ProductVideoEditForm">
		<cfoutput>
		<input type="hidden" name="ProductID" id="ProductID" value="#URL.ProductID#" />
		<input type="hidden" name="VideoID" id="VideoID" value="<cfif Request.ProductVideo.VideoID GT 0>#Request.ProductVideo.VideoID#<cfelse>0</cfif>" />
		<input type="hidden" name="ReturnUrl" id="ReturnUrl" value="" />
		<ul class="form">    
			<li>
				<label>Title:</label>
				<input type="text" class="textinput limitedField" name="ProductVideoTitle" id="ProductVideoTitle" value="#request.ProductVideo.Title#" />
			</li>
			<li>
				<label>Youtube Key:</label>
				<input type="text" class="textinput limitedField" name="ProductVideoKey" id="ProductVideoKey" value="#request.ProductVideo.VideoKey#" />
				<a class="fancyTubePreview" style="padding-left:10px">Preview this Video</a>
			</li>
			<li>
				<label>Status:</label>
				#request.StatusBox#
			</li>
		</ul>
		#Request.SubmitButtons#
		</cfoutput>
	</form>
</div>