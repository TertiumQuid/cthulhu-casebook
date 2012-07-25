(function(d) {
  $('#new_character').find('input[type=submit]').live('click', function(event) {
	if (typeof FB != 'undefined') {
      event.preventDefault();
      FB.getLoginStatus(function(response) {
   	    console.log(response)
        $('#new_character').submit();

        if (response.status === 'connected') {
	      var uid = response.authResponse.userID;
          var accessToken = response.authResponse.accessToken;
        } else {
          FB.login(function(response) {
 		    if (response.authResponse) {
		    } else {
		      console.log('User cancelled login or did not fully authorize.');
		    }	
          });	
        }
      });
      return false;
    }
  })
})(document);