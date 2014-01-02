<cfif Request.Pages.recordcount GT 0>
	<h2 class="sectionTitle">Pages</h2>
	<table class="existingItemsTable" width="100%" cellspacing="0" cellpadding="0">
		<thead>
			<tr>
				<th sidx="pagetitle">Page Title</th>
				<th sidx="searchtitle">Search Title</th>
				<th sidx="datecreated">Date Created</th>
				<th sidx="status">Status</th>
				<th>Functions</th>
			</tr>
		</thead>
		<tbody>
		<cfoutput query="Request.Pages">
			<tr rowid="#Request.Pages.ID#">
				<td>#Request.Pages.PageTitle#</td>
				<td>#Request.Pages.SearchTitle#</td>
				<td>#Request.Pages.DateCreated#</td>
				<td>#Request.Pages.Status#</td>
				<td class="functions"><a>Edit</a> | <a>Delete</a></td>      
			</tr>
		</cfoutput>
		</tbody>                    
	</table>
<cfelse>
	<p style="margin-left:10px;">There were no pages found.</p>
</cfif>

<cfoutput>#Request.GridPagination#</cfoutput>