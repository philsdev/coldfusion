<cfscript>
	variables.SectionArray = ArrayNew(1);
	
	variables.SectionArray[1] = StructNew();
	variables.SectionArray[1].Key = "Admin.JobCategory.Management";
	variables.SectionArray[1].Label = "Job Categories";
	
	variables.SectionArray[2] = StructNew();
	variables.SectionArray[2].Key = "Admin.JobCategory.Information";
	variables.SectionArray[2].Label = "[+] Add Job Category";
	
	variables.Admin = Request.ListenerManager.GetListener( "AdminManager" );
	variables.SectionTabs = variables.Admin.RenderSectionNavigation( SectionArray:variables.SectionArray );

	WriteOutput( variables.SectionTabs );
</cfscript>