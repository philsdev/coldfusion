// I have methods common to admin pages

var Current = {
	ListPage: '',
	Row: '',
	RowID: '',
	Sidx: '',	
	Sord: '',
	OppositeSord: ''
};

var New = {
	Sidx: '',
	Sord: ''
};

var Field = {
	Password: '#Password',
	CreativeMethod: '#CreativeMethod',
	MonetizationModel : '#MonetizationModelsOptions',
	CPM: '#CPM',
	PPC: '#PPC',
	CurrentSidx: '#Sort',
	CurrentSord: '#Sord'
};

var Attribute = {
	RowID: 'rowid',
	SortColumn: 'sidx',
	GridDestination: 'dest',
	Parent: 'parent',
	Grandparent: 'grandparent'
};

var Selector = {
	Row: 'tr[' + Attribute.RowID + ']',
	Sort: 'th[' + Attribute.SortColumn + ']',
	Pagination: 'div.pagination',
	UploadPreview: 'a.fancyUploadPreview',
	Input: 'input[type=text],input[type=password],select,textarea',
	CollapsableRow: 'tr.tree[level=1],tr.tree[level=2]',
	TreeRow: 'tr.tree',
	SelectedProducts: '#SelectedProducts',
	SelectedCategories: '#SelectedCategories'
};

var Url = {
	Search: '',
	Edit: '',
	Delete: '',
	View: '',
	Options: {
		Categories: 'index.cfm?event=Admin.Category.Options'
	}
};

var Form = {
	Search: 'Form.Search',
	Edit: ''
};

var Data = {
	Report: {
		Export : ''
	}
};

var Html = {
	Loading: '<img src="/images/calculating.gif" />',
	LimitedField: '<span class="bottomNote offset180 red fieldLimit"></span>'
};

var FieldLimits = {
	CategoryName: 255,
	VendorName: 255,
	FirstName: 50,
	LastName: 50,
	Username: 50,
	PromotionName: 255,
	PromotionCode: 50,
	BillCompany: 100,
	BillFirstName: 50,
	BillLastName: 50,
	BillAddress: 50,
	BillAddress2: 255,
	BillCity: 50,
	BillProvince: 50,
	BillZipCode: 50,
	BillCountry: 50,
	BillPhoneNumber: 50,
	BillPhoneExt: 50,
	BillAltNumber: 50,
	BillAltExt: 50,
	BillEmailAddress: 255,
	ShipCompany: 100,
	ShipFirstName: 50,
	ShipLastName: 50,
	ShipAddress: 50,
	ShipAddress2: 255,
	ShipCity: 50,
	ShipProvince: 50,
	ShipZipCode: 50,
	ShipCountry: 50,
	ShipPhoneNumber: 50,
	ShipPhoneExt: 50,
	ShipAltNumber: 50,
	ShipAltExt: 50,
	ShipEmailAddress: 255,
	ProductName: 255,
	ProductNumber: 100,
	ProductOutOfStockMessage: 200,
	ProductVideoTitle: 255,
	ProductVideoKey: 50,
	ProductAttributeName: 255,
	OptionName: 200,
	OptionNumber: 200,
	Email: 255,
	Emailname: 100,
	Location: 50,
	FirstName2: 50,
	LastName2: 50,
	EmailAddress: 255,
	PhoneNumber: 50,
	PhoneNumber2: 50,
	YearsInBusiness: 50,
	DiscountPercent: 2,
	Company: 255
};

var Labels = {
	State : {
		US: 'State',
		CA: 'Province'
	},
	Code : {
		US: 'ZIP Code',
		CA: 'Postal Code'
	}
};

var Strength = {
	BaseClass: "PasswordStrength",
	Array: new Array("Fail","Poor","Weak","Mild","Strong"),
	Element: 'div.PasswordStrength'
};

