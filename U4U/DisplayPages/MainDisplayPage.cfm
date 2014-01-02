<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<cfoutput>
<meta name="title" content="#HTMLEditFormat( REQUEST.Meta.Title )#" />
<meta name="description" content="#HTMLEditFormat( REQUEST.Meta.Description )#" />

<meta property="og:site_name" content="#REQUEST.Meta.SiteName#" />
<meta property="og:title" content="#HTMLEditFormat( REQUEST.Meta.Title )#" />
<meta property="og:description" content="#HTMLEditFormat( REQUEST.Meta.Description )#" />
<meta property="og:type" content="#REQUEST.Meta.Type#" />
<meta property="og:url" content="#HTMLEditFormat( REQUEST.Meta.Url )#" />
<meta property="og:image" content="#HTMLEditFormat( REQUEST.Meta.Image )#" />
<meta property="fb:app_id" content="#Request.Meta.AppID#" />
<meta property="fb:admins" content="#Request.Meta.Admins#" />

<title>#REQUEST.Meta.SiteName#<cfif LEN(REQUEST.Meta.Title)> - #HTMLEditFormat( REQUEST.Meta.Title )#</cfif></title>
</cfoutput>

<link rel="stylesheet" type="text/css" href="/css/reset.css" />
<link rel="stylesheet" type="text/css" href="/css/forms.css" />
<link rel="stylesheet" type="text/css" href="/css/jquery.ui.all.css" />
<link rel="stylesheet" type="text/css" href="/css/style.css" />
<link rel="stylesheet" type="text/css" href="/css/style-print.css" media="print" />
<link rel="stylesheet" type="text/css" href="/Javascript/fancybox/jquery.fancybox-1.3.1.css" />
<!--[if lt IE 9]>
<script src="/Javascript/html5.js"></script>
<link rel="stylesheet" type="text/css" href="/css/ie.css">
<![endif]-->
<!--[if lt IE 8]>
<script src="/Javascript/html5.js"></script>
<link rel="stylesheet" type="text/css" href="/css/ie7.css">
<![endif]-->
<script type="text/javascript" src="/Javascript/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="/javascript/jquery-ui-1.8.1.custom.min.js"></script>
<script type="text/javascript" src="/Javascript/jquery.validate.min.js"></script>
<script type="text/javascript" src="/Javascript/FrontEnd.js"></script>
<script type="text/javascript" src="/Javascript/fancybox/jquery.fancybox-1.3.1.pack.js"></script>

<!--- SHARE THIS --->
<script type="text/javascript" src="http://w.sharethis.com/button/buttons.js"></script>
<script type="text/javascript">stLight.options({publisher:'698be38e-47ec-4065-b6e5-5ce6abebaab5'});</script>
<!--- LIKE BUTTON --->
<script src="http://connect.facebook.net/en_US/all.js#xfbml=1"></script>


<script type="text/javascript">
  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-21384892-1']);
  _gaq.push(['_trackPageview']);
  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();
</script>



</head>

<cfif Request.Event.GetName() EQ "Homepage.Visitor">
	<cfset REQUEST.BodyClass = "green " & LCASE( REQUEST.LocationLabel ) & " home" />
<cfelse>
	<cfset REQUEST.BodyClass = "green " & LCASE( REQUEST.LocationLabel ) & " contentPage" />
	<cfif ListFindNoCase( "StudyGroups,Community", ListFirst( Request.Event.GetName(), "." ) )>
		<cfset REQUEST.BodyClass = REQUEST.BodyClass & " forumPage" />
	</cfif>
</cfif>

<body class="<cfoutput>#REQUEST.BodyClass#</cfoutput>">

<!--- FACEBOOK JAVASCRIPT SDK --->
<div id="fb-root"></div>
<script>
  window.fbAsyncInit = function() {
    FB.init({appId: '<cfoutput>#Request.Meta.AppID#</cfoutput>', status: true, cookie: true,
             xfbml: true});
  };
  (function() {
    var e = document.createElement('script'); e.async = true;
    e.src = document.location.protocol +
      '//connect.facebook.net/en_US/all.js';
    document.getElementById('fb-root').appendChild(e);
  }());
