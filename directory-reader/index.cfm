<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns='http://www.w3.org/1999/xhtml'>
<head>
	<title>Dir</title>			
	<script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js"></script>
	<script type="text/javascript">
		var targetFolder = "";
		var currentPath = "";
		var targetPath = "";
		var params = {
			folder: "<cfoutput>#url.folder#</cfoutput>",
			file: "<cfoutput>#url.file#</cfoutput>",
			sort: "<cfoutput>#url.sort#</cfoutput>",
			dir: "<cfoutput>#url.dir#</cfoutput>"
		};
		
		jQuery.noConflict();
		
		jQuery().ready( function() {
			getFolder(params.folder);	
			
			jQuery('#path > span#home').click( function() {
				getFolder("");
			});
			
			jQuery('#path > span#folders > span').live('click', function() {
				getFolder(jQuery(this).attr('f'));
			});	

			jQuery('table.lister > tbody > tr.dir > td.name').live('click', function() {
				targetFolder = jQuery(this).text();
				currentPath = jQuery('table.lister').attr('folder');
				targetPath = currentPath + "/" + targetFolder;
				
				scrollToTop();
				getFolder(targetPath);
			});
			
			jQuery('table.lister > tbody > tr.file > td.name').live('click', function() {
				targetFile = jQuery(this).text();
				currentPath = jQuery('table.lister').attr('folder');
				targetPath = currentPath + "/" + targetFile;
						
				scrollToTop();
				getFile(targetPath);
			});
		});
		
		function getFile(path) {
			params.file = path;
			
			setReaderContents("reader.cfm?" + jQuery.param(params));
		}
		
		function getFolder(path) {
			setListerContents("Loading .....");
			setReaderEmpty();
			
			params.folder = path;
			
			jQuery.get(
				"lister.cfm",
				params,
				function(data) {
					setListerContents(data);
					setPath(path);
				}
			);
		}
		
		function scrollToTop() {
			jQuery('html, body').animate({scrollTop: 0}, 500);
			return false;
		}
		
		function setListerContents(data) {
			jQuery('#lister').html(data);
			setWidths();
		}	
		
		function setWidths() {
			var listerContentWidth = jQuery('#lister > table').width();
			var documentWidth = jQuery(document).width();
			var allowanceWidth = 100;
			
			jQuery('#lister').width(listerContentWidth);
			jQuery('#reader').width(documentWidth - listerContentWidth - allowanceWidth);
		}
		
		function setPath(path) {
			var pathArray = path.split("/");
			var pathLinkArray = new Array();
			var pathLinkText = "";
			var pathLinkMarkup = "";
			
			for (var pathIndex=0; pathIndex < pathArray.length; pathIndex++) {
				if (pathArray[pathIndex].length > 0) {
					pathLinkArray.push(pathArray[pathIndex]);
					pathLinkText = pathLinkArray.join('/');
					pathLinkMarkup += '/' + '<span f="' + pathLinkText + '">' + pathArray[pathIndex] + '</span>';
				}
			}
			
			jQuery('#path > #folders').html(pathLinkMarkup);
		}
		
		function setReaderEmpty() {
			jQuery('#reader').attr('src', 'about:blank').hide();
		}
		
		function setReaderContents(url) {
			jQuery('#reader').attr('src', url).show();
		}
		
		function setDoneMessage() {
			alert('Done');
		}
	</script>
	
	<style type="text/css">
		body {
			font-family: "Courier New", courier, serif;
			font-size: 10pt;
			background-color: #eeeeee;
			color: #000;
			margin: 0;
		}
		
		#main #title {
			background-color: #000000;
			color: #fff;
			font-weight: bold;
			font-size: 125%;
			padding: 10px 20px;
		}
		
		#main #path span { cursor: pointer; }
		#main #path span:hover { color: red; }
		
		#main #path {
			background-color: #ffff99;
			padding: 5px 20px;
		}
		
		#main #lister {
			width: 500px;
			float: left;
			margin: 20px;
		}
		
		#main #lister tr th { 
			background-color: #dddddd; 
			padding: 3px;
		}
		
		#main #lister tr td { 
			background-color: #ffffff; 
			padding: 3px;
			white-space: nowrap;
		}
		
		#main #lister tr.dir td.name { 
			background: #ffffff url('pix/folder.png') no-repeat 3px 3px; 
			padding-left: 24px;
			cursor: pointer;
		}
		
		#main #lister tr.file td.name { 
			background: #ffffff url('pix/file.png') no-repeat 3px 3px; 
			padding-left: 24px;
			cursor: pointer;
		}
		
		#main #lister tr.hilite.file td, #main #lister tr.hilite.dir td {
			background-color: #ffffcc;
		}
		
		#main #reader {
			width: 400px;
			height: 400px;
			float: left;
			margin: 20px 20px 20px 0;
			overflow-x: scroll;
			overflow-y: scroll;
			white-space: nowrap;
		}
	</style>
</head>

<body>

<div id="main">
	<div id="title">Directory Reader</div>
	<div id="path">
		<span id="home">[ home ]</span> 
		<span id="folders"></span>
	</div>
	<div id="lister"></div>
	<iframe id="reader" style="display:none"></iframe>
</div>

</body>
</html>