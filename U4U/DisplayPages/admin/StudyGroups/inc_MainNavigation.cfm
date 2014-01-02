<cfscript>
	variables.SectionArray = ArrayNew(1);
	
	variables.SectionArray[1] = StructNew();
	variables.SectionArray[1].Key = "Admin.StudyGroup.Management";
	variables.SectionArray[1].Label = "Study Groups";
	
	variables.SectionArray[2] = StructNew();
	variables.SectionArray[2].Key = "Admin.StudyGroup.Information";
	variables.SectionArray[2].Label = "[+] Add Study Group";
	
	variables.Admin = Request.ListenerManager.GetListener( "AdminManager" );
	variables.SectionTabs = variables.Admin.RenderSectionNavigation( SectionArray:variables.SectionArray );

	WriteOutput( variables.SectionTabs );
</cfscript>