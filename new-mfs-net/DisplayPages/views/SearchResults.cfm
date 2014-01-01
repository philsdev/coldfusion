<div id="breadcrumb">
	<a href="/" title="">Home</a>
	<span>Search Results</span>
</div>
	
<!-- contentContainer nessesary for liquid layouts with static and percentage columns -->
<aside id="sidebar">
	<div class="sideModule navModule module">
		<h3>Module Title</h3>
		<div class="moduleContent">
			<p>Put sidebar content here.</p>
		</div>
	</div>	
</aside>

<div id="contentContainer">
	<div id="content" class="contentSection">
		<div class="post">
			<article class="entry-content ">
				<header class="articleHeader">
					<h1>Search Results</h1>
				</header>
				
				<cfif request.SearchProducts.Recordcount>	
					<div id="searchProducts">
						<cfoutput>#request.SearchResultContent#</cfoutput>
					</div>
				<cfelse>
					<p>No products found.</p>
				</cfif>
				
			</article>
		</div>
	</div>
</div>