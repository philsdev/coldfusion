<CFCONTENT type="text/css" >
<CFSETTING showdebugoutput="no">
<CFPARAM name="URL.TemplateID" default="1" />
<cfset variables.TemplatePath = "/adTemplates/template-" & URL.TemplateID & "/" />

body {
	color: black;
	font-family: Arial,Helvetica,sans-serif;
}

.CreativeBackground { 
	margin: 0;
	background-color: white;
	background-repeat: no-repeat;
	background-position: top left;
	background-image: url('<cfoutput>#variables.TemplatePath#</cfoutput>template-background.jpg');
}