</script>

	<div id="headerContainer">
		<header id="header" class="siteWidth">
			<span id="logo">
				<a href="/" title="">U4U <cfoutput>#REQUEST.LocationLabel#</cfoutput></a>
			</span>
			<ul id="mainNav" class="h-nav nav">
				<li><a href="/events.html" title="">Events</a></li>
				<li><a href="/study-groups.html" title="">Study Groups</a></li>
				<li><a href="/marketplace.html" title="">Marketplace</a></li>
				<li><a href="/community.html" title="">Community</a></li>
				<li><a href="/deals.html" title="">Deals</a></li>
				<li><a href="/jobs.html" title="">Jobs</a></li>
				<cfif REQUEST.UserIsLoggedIn>
					<li><a href="/profile-edit.html" title="" class="accountNavItem">Account</a></li>
					<li><a href="/logout.html" title="" class="accountNavItem">Logout</a></li>
				<cfelse>
					<li><a href="/" title="" class="accountNavItem">Sign up</a></li>
					<li><a href="/login.html" title="" class="accountNavItem">Login</a></li>
				</cfif>
			</ul>
			<form action="/search-results.html" method="post">
				<span id="topSearchBox"class="searchContainer">
					<input type="text" value="Search <cfoutput>#REQUEST.SiteLabel#</cfoutput>" id="topSearch" class="searchInput" name="SearchTerm" />
				</span>
			</form>
			<div id="locationInformation">
				<div id="location" >
					<span class="city">
						<!---a href="#"---><cfoutput>#UCASE( REQUEST.LocationLabel )#</cfoutput><!---/a--->
					</span>
					<!--- a href="#" class="changeLocation">Change Location</a --->
				</div>
			</div>
		</header>
	</div>
	
	<!-- start content -->
		<cfoutput>#request.Content#</cfoutput>
	<!-- end content -->
	
	<br class="clear"/>
	
	<div id="footerContainer">
		<footer id="footer" class="siteWidth clearfix">
			<div class="module footerCol">
				<h3>U4U Information</h3>
				<div class="moduleContent">
					<ul>
						<li> <a href="/what-is-u4u.html" title="">What is U4U?</a></li>
						<li><a href="/u4u-guide.html" title="">U4U Guide</a></li>
                        <li><a href="/faq.html" title="">FAQ</a></li>
						<li><a href="/contact-us.html" title="">Contact us</a></li>
						<li><a href="/advertise-with-us.html" title="">Advertise with us</a></li>
						<li><a href="/help.html" title="">Help</a></li>
                        
					</ul>
				</div>
			</div>
			<div class="module footerCol">
				<h3>U4U Community Content</h3>
				<div class="moduleContent">
					<ul>
						<li><a href="/events.html" title="">Events</a></li>
						<li><a href="/study-groups.html" title="">Study Groups</a></li>
						<li><a href="/marketplace.html" title="">Marketplace</a></li>
						<li><a href="/community.html" title="">Community</a></li>
						<li><a href="/deals.html" title="">Deals</a></li>
						<li><a href="/jobs.html" title="">Jobs</a></li>
					</ul>
				</div>
			</div>
			<div class="module footerCol" id="connectWithUs">
				<h3>Connect With U4U</h3>
					<div class="moduleContent">
						<a href="http://www.facebook.com/pages/U4U/160120547378831" title="" target="_blank"><img src="/images/facebook_32.png" alt="Facebook"/></a> 
						<!--- <a href="/" title=""><img src="/images/twitter_32.png" alt="Facebook"/></a> 
						<a href="/" title=""><img src="/images/rss_32.png" alt="Facebook"/></a> 
						<a href="/" title=""><img src="/images/youtube_32.png" alt="Facebook"/></a> --->
						<dl class="info">
							<dt>Contact Us</dt>
							<!---<dd>U4U</dd> --->
							<!--- <dd>2537 Harvard Yard Mail</dd>
							<dd>Cambridge MA, 02138</dd> --->
							<dd>Phone: 857-756-4056</dd>
                            <dd><a href="contact-us.html">Contact us</a></dd>
						</dl>
						<dl class="info">
							<dt>Join the E-mail List</dt>
							<form method="get" action="javascript:void(0)" id="EmailList">
								<dd>
									<input type="text" name="e" />
									<button type="submit">GO</button>
								</dd>
							</form>
							<dd>
								<input type="radio" id="EmailListUnsubscribe" />
								Unsubscribe
							</dd>
						</dl>
					</div>
			</div>
		</footer>
	</div>
	<div id="copyright" class="siteWidth">
		<span>Copyright &copy; <cfoutput>#year(now())#</cfoutput> U4U. All Rights Reserved</span> 
		<a href="/privacy.html" title="">Privacy</a> | 
		<!--- <a href="/security.html" title="">Security</a> |  --->
		<a href="/terms-and-conditions.html" title=""> Terms</a> | 
		<a href="/site-map.html" title="">Sitemap</a>
	</div>
<script src="//static.getclicky.com/js" type="text/javascript"></script>
<script type="text/javascript">try{ clicky.init(66411767); }catch(e){}</script>
<noscript><p><img alt="Clicky" width="1" height="1" src="//in.getclicky.com/66411767ns.gif" /></p></noscript> 

</body>
</html>
