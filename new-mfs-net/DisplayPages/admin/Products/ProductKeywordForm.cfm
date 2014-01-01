<div id="ProductForm" class="inputForm">
	<cfif URL.ProductID GT 0>
		<form action="index.cfm?event=Admin.Product.Keyword.Submit" method="post" id="ProductKeywordEditForm">
			<cfoutput>
			<input type="hidden" name="ProductID" id="ProductID" value="#URL.ProductID#" />
			<input type="hidden" name="ReturnUrl" id="ReturnUrl" value="" />
			<ul class="form">                        
				<cfloop query="request.ProductKeywords">
					<li>
						<label>Keyword #request.ProductKeywords.CurrentRow#:</label>
						<input type="text" class="textinput" name="ProductKeyword" value="#request.ProductKeywords.Keyword#" />
					</li>
				</cfloop>
				<!--- include three additional empty boxes for expansion --->
				<cfloop from="#request.ProductKeywords.Recordcount+1#" to="#request.ProductKeywords.Recordcount+3#" index="variables.ThisIndex">
					<li>
						<label>Keyword #variables.ThisIndex#:</label>
						<input type="text" class="textinput" name="ProductKeyword" value="" />
					</li>
				</cfloop>
			</ul>
			#Request.SubmitButtons#
			</cfoutput>
		</form>
	<cfelse>
		<p style="margin-left:10px;">You must create and save the product details before adding keywords.</p>
	</cfif>
</div>