// I have methods common to admin pages

var Current = {
	ListPage: '',
	Row: '',
	RowID: '',
	Sidx: ''
};

var Field = {
	Password: '#Password',
	CreativeMethod: '#CreativeMethod',
	MonetizationModel : '#MonetizationModelsOptions',
	CPM: '#CPM',
	PPC: '#PPC'
};

var Attribute = {
	RowID: 'rowid',
	SortColumn: 'sidx',
	GridDestination: 'dest'
};

var Selector = {
	Row: 'tr[' + Attribute.RowID + ']',
	Sort: 'th[' + Attribute.SortColumn + ']',
	Pagination: 'div.pagination',
	UploadPreview: 'a.fancyUploadPreview'
};

var Url = {
	Search: '',
	Edit: '',
	Delete: '',
	View: '',
	Options: {
		Courses: 'index.cfm?event=Admin.Course.Options',
		Users: 'index.cfm?event=Admin.Account.Options',
		StudyGroups: 'index.cfm?event=Admin.StudyGroup.Options'
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
	Loading: '<img src="/images/calculating.gif" />'
};

var FieldLimits = {
	CompanyDescription: 1000,
	LocationDescription: 1000,
	Services: 1000,
	StaffProfile: 4000,
	adHeadline: 80,
	adDescription: 500
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

	$.ajaxSetup({ cache:false });

	$.validator.addMethod("phone", function(phoneNumber, element) {
		phoneNumber = phoneNumber.replace(/\s+/g, ""); 
		return this.optional(element) || phoneNumber.length > 9 && phoneNumber.match(/^(1-?)?(\([2-9]\d{2}\)|[2-9]\d{2})-?[2-9]\d{2}-?\d{4}$/);
	}, "Valid phone number required");

	$.validator.addMethod("zipCode", function(code, element) {
		code = code.replace(/\s+/g, ""); 
		code = code.toUpperCase();
		return this.optional(element) 
			|| code.match(/^[0-9]{5}$/) 
			|| code.match(/^[0-9]{5}.[0-9]{4}$/) 
			|| code.match(/^[A-Z][0-9][A-Z][0-9][A-Z][0-9]$/) 
			|| code.match(/^[A-Z][0-9][A-Z].[0-9][A-Z][0-9]$/);
		}, "Valid ZIP or Postal Code required"
	);
	
	$.validator.setDefaults("errorPlacement", function(error, element) {
		error.insertAfter(element)
	});

	$.validator.setDefaults({
		errorElement: "span"
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

	$('button.stay').click( function() {
		$('#ReturnUrl').val(Url.Edit);						   
	});
	
	$('button.continue').click( function() {
		$('#ReturnUrl').val(Current.ListPage);						   
	});
	
	$(Selector.Row).live("mouseover", function(){
		$(this).addClass('hover');														  
	});
	
	$(Selector.Row).live("mouseout", function(){
		$(this).removeClass('hover');														  
	});
	
	$(Selector.Sort).live("click", function(){
		$('#Sort').val( $(this).attr(Attribute.SortColumn) );
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
	
	$('.fieldLimit').siblings('.limitedField').each( function(index) {
		var fieldId = $(this).attr('id');
		showFieldLimit(fieldId);
	});
	
	$('.fieldLimit').siblings('.limitedField').keyup( function() {
		var fieldId = $(this).attr('id');
		showFieldLimit(fieldId);
	});
	
	$(Selector.UploadPreview).fancybox({
		'type' : 'image'  
	});
	
	$(Field.CreativeMethod).change( function() {
		GetCreativeFields();
	});	
	
	$(Field.MonetizationModel).change( function() {
		toggleMonetizationRates();
	});
	
});

function GetCreativeFields() {
	var ThisUploadOption = $(Field.CreativeMethod).val();
	switch (ThisUploadOption) {
		case "1": {
			$('.creative-upload').show();
			$('.creative-editor').hide();
			break;
		}
		case "2": {
			$('.creative-editor').show();
			$('.creative-upload').hide();
			break;
		}
		default: {
			$('.creative-editor').hide();
			$('.creative-upload').hide();
		}
	}
}

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
	$(Selector.Row + ':odd').addClass('odd');	
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

function toggleOption(propertyName, isVisible) {
	var thisOption = '#' + propertyName + 'Options';
	var thisNode = '#' + propertyName + 'Node';
	
	if (isVisible == true) {
		$(thisNode).show();
	} else {
		$(thisOption).val('');
		$(thisNode).hide();
	}	
}

function toggleStudyGroupOptions() {
	var SelectedSchool = $('#SchoolOptions').val();
	if (SelectedSchool.length > 0) {
	
		toggleOption('Course', true);
		$('#CourseOptionsContainer').html( Html.Loading );
		
		toggleOption('Username', true);
		$('#UsernameOptionsContainer').html( Html.Loading );
		
		$.get(
			Url.Options.Courses,
			{ School: SelectedSchool },
			function(data){		
				$('#CourseOptionsContainer').html( data );
			}
		);
	
		$.get(
			Url.Options.Users,
			{ School: SelectedSchool },
			function(data){		
				$('#UsernameOptionsContainer').html( data );
			}
		);
	
	} else {
	
		toggleOption('Course', false);
		toggleOption('User', false);
	
	}
}

function toggleStudyGroupPostOptions() {
	var SelectedCourse = $('#CourseOptions').val();
	if (SelectedCourse.length > 0) {
	
		toggleOption('StudyGroup', true);
		$('#StudyGroupOptionsContainer').html( Html.Loading );
		
		$.get(
			Url.Options.StudyGroups,
			{ Course: SelectedCourse },
			function(data){		
				$('#StudyGroupOptionsContainer').html( data );
			}
		);
	
	} else {
	
		toggleOption('StudyGroup', false);
	
	}
}

function showFieldLimit(fieldId) {
	var thisFieldElement = '#' + fieldId;
	var thisLimit = FieldLimits[fieldId];
	var thisAmount = $(thisFieldElement).val().length;
	var thisStatus = '( ' + thisAmount + ' of ' + thisLimit + ' )';
	if (thisAmount >= thisLimit) {
		thisStatus = '<strong>' + thisStatus + '</strong>';
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

function toggleMonetizationRates() {
	var SelectedMode = $(Field.MonetizationModel).val();
	
	switch(SelectedMode) {
		case '1': {
			$(Field.PPC).val('0');
			break;
		}
		case '2': {
			$(Field.CPM).val('0');
			break;
		}
	}
}