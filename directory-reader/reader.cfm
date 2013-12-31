<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns='http://www.w3.org/1999/xhtml'>
<head>
	<title>Dir</title>			
	<link href="css/shCore.css" rel="stylesheet" type="text/css" />
	<link href="css/shThemeDefault.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js"></script>
	<script type="text/javascript" src="scripts/shCore.js"></script>
	<script type="text/javascript">		
		jQuery.noConflict();
		
		SyntaxHighlighter.defaults['toolbar'] = false;
		SyntaxHighlighter.all();
	</script>
	
	<style type="text/css">
		body {
			font-family: "Courier New", courier, serif;
			font-size: 12pt;
			background-color: #ffffff;
			color: #000;
			margin: 0;
			padding: 0;
		}
		
		#main #title {
			background-color: #ffff99;
			padding: 5px 20px;
			margin: 0 0 20px 0;
		}
	</style>
</head>

<body>

<cfset variables.fileContents = request.utility.getFileContents(url.file) />
<cfset variables.fileMarkup = request.utility.getFileMarkup(
	fileContents:variables.fileContents,
	relativePath:url.file
) />

<div id="main">
	<div id="title"><cfoutput>#url.file#</cfoutput></div>
	<div id="stage"><cfoutput>#variables.fileMarkup#</cfoutput></div>
</div>

</body>
</html>