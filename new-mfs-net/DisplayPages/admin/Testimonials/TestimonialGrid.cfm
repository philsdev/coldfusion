<cfparam name="request.Testimonials" default="" />

<cfif request.Testimonials.recordcount GT 0>
	<h2 class="sectionTitle">Testimonials</h2>
	<table class="existingItemsTable" width="100%" cellspacing="0" cellpadding="0">
		<thead>
			<tr>
				<th class="left" sidx="FirstName">First Name</th>
				<th class="left" sidx="LastName">Last Name</th>
				<th sidx="DateCreated">Date Created</th>
				<th sidx="Location">Location</th>
				<th sidx="IsApproved">Approved</th>
				<th>Functions</th>
			</tr>
		</thead>
		<tbody>
		<cfoutput query="request.Testimonials">
			<tr rowid="#request.Testimonials.TestimonialID#">
				<td class="left">#request.Testimonials.FirstName#</td>
				<td class="left">#request.Testimonials.LastName#</td>
				<td>#DateFormat(request.Testimonials.DateCreated, 'mm/dd/yyyy')#</td>
				<td>#request.Testimonials.Location#</td>
				<td>#YesNoFormat(request.Testimonials.IsApproved)#</td>
				<td class="functions"><a>Edit</a> | <a>Delete</a></td>      
			</tr>
		</cfoutput>
		</tbody>                    
	</table>
<cfelse>
	<p style="margin-left:10px;">There were no Testimonials found.</p>
</cfif>

<cfoutput>#Request.GridPagination#</cfoutput>