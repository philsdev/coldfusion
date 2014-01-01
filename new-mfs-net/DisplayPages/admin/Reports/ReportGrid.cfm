<cfparam name="request.Words" default="" />		

<cfif request.Words.recordcount GT 0>
	<h2 class="sectionTitle">Words</h2>
	<table class="existingItemsTable" width="100%" cellspacing="0" cellpadding="0">
		<thead>
			<tr>
				<th class="left" sidx="word">Word</th>
				<th sidx="searchcount">Times Searched</th>
				<th sidx="resultcount">Results Returned</th>
				<th sidx="datelastsearched">Date Last Searched</th>
			</tr>
		</thead>
		<tbody>
		<cfoutput query="request.Words">
			<tr rowid="#request.Words.RowNum#">
				<td class="left">#HTMLEditFormat(request.Words.Word)#</td>
				<td>#NumberFormat(request.Words.SearchCount)#</td>
				<td>#NumberFormat(request.Words.ResultCount)#</td>
				<td>#request.Words.DateLastSearched#</td>     
			</tr>
		</cfoutput>
		</tbody>                    
	</table>
<cfelse>
	<p style="margin-left:10px;">There were no words found.</p>
</cfif>