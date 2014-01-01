<cfparam name="FORM.pw" default="">

<cfscript>
	if (len(form.pw)) {
		try {
			variables.obj = CreateObject("java","coldfusion.server.ServiceFactory");
			variables.DPW = Decrypt(FORM.pw, generate3DesKey("0yJ!@1$r8p0L@r1$6yJ!@1rj"), "DESede", "Base64");
		} catch("Any" exception) {
			variables.DPW = "N/A";
		}
	}
</cfscript>

<p>This decrypts passwords encrypted by the CF admin.</p>

<div>
	<form name="pw" method="post">
		<table>
			<tr>
				<td>Encrypted Password:</td>
				<td><input type="text" name="pw" value="<cfoutput>#FORM.pw#</cfoutput>" style="width:250px" /></td>
			</tr>
		<CFIF len(FORM.pw)>
			<tr>
				<td>Decrypted Password:</td>
				<td><cfoutput>#variables.DPW#</cfoutput></td>
			</tr>
		</CFIF>
			<tr>
				<td>&nbsp;</td>
				<td><button type="submit">DECRYPT</button></td>
			</tr>
		</table>
	</form>
</div>