<cfapplication name="directory-reader" clientmanagement="no" setclientcookies="no" sessionmanagement="no" />

<cfparam name="url.file" default="">
<cfparam name="url.folder" default="">
<cfparam name="url.sort" type="string" default="name">
<cfparam name="url.dir" type="string" default="asc">

<cfset request.utility = CreateObject("component", "cfc.utility") />