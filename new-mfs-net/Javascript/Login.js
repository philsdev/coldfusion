$().ready( function() {

	$('#AdminLoginForm').validate({
		rules: {
			Username: { required: true },
			Password: { required: true }
		},
		messages: {
			Username: "Required",
			Password: "Required"
		}
	});
	
});