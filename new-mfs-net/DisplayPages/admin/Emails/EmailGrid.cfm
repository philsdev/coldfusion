<cfif Request.Emails.recordcount GT 0>
	<h2 class="sectionTitle">E-mails</h2>
	<button type="submit" class="continue" >Delete Checked Emails</button>
	<button type="submit" class="continue" >Create CSV File of Checked Emails</button>
	<table class="existingItemsTable" width="100%" cellspacing="0" cellpadding="0">
		<thead>
			<tr>
				<th sidx="email">E-mail</th>
				<th sidx="emailname">Name</th>
				<th sidx="source">Source</th>
				<th sidx="dateinserted">Date Inserted</th>
				<th sidx="issubscribed">Subscribed?</th>
				<th><!--- >Check to Delete All <input type="checkbox" name="DeleteAll" id="DeleteAll" value="0"> --->
				<button type="submit" id="selectall">Select All</button> <button type="submit" id="selectnone">Unselect All</button>
</th>
				<th>Functions</th>
			</tr>
		</thead>
		<tbody>
	 	<!--- <form action="index.cfm?event=Admin.Email.Delete" method="post" id="EmailDeleteForm">  --->
		<cfoutput query="Request.Emails">
			<tr rowid="#Request.Emails.EmailID#">
				<td>#Request.Emails.Email#</td>
				<td>#Request.Emails.EmailName#</td>
				<td>#Request.Emails.Email_Source#</td>
				<td>#Request.Emails.DateInserted#</td>
				<td>#YesNoFormat( Request.Emails.Email_Subscribed )#</td>
				<td><input type="checkbox" name="DeleteGroupEmail" id="DeleteGroupEmail" value="#Request.Emails.EmailID#"></td>
				<td class="functions"><a>Edit</a> | <a>Delete</a></td>      
			</tr>
		</cfoutput>
		<!--- <tr>
		<td colspan="5">&nbsp;</td>
		<td><button type="submit" class="continue" >Delete Checked Emails</button></td>
		<td>&nbsp;</td>
		</tr> --->
		  <!---</form>  --->
		</tbody>                    
	</table>
<cfelse>
	<p style="margin-left:10px;">There were no e-mails found.</p>
</cfif>

<cfoutput>#Request.GridPagination#</cfoutput>
