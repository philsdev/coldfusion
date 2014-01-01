<cfscript>
	variables.SectionArray = ArrayNew(1);
	
	variables.SectionArray[1] = StructNew();
	variables.SectionArray[1].Key = "Admin.Promotion.Management";
	variables.SectionArray[1].Label = "Promotions";
	
	variables.SectionArray[2] = StructNew();
	variables.SectionArray[2].Key = "Admin.Promotion.Information";
	variables.SectionArray[2].Label = "[+] Add Promotion";
	
	variables.Admin = Request.ListenerManager.GetListener( "AdminManager" );
	variables.SectionTabs = variables.Admin.RenderSectionNavigation( SectionArray:variables.SectionArray );

	WriteOutput( variables.SectionTabs );
</cfscript>

