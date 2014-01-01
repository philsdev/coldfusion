<cfcontent reset="true">
<cfsavecontent variable="content">
<cfinclude template="FrontEndSettings.cfm" />
</cfsavecontent>

<CFOUTPUT>#trim(content)#</CFOUTPUT>