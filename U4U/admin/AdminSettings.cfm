<!--- Set the path to the application's mach-ii.xml file. --->
<cfset MACHII_CONFIG_PATH = ExpandPath("../config/AdminConfig.xml") />

<!--- Set the configuration mode (when to reload): -1=never, 0=dynamic, 1=always --->
<cfset MACHII_CONFIG_MODE = -1 />

<!--- Set the app key for sub-applications within a single cf-application. --->
<cfset MACHII_APP_KEY = GetFileFromPath(ExpandPath(".")) />

<cfinclude template="/MachII/mach-ii.cfm" />

