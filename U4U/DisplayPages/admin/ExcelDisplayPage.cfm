<cfsetting enablecfoutputonly="yes">

<cfparam name="FORM.ReportExportData" default="" />
<cfparam name="FORM.ReportExportFileName" default="Report.xls" />

<cfcontent type="application/msexcel">
<cfheader name="Content-Disposition" value="filename=#FORM.ReportExportFileName#">

<cfoutput>#FORM.ReportExportData#</cfoutput>