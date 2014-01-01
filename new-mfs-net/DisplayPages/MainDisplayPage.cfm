<!--- hide the site in case anyone stumbles on this url
<p>This is the new site.</p>
<cfabort />
 --->
<!DOCTYPE html>
<html class="no-js">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, minimum-scale=1.0, maximum-scale=1.0">
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
<!-- CSS -->
<link rel="stylesheet" href="/css/reset.css" />
<link rel="stylesheet" href="/css/RMSforms-v0.5.css" />
<link rel="stylesheet" href="/css/style.css" />
<link rel="stylesheet" href="/css/dropdown.css" />

<link rel="stylesheet" type="text/css" href="/javascript/jqzoom_ev-2.3/css/jquery.jqzoom.css">
<link rel="stylesheet" type="text/css" href="/javascript/jquery.fancybox-1.3.4/fancybox/jquery.fancybox-1.3.4.css">
<!-- IE 7,8 Specific Stylesheet -->
<!--[if lte IE 8]>
<link rel="stylesheet" type="text/css" href="/css/ie.css" media="screen" />
<![endif]-->
<!-- HTML5 ELEMENTS IN IE 7,8 (HTML5 SHIM):  http://remysharp.com/2009/01/07/html5-enabling-script/ -->
<!--[if lt IE 9]>
<script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
<![endif]-->

<cfif Request.IsMobile>
	<link rel="stylesheet" href="/css/style-mobile.css" />
</cfif>

<noscript>
	<style type="text/css">
   		 .grid .itemImage img{ visibility:visible;}
    </style>
</noscript>

<script type="text/javascript" src="/javascript/jquery-1.5.min.js"></script>
<script type="text/javascript" src="/javascript/jquery.validate.min.js"></script>
<script type='text/javascript' src='/javascript/jqzoom_ev-2.3/js/jquery.jqzoom-core.js'></script>  
<script type='text/javascript' src='/javascript/jquery.fancybox-1.3.4/fancybox/jquery.fancybox-1.3.4.pack.js'></script>
<script type='text/javascript' src='/javascript/jquery.fancybox-1.3.4/fancybox/jquery.easing-1.3.pack.js'></script> 
<script  type='text/javascript'src="/javascript/jquery.tools.min.js"></script>
<script type="text/javascript" src="/javascript/jquery.hoverIntent.minified.js"></script>
<script type="text/javascript" src="/javascript/jquery.dropdown<cfif Request.IsMobile>-mobile</cfif>.js"></script>
<script type="text/javascript" src="http://cloud.github.com/downloads/malsup/cycle/jquery.cycle.all.2.74.js"></script>
<!--[if (gte IE 5.5)&(lte IE 8)]>
<script type="text/javascript" src="/javascript/DOMAssistantCompressed-2.8.js"></script>
<script type="text/javascript" src="/javascript/ie-css3.js"></script>
<![endif]-->

<script src="/javascript/global.js"></script>
</head>

<!--- body classes:
.home = homepage
.fullPage = page with no left sidebar  - Product Details Pages, homepage, shopping-cart
.contentPage = page with left 156px sidebar  - All Content pages and product list pages
.blogPage = page with right 300px sidebar - All blog pages
--->

<cfif ListFindNoCase( "Homepage,Product.Details", REQUEST.Event.GetName() ) OR FindNoCase( "ShoppingCart", REQUEST.Event.GetName() )>
	<cfset request.BodyClass = "fullPage" />
<cfelse>
	<cfset request.BodyClass = "contentPage" />
</cfif>

<!--- I should be in the config, but then I'd need to be added to every event, and that would blow --->
<cfset variables.ShoppingCart = Request.ListenerManager.GetListener( "ShoppingCart" ) />
<!--- cfset variables.ShoppingCart.VerifyCart() / --->
<cfset variables.CartCount = variables.ShoppingCart.GetItemCount() />

<body class="<cfoutput>#request.BodyClass#</cfoutput>">

