<cfscript>
	variables.LinkManager = Request.ListenerManager.GetListener( "LinkManager" );
	
	variables.CategoryManager = Request.ListenerManager.GetListener( "CategoryManager" );
	variables.CategoryList = variables.CategoryManager.GetCategories(Status: 1);
	
	

</cfscript>
<!------------------------------------------------------------------------------------------

	SiteMap.cfm

------------------------------------------------------------------------------------------->

<div id="breadcrumb">
	<a href="/" title="">Home</a>
	<span>Sitemap</span>
</div>
	
<!-- contentContainer nessesary for liquid layouts with static and percentage columns -->
<aside id="sidebar">
	<div class="sideModule navModule module">
		<h3>Module Title</h3>
		<div class="moduleContent">
			<p>Put sidebar content here.</p>
		</div>
	</div>	
</aside>
	
	<!------------------------------------------------------------------------------------------

	ContactUsForm.cfm

------------------------------------------------------------------------------------------->

<cfscript>
	switch(URL.Message) {	
		case "Contact.Error": {
			variables.Message = "Your information could not be sent, please try again.";	
			break;
		}
		case "Contact.Sent": {
			variables.Message = "Your information was sent. We will make sure to address your questions or comments in a timely manner. Thank you for contacting Matthew F Sheehan!  ";	
			break;
		}
		default: {
			variables.Message = "";	
		}	
	}
</cfscript>

<cfif IsDefined("SESSION.User.LoggedIN") and SESSION.User.LoggedIN EQ 1>
	<cfset variable.Firstname = SESSION.User.Fname />
	<cfset variable.Lastname = SESSION.User.Lname />
	<cfset variable.EmailAddress = SESSION.User.EmailAddress />
	<cfset variable.BillPhoneNumber = SESSION.User.BillPhoneNumber  />
	<cfset variable.AccountID = SESSION.User.UserID />
<cfelse>
	<cfset variable.Firstname = "" />
	<cfset variable.Lastname = "" />
	<cfset variable.EmailAddress = "" />
	<cfset variable.BillPhoneNumber = ""  />
	<cfset variable.AccountID = "0" />
</cfif>
<div id="contentContainer">
	<div id="content" class="contentSection">
		<h1>Contact Us</h1>
	
	
    <p>If there is an issue that you feel needs to be addressed, please contact us anytime. 
	We'll do our best to help you and get back to you as soon as possible!</p>
    
	<dl>
		<dt>Contact Information:</dt>
		<dd>Matthew F Sheehan Co., Inc.</dd>
		<dd>44 Lochdale Road </dd>
		<dd>Boston MA, 02131-1110</dd>
		<dd>By Phone: 	1-866-674-2500</dd>
		<dd>By Fax: 	fax number</dd>
		<dd>By Email: 	<a href="mailto:info@matthewfsheehan.net">info@matthewfsheehan.net</a></dd>
	</dl>
 <p>
	<section class="formSection">
		<cfif len(variables.Message)>
			<p class="message"><cfoutput>#variables.Message#</cfoutput></p>
		</cfif>
		<h3>Contact Form</h3>
		<form action="/contact-submit.html" method="post" id="ContactUsForm">
			
			<div class="formContainer" >
				<cfoutput>
				<input type="hidden" name="AccountID"  id="AccountID" value="#variable.AccountID#">
				<span class="required requiredDesignation">Required Fields</span>
				<ul class="form pageForm vvv">
					<li class="required">
						<label>First Name</label>
						<input type="text" name="FirstName" value="#variable.FirstName#" />
					</li>
					<li class="required">
						<label>Last Name</label>
						<input type="text" name="LastName" value="#variable.LastName#" />
					</li>
					<li class="required">
						<label>E-mail</label>
						<input type="text" name="Email" value="#variable.EmailAddress#" />
					</li>
					<li>
						<label>Phone Number</label>
						<input type="text" name="PhoneNumber" value="#variable.BillPhoneNumber#" />
					</li>
					<li>
						<label>Comments</label>
						<textarea name="Comments"></textarea>
					</li>
				</ul>
				</cfoutput>
			</div>
			<footer class="actionContainer mt20">
				<input type="submit" class="button actionButton" value="Submit" >
			</footer>  
		</form>
    </section>
</div>


<script type="text/javascript">
	$().ready( function() {
		
		$('#ContactUsForm').validate({
			rules: {
				FirstName: { required: true },
				LastName: { required: true },
				Email: { required: true, email: true },
				PhoneNumber: { required: false, phoneNumber: true }
			}
		});
		
	});
</script>
	
		</div>
</div>
