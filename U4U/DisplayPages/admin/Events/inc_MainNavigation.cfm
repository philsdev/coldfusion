<cfscript>
	variables.SectionArray = ArrayNew(1);
	
	variables.SectionArray[1] = StructNew();
	variables.SectionArray[1].Key = "Admin.Event.Management";
	variables.SectionArray[1].Label = "Events";
	
	variables.SectionArray[2] = StructNew();
	variables.SectionArray[2].Key = "Admin.Event.Information";
	variables.SectionArray[2].Label = "[+] Add Event";
	
	variables.Admin = Request.ListenerManager.GetListener( "AdminManager" );
	variables.SectionTabs = variables.Admin.RenderSectionNavigation( SectionArray:variables.SectionArray );

	WriteOutput( variables.SectionTabs );
</cfscript>