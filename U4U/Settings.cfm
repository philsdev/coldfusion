<cfscript>

	REQUEST.Root.Web = "http://#CGI.SERVER_NAME#/";
	
	REQUEST.Web.Image = "/images/";
	REQUEST.Web.Captcha = REQUEST.Web.Image & "captcha/";

	REQUEST.Root.Image = REQUEST.Root.Server & "images\";
	REQUEST.Root.Captcha = REQUEST.Root.Image & "captcha\";
	//REQUEST.Root.Template = REQUEST.Root.Image & "templates\";
	
	REQUEST.Root.Advertisement.Creative = REQUEST.Root.Image & "advertisement\";
	
	REQUEST.Root.Deal.Original = REQUEST.Root.Image & "deal\original\";
	REQUEST.Root.Deal.Thumbnail = REQUEST.Root.Image & "deal\thumb\";
	REQUEST.Root.Deal.Fullsize = REQUEST.Root.Image & "deal\full\";
	
	REQUEST.Root.Job.Original = REQUEST.Root.Image & "job\original\";
	REQUEST.Root.Job.Thumbnail = REQUEST.Root.Image & "job\thumb\";
	REQUEST.Root.Job.Fullsize = REQUEST.Root.Image & "job\full\";
	
	REQUEST.Root.Marketplace.Original = REQUEST.Root.Image & "marketplace\original\";
	REQUEST.Root.Marketplace.Thumbnail = REQUEST.Root.Image & "marketplace\thumb\";
	REQUEST.Root.Marketplace.Fullsize = REQUEST.Root.Image & "marketplace\full\";
	
	REQUEST.Root.Event.Original = REQUEST.Root.Image & "event\original\";
	REQUEST.Root.Event.Thumbnail = REQUEST.Root.Image & "event\thumb\";
	REQUEST.Root.Event.Fullsize = REQUEST.Root.Image & "event\full\";
	
	REQUEST.Root.Party.Original = REQUEST.Root.Image & "party\original\";
	REQUEST.Root.Party.Thumbnail = REQUEST.Root.Image & "party\thumb\";
	REQUEST.Root.Party.Fullsize = REQUEST.Root.Image & "party\full\";
	
	REQUEST.Root.User.Original = REQUEST.Root.Image & "user\original\";
	REQUEST.Root.User.Thumbnail = REQUEST.Root.Image & "user\thumb\";
	REQUEST.Root.User.Fullsize = REQUEST.Root.Image & "user\full\";
	
	REQUEST.Images.Deal.ThumbnailWidth = 75;
	REQUEST.Images.Deal.FullsizeWidth = 400;
	
	REQUEST.Images.Job.ThumbnailWidth = 75;
	REQUEST.Images.Job.FullsizeWidth = 400;
	
	REQUEST.Images.Marketplace.ThumbnailWidth = 75;
	REQUEST.Images.Marketplace.FullsizeWidth = 400;
	
	REQUEST.Images.Event.ThumbnailWidth = 75;
	REQUEST.Images.Event.FullsizeWidth = 400;
	
	REQUEST.Images.Party.ThumbnailWidth = 75;
	REQUEST.Images.Party.FullsizeWidth = 400;
	
	REQUEST.Images.User.ThumbnailWidth = 75;
	REQUEST.Images.User.FullsizeWidth = 400;	
	
</cfscript>