/*
Copyright (c) 2003-2010, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

CKEDITOR.editorConfig = function( config ) {	
	
	config.toolbar = 'CreativeEditor';
	config.toolbar_CreativeEditor = [
		['Source','Bold', 'Italic','Underline'],
		['Font','-','FontSize'],
		['TextColor'],
		['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock']
	];
	config.toolbarCanCollapse = false;
	config.resize_enabled = false;
	config.disableObjectResizing = true;
};
