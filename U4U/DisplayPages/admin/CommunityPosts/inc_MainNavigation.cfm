<cfscript>
	variables.SectionArray = ArrayNew(1);
	
	variables.SectionArray[1] = StructNew();
	variables.SectionArray[1].Key = "Admin.CommunityPost.Management";
	variables.SectionArray[1].Label = "Community Posts";
	
	variables.SectionArray[2] = StructNew();
	variables.SectionArray[2].Key = "Admin.CommunityPost.Information";
	variables.SectionArray[2].Label = "[+] Edit Community Post";
	
	variables.Admin = Request.ListenerManager.GetListener( "AdminManager" );
	variables.SectionTabs = variables.Admin.RenderSectionNavigation( SectionArray:variables.SectionArray );

	WriteOutput( variables.SectionTabs );
</cfscript>