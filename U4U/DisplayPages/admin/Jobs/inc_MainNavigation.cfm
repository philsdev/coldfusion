<cfscript>
	variables.SectionArray = ArrayNew(1);
	
	variables.SectionArray[1] = StructNew();
	variables.SectionArray[1].Key = "Admin.Job.Management";
	variables.SectionArray[1].Label = "Jobs";
	
	variables.SectionArray[2] = StructNew();
	variables.SectionArray[2].Key = "Admin.Job.Information";
	variables.SectionArray[2].Label = "[+] Add Job";
	
	variables.Admin = Request.ListenerManager.GetListener( "AdminManager" );
	variables.SectionTabs = variables.Admin.RenderSectionNavigation( SectionArray:variables.SectionArray );

	WriteOutput( variables.SectionTabs );
</cfscript>