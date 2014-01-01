<cfscript>
	variables.SectionArray = ArrayNew(1);
	
	variables.SectionArray[1] = StructNew();
	variables.SectionArray[1].Key = "Admin.Testimonial.Management";
	variables.SectionArray[1].Label = "Testimonials";
	
	variables.SectionArray[2] = StructNew();
	variables.SectionArray[2].Key = "Admin.Testimonial.Information";
	variables.SectionArray[2].Label = "[+] Add Testimonial";
	
	variables.Admin = Request.ListenerManager.GetListener( "AdminManager" );
	variables.SectionTabs = variables.Admin.RenderSectionNavigation( SectionArray:variables.SectionArray );

	WriteOutput( variables.SectionTabs );
</cfscript>

