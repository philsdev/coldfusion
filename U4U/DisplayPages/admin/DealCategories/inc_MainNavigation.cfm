<cfscript>
	variables.SectionArray = ArrayNew(1);
	
	variables.SectionArray[1] = StructNew();
	variables.SectionArray[1].Key = "Admin.DealCategory.Management";
	variables.SectionArray[1].Label = "Deal Categories";
	
	variables.SectionArray[2] = StructNew();
	variables.SectionArray[2].Key = "Admin.DealCategory.Information";
	variables.SectionArray[2].Label = "[+] Add Deal Category";
	
	variables.Admin = Request.ListenerManager.GetListener( "AdminManager" );
	variables.SectionTabs = variables.Admin.RenderSectionNavigation( SectionArray:variables.SectionArray );

	WriteOutput( variables.SectionTabs );
</cfscript>