$().ready( function() {

	/* cache */

	$.ajaxSetup({ cache:false });

	/* validation */
	
	$.validator.addMethod("phone", function(phoneNumber, element) {
		phoneNumber = phoneNumber.replace(/\s+/g, ""); 
		return this.optional(element) || phoneNumber.length > 9 && phoneNumber.match(/^(1-?)?(\([2-9]\d{2}\)|[2-9]\d{2})-?[2-9]\d{2}-?\d{4}$/);
		//return this.optional(element) || phoneNumber.length > 9 && phoneNumber.match(^(((((\d{3}))|(\d{3}-))\d{3}-\d{4})|(+?\d{2}((-| )\d{1,8}){1,5}))(( x| ext)\d{1,5}){0,1}$);
	}, "Valid phone number required");

	$.validator.addMethod("not", function(value, element, param) {
		return this.optional(element) || value != param;
	}, "Please enter a different value");
	
	$.validator.setDefaults("errorPlacement", function(error, element) {
		error.insertAfter(element)
	});

	$.validator.setDefaults({
		errorElement: "span"
	});
	
	/* fancy box */
	
	$('.fancyProduct').fancybox({
		'titlePosition':'inside',
		'transitionIn':'none',
		'transitionOut':'none',
		'autodimensions':true
	});
	
	$('.fancyTube').fancybox({
		'autodimensions':true,
		'transitionIn':'none',
		'transitionOut':'none',
		'type':'iframe',
		'padding':10
	});
	
	$('.fancyTubePreview').click( function(){
	
		var thisHref = 'http://www.youtube.com/watch_popup?v=' + $(this).siblings('input[type="text"]').val();
	
		$.fancybox({
			'href':thisHref,
			'autodimensions':true,
			'transitionIn':'none',
			'transitionOut':'none',
			'type':'iframe',
			'padding':10
		});
		
	});
	
	$('button.cancelSub').click( function() {
		$(this).parent('div').parent('form').parent('div').hide();
		return false;
	});

	$('button.continueSub').click( function() {
  
	});
	
	$('button.cancel').click( function() {
		cancelEdits();		
		return false;
	});
	
	$('button.cancelSubSection').click( function() {
		self.location.href = Current.ListPage + "&ProductID=" + __ProductID;	
		return false;
	});
	

	$('button.stay').click( function() {
		$('#ReturnUrl').val(Url.Edit);						   
	});
	
	$('button.continue').click( function() {
		$('#ReturnUrl').val(Current.ListPage);						   
	});
	
	$(Selector.Input).live("focus", function(){
		$(this).addClass('editing');														  
	});
	
	$(Selector.Input).live("blur", function(){
		$(this).removeClass('editing');														  
	});
	
	$(Selector.Row).live("mouseover", function(){
		$(this).addClass('hover');														  
	});
	
	$(Selector.Row).live("mouseout", function(){
		$(this).removeClass('hover');														  
	});
	
	$('tr.tree > td.plus').live("click", function(){
		var ThisRowID = parseInt( $(this).parent('tr.tree').attr(Attribute.RowID) );
		var ThisLevel = parseInt( $(this).parent('tr.tree').attr('level') );
		var ThisChildLevel = ThisLevel + 1;
		var ThisChildSelector = Selector.TreeRow + '[level=' + ThisChildLevel + '][parent=' + ThisRowID + ']';
		
		//Open the child level
		$(ThisChildSelector).show();
		
		//Set this icon to minue
		$(this).removeClass('plus').addClass('minus');		
		
		SetRowColors();
	});
	
	$('tr.tree > td.minus').live("click", function(){
		var ThisRowID = parseInt( $(this).parent('tr.tree').attr(Attribute.RowID) );
		var ThisLevel = parseInt( $(this).parent('tr.tree').attr('level') );
		var ThisChildLevel = ThisLevel + 1;
		var ThisChildSelector = Selector.TreeRow + '[level=' + ThisChildLevel + '][parent=' + ThisRowID + ']';
		var ThisGrandchildSelector = Selector.TreeRow + '[grandparent=' + ThisRowID + ']';
		
		//Close second and third levels
		$(ThisChildSelector + ',' + ThisGrandchildSelector).hide();
		
		//Set second level icons to plus
		$(ThisChildSelector).children('td.level' + ThisChildLevel + '.minus').removeClass('minus').addClass('plus');
		
		//Set this icon to plus
		$(this).removeClass('minus').addClass('plus');
		
		SetRowColors();
	});
	
	$(Selector.Sort).live("click", function(){
		Current.Sidx = $(Field.CurrentSidx).val();
		Current.Sord =  $(Field.CurrentSord).val();
		Current.OppositeSord = ( Current.Sord == 'asc' ) ? 'desc' : 'asc';
		
		New.Sidx = $(this).attr(Attribute.SortColumn);
		New.Sord = ( New.Sidx == Current.Sidx ) ? Current.OppositeSord : Current.Sord;	
	
		$(Field.CurrentSidx).val( New.Sidx );
		$(Field.CurrentSord).val( New.Sord );
		
		submitSearchForm();
	});

	$(Form.Search).submit( function() {
		submitSearchForm();
	});
	
	$('.pagination > button').live( 'click', function() {
		var destinationPage = $(this).attr(Attribute.GridDestination);		
		refreshGrid( Url.Search + '&' + $(Form.Search).serialize() + '&page=' + destinationPage);
	});
	
	$('.excelExport').live("click", function() {
		Report.Export.Data = $(this).parent('.reportExportOptions').siblings('.existingItemsContainer').html();
		$('#ReportExportData').val(ReportExportData);
		$('#ReportExportForm').submit();
	});
	
	$('.datepicker').datepicker();
	
	$('#ReportTimePeriod').change( function() {
		toggleDateRangeFields();
	});
	
	$('.limitedField').after( Html.LimitedField );
	
	$('.limitedField').each( function(index) {
		var fieldId = $(this).attr('id');
		showFieldLimit(fieldId);
	});
		
	$('.limitedField').keyup( function() {
		var fieldId = $(this).attr('id');
		showFieldLimit(fieldId);
	});	
	
	/*
		$('.fieldLimit').siblings('.limitedField').each( function(index) {
			var fieldId = $(this).attr('id');
			showFieldLimit(fieldId);
		});
		
		$('.fieldLimit').siblings('.limitedField').keyup( function() {
			var fieldId = $(this).attr('id');
			showFieldLimit(fieldId);
		});	
	*/
	
	$(Selector.UploadPreview).fancybox({
		'type' : 'image'  
	});
	
	/* input fields */
	
	$('.datepicker').css('width','100px');
	$('.status').css('width','125px');
	$('.boolean').css('width','125px');
	$('.state').css('width','200px');
	$('.zipCode').css('width','75px');
	$('.phone').css('width','100px');
	$('.phoneExt').css('width','50px');
	$('.price').css('width','75px').before( '\\$ ' ); /* TODO: figure out proper way to escape this */
	$('.percent').css('width','30px').after(' \\% '); /* TODO: figure out proper way to escape this */
	$('.weight').css('width','75px').after(' lbs');
	$('.number').css('width','75px');
	
});

