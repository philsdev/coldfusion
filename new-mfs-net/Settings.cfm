<!----------------------------------------------------------------------------------------------------------

	Settings.cfm
	
	I contain settings common to the front end and the admin

----------------------------------------------------------------------------------------------------------->
<cfscript>
	
	/* TODO: change these to /images/products/ and /image/categories/ */
	REQUEST.Root.Paths.Image.Product = "/images/products/";
	REQUEST.Root.Paths.Image.Category = "/images/categories/";
	
	REQUEST.Root.Paths.Email.CSV = "DisplayPages/admin/Emails/";
	
	REQUEST.Root.Web.Base = "http://#CGI.SERVER_NAME#/";
	REQUEST.Root.Web.Image.Product = REQUEST.Root.Paths.Image.Product;	
	REQUEST.Root.Web.Image.Category = REQUEST.Root.Paths.Image.Category;	
				
	/* PAYFLOWPRO */	
	
	REQUEST.PayFlowPro.Partner = "VeriSign";
	REQUEST.PayFlowPro.Username = "matthewfsheehan";
	REQUEST.PayFlowPro.Password = "MFSbeata51206";
		
	/* IMAGE EXTENSIONS */
		
	REQUEST.Image.ValidExtensionList = "jpg|jpeg|gif";
	
	/* PRODUCT IMAGES */
	
	REQUEST.Image.Product.Thumbnail = StructNew();
	REQUEST.Image.Product.Thumbnail.Width = 51;
	REQUEST.Image.Product.Thumbnail.Prefix = "th_";
	
	REQUEST.Image.Product.List = StructNew();
	REQUEST.Image.Product.List.Width = 156;
	REQUEST.Image.Product.List.Prefix = "fe_";
	
	REQUEST.Image.Product.Detail = StructNew();
	REQUEST.Image.Product.Detail.Width = 273;	
	REQUEST.Image.Product.Detail.Prefix = "dt_";	
	
	REQUEST.Image.Product.Enlarged = StructNew();
	REQUEST.Image.Product.Enlarged.Width = 1000;
	REQUEST.Image.Product.Enlarged.Prefix = "en_";
	
	/* CATEGORY IMAGES */
	
	REQUEST.Image.Category.List = StructNew();
	REQUEST.Image.Category.List.Width = 156;
	REQUEST.Image.Category.List.Prefix = "fe_";
	
	REQUEST.Image.Category.Enlarged = StructNew();
	REQUEST.Image.Category.Enlarged.Width = 640;
	REQUEST.Image.Category.Enlarged.Prefix = "en_";
	
	/* PERSONALIZATION */
	
	REQUEST.Personalization.Engrave.Title = "Engraving";
	REQUEST.Personalization.Engrave.BaseCharge = 20;
	REQUEST.Personalization.Engrave.Lines = 3;
	REQUEST.Personalization.Engrave.CharacterLineMax = 20;
	REQUEST.Personalization.Engrave.CharacterSurcharge = 1;
	
	REQUEST.Personalization.Memorial.Title = "Memorial Label";
	REQUEST.Personalization.Memorial.BaseCharge = 20;
	REQUEST.Personalization.Memorial.Lines = 2;
	REQUEST.Personalization.Memorial.CharacterLineMax = 20;
	REQUEST.Personalization.Memorial.CharacterSurcharge = 1;
	
	REQUEST.Personalization.GoldStamp.Title = "Gold Stamping";
	REQUEST.Personalization.GoldStamp.BaseCharge = 20;
	REQUEST.Personalization.GoldStamp.Lines = 2;
	REQUEST.Personalization.GoldStamp.CharacterLineMax = 20;
	REQUEST.Personalization.GoldStamp.CharacterSurcharge = 1;
	
	/* PRICE RANGES */
	
	REQUEST.PriceRange = ArrayNew(1);
	
	REQUEST.PriceRange[1] = StructNew();
	REQUEST.PriceRange[1].Title = "$1 - $49";
	REQUEST.PriceRange[1].PriceMin = 0;
	REQUEST.PriceRange[1].PriceMax = 49.99;
	
	REQUEST.PriceRange[2] = StructNew();
	REQUEST.PriceRange[2].Title = "$50 - $99";
	REQUEST.PriceRange[2].PriceMin = 50;
	REQUEST.PriceRange[2].PriceMax = 99.99;
	
	REQUEST.PriceRange[3] = StructNew();
	REQUEST.PriceRange[3].Title = "$100 - $499";
	REQUEST.PriceRange[3].PriceMin = 100;
	REQUEST.PriceRange[3].PriceMax = 499.99;
	
	REQUEST.PriceRange[4] = StructNew();
	REQUEST.PriceRange[4].Title = "$500 - $999";
	REQUEST.PriceRange[4].PriceMin = 500;
	REQUEST.PriceRange[4].PriceMax = 999.99;
	
	REQUEST.PriceRange[5] = StructNew();
	REQUEST.PriceRange[5].Title = "$1000 and up";
	REQUEST.PriceRange[5].PriceMin = 1000;
	REQUEST.PriceRange[5].PriceMax = 99999;
	
</cfscript>