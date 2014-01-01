<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<h1 class="pageHead">Administrator Options</h1>
			<CFLOCK scope="session" type="readonly" timeout="10">
				<CFIF StructKeyExists( Session, "SectionQuery" )>
					<div class="adminHomeColumn">
					<CFOUTPUT query="session.SectionQuery" group="GroupName">
						<div class="adminHomeSection">
							<h2>#GroupName#</h2>
							<CFOUTPUT>
								<h3><a href="index.cfm?event=#EventName#">#SectionName#</a></h3>
								<p>#SectionDescription#</p>
							</CFOUTPUT>
						</div>
					</CFOUTPUT>
					</div>
				</CFIF>
			</CFLOCK>
		</td>
	</tr>
</table>
<div style="clear:both"></div>