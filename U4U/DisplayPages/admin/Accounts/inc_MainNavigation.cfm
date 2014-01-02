<cfscript>
	variables.SectionArray = ArrayNew(1);
	
	variables.SectionArray[1] = StructNew();
	variables.SectionArray[1].Key = "Admin.Account.Management";
	variables.SectionArray[1].Label = "Accounts";
	
	variables.SectionArray[2] = StructNew();
	variables.SectionArray[2].Key = "Admin.Account.Information";
	variables.SectionArray[2].Label = "[+] Add Account";
	
	variables.Admin = Request.ListenerManager.GetListener( "AdminManager" );
	variables.SectionTabs = variables.Admin.RenderSectionNavigation( SectionArray:variables.SectionArray );

	WriteOutput( variables.SectionTabs );
</cfscript>