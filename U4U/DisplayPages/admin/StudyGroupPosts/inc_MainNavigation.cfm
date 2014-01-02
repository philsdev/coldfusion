<cfscript>
	variables.SectionArray = ArrayNew(1);
	
	variables.SectionArray[1] = StructNew();
	variables.SectionArray[1].Key = "Admin.StudyGroupPost.Management";
	variables.SectionArray[1].Label = "Study Group Posts";
	
	variables.SectionArray[2] = StructNew();
	variables.SectionArray[2].Key = "Admin.StudyGroupPost.Information";
	variables.SectionArray[2].Label = "[+] Edit Study Group Post";
	
	variables.Admin = Request.ListenerManager.GetListener( "AdminManager" );
	variables.SectionTabs = variables.Admin.RenderSectionNavigation( SectionArray:variables.SectionArray );

	WriteOutput( variables.SectionTabs );
</cfscript>