<div id="all" class="clearfix3 ">
	<!-- header -->
	<div id="headerContainer" class="container clearfix3">
		<header id="header" class="siteWidth">
			<a href="/" title="Sheehan's Religious Items" id="logo"><img src="/images/sheehans-religious-items-logo.png" alt="Sheehan's Religious Items"/></a>
			<ul id="topNav" class="hlist">
				<cfoutput>
				<cfif IsDefined("SESSION.User.Fname")><li>Welcome #SESSION.User.Fname#</li></cfif>
				<li><a href="" class="expand"></a><a href="/blog/" title="">Blog</a></li>
				<li><a href="/about-us.html" title="">About Us</a></li>
				<li><a href="/customer-service.html" title="">Customer Service</a></li>
				<cfif IsDefined("SESSION.User.LoggedIN") and SESSION.User.LoggedIN eq 1>
					<li><a href="/my-account.html" title=""><strong>
					<cfif SESSION.User.UserType eq 1>
						My Account
					<cfelseif SESSION.User.UserType eq 2>
						Corporate Account
					</cfif>
					</strong></a></li>
				</cfif>	
				<li><cfif IsDefined("SESSION.User.LoggedIN")>
						<a href="/logout.html" title=""><strong>Logout</strong></a>
					<cfelse>
						<a href="/login.html" title=""><strong>Login</strong></a>
					</cfif>	
				</li>
				</cfoutput>
			</ul>
			<form method="post" action="/search-results.html" class="search">
				<div id="topSearchForm" class="searchForm">
					<span class="labelGroup">
						<label class="searchLabel">Enter Keyword or Product #</label>
						<input name="SearchString" id="SearchString" class="searchTxt" type="text" value="<cfoutput>#FORM.SearchString#</cfoutput>" />
					</span>
					<input name="submit" type="submit" value="go" class="button" />
				</div>
			</form>
			<ul id="topContact" class="hlist socialIconsSmall">
				<li><span class="phoneNum">Call <a href="tel:18666742500" class="resetLink">1-866-674-2500</a> </span></li>
				<li><a href="http://www.facebook.com/matthewfsheehan" class="socialIcon facebookIcon"></a></li>
				<li><a href="http://twitter.com/#!/matthewfsheehan" class="socialIcon twitterIcon"></a></li>
				<li><a href="" class="socialIcon rssIcon"></a></li>
				<li><a href="" class="socialIcon youtubeIcon"></a></li>
			</ul>
			<ul id="siteTools" class="hlist">
				<li><a href="" class="iconLink salesIcon">Sales</a></li>
				<li><a href="/gift-registry.html" class="iconLink giftIcon">Gift Registry</a></li>
				<li class="button cartButton leftCartBtn">
					<a href="/shopping-cart.html" class="iconLink cartIcon">Cart (<cfoutput>#NumberFormat(variables.CartCount)#</cfoutput>)</a>
				</li>
				<li class="button cartButton rightCartBtn">
					<a href="/checkout.html" class="checkoutIcon">Checkout</a>
				</li>
			</ul>
		</header>
	</div>
	<!-- top nav -->
	<div id="topNavContainer" class="container">
		<nav id="mainNav" class="clearfix3 siteWidth">
			<cfinclude template="#Request.ViewManager.getViewPath('Viewlets.Navigation')#" />
			<!-- end fullNav -->
		</nav>
	</div>

	<!-- main area -->
	<div id="mainContainer" class="container ">   
		
		<!--- PROMO SLOT #1 --->
		<div id="promoSlot1" class="promo clearfix">
			<a href="/free-shipping.html" title=""><img src="/images/free-shipping-promotion-wide.jpg" /></a>
		</div>
		
		<div id="main" class="clearfix3 siteWidth">
			<cfoutput>#request.content#</cfoutput>
		</div>
	</div>
</div>

<!-- footer -->
<div id="footerContainer" class="container">
	<footer id="footer" class="siteWidth">
		<cfif Request.IsMobile>
			<ul class="centeredList">
				<cfinclude template="#Request.ViewManager.getViewPath('Viewlets.FooterPages')#" />
			</ul>			
		<cfelse>
			<section id="testimonials" class="module doubleBorder cycleContainer" >
				<div class="moduleContent doubleBorder doubleBorderBottom clearfix callOut ">
					<cfinclude template="#Request.ViewManager.getViewPath('Viewlets.Testimonials')#" />
				</div>
			</section>
			<div id="bottomModules" class="clearfix2">
				<div class="module footerModule">
					<h3>Company Information</h3>
					<div class="moduleContent">
						<ul class="moduleCol1 footerNav">
							<cfinclude template="#Request.ViewManager.getViewPath('Viewlets.FooterPages')#" />
						</ul>
						<div class="moduleCol2">
							<a href=""><img src="/images/ncga-logo.png" /></a>
						</div>
					</div>
				</div>
			
				<div class="module footerModule">
					<h3>Shop</h3>
					<div class="moduleContent">
						<cfinclude template="#Request.ViewManager.getViewPath('Viewlets.FooterNavigation')#" />
						<div class="moduleCol2">
							<dl>
								<dt>We Accept:</dt>
								<dd><span class="ccImage"></span></dd>
							</dl>
						</div>
					</div>
				</div>

				<div class="module footerModule">
					<h3>Stay Connected</h3>
					<div class="moduleContent">
						<p>Signup for our email list to receive news and information about products and online specials</p>
						<form id="StayConnectedForm">
							<ul class="form vvv" id="emailSignupForm">
								<li class="labelGroup">
									<label>Email Address</label>
									<input type="text" name="Email" id="emailListTxt"/>
								</li>
								<li>
									<input type="submit" value="Sign Up" class="button" />
									<span class="fr">
										<input type="radio" id="emailListUnsubscribe">
										<label class="i">Unsubscribe</label>
									</span> 
								</li>
							</ul>
						</form>
						<h3>Connect With Us!</h3>
						<ul id="footerSocialIcons" class="hlist socialIconsLarge">
							<li><a href="http://www.facebook.com/matthewfsheehan" class="socialIcon socialIconLarge facebookIconLarge"></a></li>
							<li><a href="http://twitter.com/#!/matthewfsheehan" class="socialIcon socialIconLarge twitterIconLarge"></a></li>
							<li><a href="" class="socialIcon socialIconLarge rssIconLarge"></a></li>
							<li><a href="" class="socialIcon socialIconLarge youtubeIconLarge"></a></li>
						</ul>
					</div>
				</div>
			</div>
		</cfif>
		<span id="copyright">Copyright &copy;<cfoutput>#YEAR(NOW())#</cfoutput> Matthew F Sheehan Co., Inc. </span> 
	</footer>
</div>

</body>
</html>