function submitSearchForm() {
	refreshGrid( Url.Search + '&' + $(Form.Search).serialize() );
}

function cancelEdits() {
	self.location.href = Current.ListPage;
}

function SetRowColors() {
	//clear all coloring
	$(Selector.Row).removeClass('odd');	
	//add odd-row coloring
	$(Selector.Row + ':visible:odd').addClass('odd');	
}

function disableInputs() {
	$('.inputForm').children('form').children('ul').children('li').children('a').hide();
	$('.inputForm').children('form').children('ul').children('li').children('input').attr('disabled','true');
	$('.inputForm').children('form').children('ul').children('li').children('select').attr('disabled','true');
	$('.inputForm').children('form').children('ul').children('li').children('textarea').attr('disabled','true');
	$('.RateTable').children('tbody').children('tr').children('td').children('input').attr('disabled','true');
	$('.PermissionsTable').children('tbody').children('tr').children('td').children('input').attr('disabled','true');
	$('input.selOne').attr('disabled','true');
	$('div.OptionSelectorNav').children('a').hide();
}

function GoToSection() {
	var SectionName = $('#NavOptions').val();
	if (SectionName.length > 0) {
		window.location.href="index.cfm?event=" + SectionName;
	}	
	return false;
}

function RenderSubTabs(currentTabIndex) {
	$('div.TabbedSubPanels').tabs(
		{ selected: currentTabIndex }						
	);
	
	return false;
}

