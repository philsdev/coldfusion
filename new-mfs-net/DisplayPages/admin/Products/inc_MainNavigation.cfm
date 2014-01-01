<cfscript>
	variables.SectionArray = ArrayNew(1);
	
	variables.SectionArray[1] = StructNew();
	variables.SectionArray[1].Key = "Admin.Product.Management";
	variables.SectionArray[1].Label = "Products";
	
	variables.SectionArray[2] = StructNew();
	variables.SectionArray[2].Key = "Admin.Product.Information";
	variables.SectionArray[2].Label = "[+] Add Product";
	
	variables.Admin = Request.ListenerManager.GetListener( "AdminManager" );
	variables.SectionTabs = variables.Admin.RenderSectionNavigation( SectionArray:variables.SectionArray );

	WriteOutput( variables.SectionTabs );
</cfscript>

