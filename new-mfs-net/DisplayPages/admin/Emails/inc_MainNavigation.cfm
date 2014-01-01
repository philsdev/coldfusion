<cfscript>
	variables.SectionArray = ArrayNew(1);
	
	variables.SectionArray[1] = StructNew();
	variables.SectionArray[1].Key = "Admin.Email.Management";
	variables.SectionArray[1].Label = "E-mails";
	
	variables.SectionArray[2] = StructNew();
	variables.SectionArray[2].Key = "Admin.Email.Information";
	variables.SectionArray[2].Label = "[+] Add E-mail";
	
	variables.Admin = Request.ListenerManager.GetListener( "AdminManager" );
	variables.SectionTabs = variables.Admin.RenderSectionNavigation( SectionArray:variables.SectionArray );

	WriteOutput( variables.SectionTabs );
</cfscript>