Current.ListPage = "index.cfm?event=Admin.Report.Purchased.Management";	

Url.Search = "index.cfm?event=Admin.Report.Purchased.Search";

Form.Search = "#PurchasedProductsSearch";
Form.Edit = "#PurchasedProductsEditForm";

$().ready( function() {
	
	SetRowColors();
	
});