function showMessage(message) {
	$('.Message').html(message);	
}

function showGridLoader() {
	$('.formContainer').html(Html.Loading);
}

function refreshGrid(gridUrl) {
	$('.submitButtonContainer').children('button').attr('disabled','true');
	showGridLoader();
	
	$.get(gridUrl,
		function(data){
			$('.formContainer').html(data);
			SetRowColors();
			$('.submitButtonContainer').children('button').removeAttr('disabled');
		});		
}

function scrollTop() {
	$('html,body').animate(
		{ scrollTop: 0 },
		{ duration: 100 }
	);	
}

function toggleOption(prefix,isVisible) {
	var thisOption = '#' + prefix + 'OptionsContainer > select';
	var thisNode = '#' + prefix + 'Node';
	
	if (isVisible == true) {
		$(thisNode).show();
	} else {
		$(thisOption).val('');
		$(thisNode).hide();
	}	
}

function toggleOptions(parentPrefix,childPrefix) {
	var ParentNode = '#' + parentPrefix + 'Node';
	var ParentContainer = '#' + parentPrefix + 'OptionsContainer';
	var ParentSelect = ParentContainer + ' > select';
	
	var ChildNode = '#' + childPrefix + 'Node';
	var ChildContainer = '#' + childPrefix + 'OptionsContainer';
	var ChildSelect = ChildContainer + ' > select';
	
	var SelectedCategory = $(ParentSelect).val();
	
	if (SelectedCategory.length > 0) {
	
		toggleOption(childPrefix, true);
		$(ChildContainer).html( Html.Loading );
		
		$.get(
			Url.Options.Categories,
			{ ParentID: SelectedCategory },
			function(data){		
				if (data.length > 0) {
					$(ChildContainer).html( data );
				} else {
					toggleOption(childPrefix, false);
				}
			}
		);
	
	} else {
	
		toggleOption(childPrefix, false);
	
	}
}


function showFieldLimit(fieldId) {
	var thisFieldElement = '#' + fieldId;
	var thisLimit = FieldLimits[fieldId];
	var thisAmount = $(thisFieldElement).val().length;
	var thisStatus = '( ' + thisAmount + ' of ' + thisLimit + ' )';
	if (thisAmount > thisLimit) {
		thisStatus = '<strong>' + thisStatus + '</strong>';
		$(thisFieldElement).addClass('max');
	} else {
		$(thisFieldElement).removeClass('max');
	}
	$(thisFieldElement).siblings('.fieldLimit').html(thisStatus);
}

function CheckPasswordStrength(element) {	
	Strength.Val = $(element).val();	
	Strength.HasUpper = /[A-Z]+/.test(Strength.Val);
	Strength.HasLower = /[a-z]+/.test(Strength.Val);
	Strength.HasNumber = /[0-9]+/.test(Strength.Val);
	Strength.HasLength = (Strength.Val.length >= 8) ? true : false;
	Strength.Total = parseInt(Strength.HasUpper + Strength.HasLower + Strength.HasNumber + Strength.HasLength);
	Strength.Label = Strength.Array[Strength.Total];

	$(Strength.Element).html(Strength.Label).removeClass().addClass(Strength.BaseClass + ' ' + Strength.Label).show();
}

function validateUrl(url) {
	var urlPrefix = "http://";
	var urlString = $.trim( url );
	
	if (urlString.length > 0 && ( urlString.substr(0, urlPrefix.length).toLowerCase() != urlPrefix.toLowerCase() )) {
		urlString = urlPrefix + urlString;
	}
	
	return urlString;
}