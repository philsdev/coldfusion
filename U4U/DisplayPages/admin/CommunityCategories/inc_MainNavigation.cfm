<cfscript>
	variables.SectionArray = ArrayNew(1);
	
	variables.SectionArray[1] = StructNew();
	variables.SectionArray[1].Key = "Admin.CommunityCategory.Management";
	variables.SectionArray[1].Label = "Community Categories";
	
	variables.SectionArray[2] = StructNew();
	variables.SectionArray[2].Key = "Admin.CommunityCategory.Information";
	variables.SectionArray[2].Label = "[+] Add Community Category";
	
	variables.Admin = Request.ListenerManager.GetListener( "AdminManager" );
	variables.SectionTabs = variables.Admin.RenderSectionNavigation( SectionArray:variables.SectionArray );

	WriteOutput( variables.SectionTabs );
</cfscript>