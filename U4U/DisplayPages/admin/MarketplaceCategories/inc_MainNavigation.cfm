<cfscript>
	variables.SectionArray = ArrayNew(1);
	
	variables.SectionArray[1] = StructNew();
	variables.SectionArray[1].Key = "Admin.MarketplaceCategory.Management";
	variables.SectionArray[1].Label = "Marketplace Categories";
	
	variables.SectionArray[2] = StructNew();
	variables.SectionArray[2].Key = "Admin.MarketplaceCategory.Information";
	variables.SectionArray[2].Label = "[+] Add Marketplace Category";
	
	variables.Admin = Request.ListenerManager.GetListener( "AdminManager" );
	variables.SectionTabs = variables.Admin.RenderSectionNavigation( SectionArray:variables.SectionArray );

	WriteOutput( variables.SectionTabs );
</cfscript>