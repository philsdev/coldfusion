<cfscript>
	variables.SectionArray = ArrayNew(1);
	
	variables.SectionArray[1] = StructNew();
	variables.SectionArray[1].Key = "Admin.Course.Management";
	variables.SectionArray[1].Label = "Courses";
	
	variables.SectionArray[2] = StructNew();
	variables.SectionArray[2].Key = "Admin.Course.Information";
	variables.SectionArray[2].Label = "[+] Add Course";
	
	variables.Admin = Request.ListenerManager.GetListener( "AdminManager" );
	variables.SectionTabs = variables.Admin.RenderSectionNavigation( SectionArray:variables.SectionArray );

	WriteOutput( variables.SectionTabs );
</cfscript>