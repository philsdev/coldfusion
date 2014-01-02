/*
Copyright (c) 2003-2010, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

CKEDITOR.editorConfig = function( config ) {	
	
	config.toolbar = 'CreativeEditor';
	config.toolbar_CreativeEditor = [
		['Source'],
		['Bold', 'Italic','Underline'],
		['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock']
	];
	config.width = 800; /* 634 - 612 = 22 pix horizontal padding added by editor window */
	config.height = 300;
	config.toolbarCanCollapse = false;
	config.resize_enabled = false;
	//config.enableObjectResizing = false;
	//config.fullPage = true;	
	config.disableObjectResizing = true;
};
