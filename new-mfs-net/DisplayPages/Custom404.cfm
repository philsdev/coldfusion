<div id="contentContainer">
	<div id="content" class="contentSection">
		<h1>Oops!</h1>
		<p>We regret to inform you that an error occured during the processing of your page request.</p>
		
		<ul class="form">
			<li>
				<label>Type</label>
				<cfoutput>#request.event.getargs().exception.getType()#</cfoutput>
			</li>
			<li>
				<label>Error Code</label>
				<cfoutput>#request.event.getargs().exception.getErrorCode()#</cfoutput>
			</li>
			<li>
				<label>Message</label>
				<cfoutput>#request.event.getargs().exception.getMessage()#</cfoutput>
			</li>
			<li>
				<label>Detail</label>
				<cfoutput>#request.event.getargs().exception.getDetail()#</cfoutput>
			</li>
			<li>
				<label>Extended Info</label>
				<cfoutput>#request.event.getargs().exception.getExtendedInfo()#</cfoutput>
			</li>
			<li>
				<label>Caught Exception</label>
				<cfoutput>#request.event.getargs().exception.getCaughtException()#</cfoutput>
			</li>
			<li>
				<label>Tag Context</label>
				<cfdump var="#request.event.getargs().exception.getTagContext()#" expand="no" />
			</li>
			<li>
				<label>FORM</label>
				<cfdump var="#FORM#" expand="no" />
			</li>
		</ul>
		
	</div>
</div>