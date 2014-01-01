<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<cfoutput>
<title>#request.SiteName# Section</title>
<link rel="shortcut icon" href="#Request.Root.Web.Base#favicon.ico" type="image/x-icon" />
<link href="/DisplayPages/Admin/adminstyles.css" rel="stylesheet" type="text/css" />
<link href="/css/jquery.ui.all.css" rel="stylesheet" type="text/css" />
<link href="/css/jquery.ui.resizable.css" rel="stylesheet" type="text/css" />
<link href="/css/jquery.ui.tabs.css" rel="stylesheet" type="text/css" />
<link href="/javascript/fancybox/jquery.fancybox-1.3.1.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="/javascript/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="/javascript/jquery-ui-1.8.1.custom.min.js"></script>
<script type="text/javascript" src="/javascript/jquery.ui.tabs.js"></script>
<script type="text/javascript" src="/javascript/jquery.validate.min.js"></script>
<script type="text/javascript" src="/javascript/fancybox/jquery.fancybox-1.3.1.pack.js"></script>
<script type="text/javascript" src="/javascript/admin.js"></script>
</cfoutput>

<!--- disable admin forms on view (rather than edit) --->
<cfif StructKeyExists( URL, "Type" ) AND URL.Type EQ "View">
	<!--- $ shortcut won't work with spry --->	
	<script type="text/javascript">
		$().ready( function() {
			disableInputs();
		});
	</script>
</cfif>



</head>

<body> 

<div style="display:none">
	<form id="ReportExportForm" action="index.cfm?event=Reports.Export.Excel" method="post" target="_blank">
		<input type="hidden" name="ReportExportData" id="ReportExportData" value="" />
	</form>
</div>

<div class="MainBorder">
	<div id="banner">
		<cfoutput>
		<a href="index.cfm?event=Admin.HomePage" title="HOME">
			<img border="0" src="/images/logo/logo-admin.gif" style="display:inline; position:absolute; top:10px; left:10px; ">
		</a>
		</cfoutput>		
		<cfif StructKeyExists(REQUEST.SessionStruct, "Admin") AND REQUEST.SessionStruct.Admin EQ "Yes">
			<cfparam name="REQUEST.SessionStruct.NavSection" default="" />
			<div style="position:absolute; right:0px; top:30px; margin-right:10px; ">
				<span style=" font-size:14px; font-weight:bold; text-align:left; color:#000000; ">Navigation:</span>
				<form name="navform"  style="margin:0px; padding:0px;" onSubmit="javascript:return GoToSection()">
					<select id="NavOptions" name="NavOptions" onChange="return GoToSection()">
						<option value="">Choose a Category...</option>
						<cfoutput query="REQUEST.SessionStruct.SectionQuery" group="GroupName">
							<optgroup label="#GroupName#">
								<cfoutput>
									<option value="#eventname#"
									<CFIF REQUEST.SessionStruct.NavSection EQ EventName>selected="selected"</CFIF>>#sectionname#</option>
								</cfoutput>
							</optgroup>
						</cfoutput>
					</select>               
					<input src="../DisplayPages/admin/images/btn-go.gif" type="image" style=" position:relative; top:6px;" />
				</form>
			</div>
			
			<a href="index.cfm?event=Admin.Logout" style="display:block; position:absolute; right:0px; top:0px; ">
				<img src="../DisplayPages/admin/images/btn-logout.gif" border="0" alt="Logout" style="">
			</a>
		</cfif>
		
	</div>
		
	<cfif StructKeyExists(REQUEST.SessionStruct, "Admin") AND REQUEST.SessionStruct.Admin iS "Yes">
		<div style="background-color:#fff;"></div>
	</cfif>	

	<div class="Message" style="text-align:center"></div>
	
	<!--- MAIN CONTENT --->
	<div style="overflow:hidden; padding-top:10px;">
		<cfoutput>#request.content#</cfoutput>
	</div>
	
	

</div>

<cfif StructKeyExists(REQUEST.SessionStruct, "Admin") AND REQUEST.SessionStruct.Admin iS "Yes">
	<div id="footer" style=" background-color:#cccccc; text-align:center; padding:0px; border-bottom:1px solid #000000; border-left:1px solid #000000; border-right:1px solid #000000; width:100%; "  >
	</div>
</cfif>

</body>
</html>