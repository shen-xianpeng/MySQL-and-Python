$(function() {
	$('#btnSignUp').click(function() {
		$.ajax({
            url: '/signUp',
            data: $('form').serialize(),
            type: 'POST',
            success: function(response) {
                res = JSON.parse(response)
                if (!res.success) {
                    alert(res.error);
                } else {
                    window.location = "/showSignIn";
                }
            },
            error: function(error) {
                console.log(error);
            }
        });
	});
});