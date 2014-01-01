<cfscript>
	variables.SectionArray = ArrayNew(1);
	
	variables.SectionArray[1] = StructNew();
	variables.SectionArray[1].Key = "Admin.Attribute.Management";
	variables.SectionArray[1].Label = "Attribute";
	
	variables.SectionArray[2] = StructNew();
	variables.SectionArray[2].Key = "Admin.Attribute.Information";
	variables.SectionArray[2].Label = "[+] Add Attribute";
	
	variables.Admin = Request.ListenerManager.GetListener( "AdminManager" );
	variables.SectionTabs = variables.Admin.RenderSectionNavigation( SectionArray:variables.SectionArray );

	WriteOutput( variables.SectionTabs );
</cfscript>

