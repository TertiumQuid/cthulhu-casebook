require 'test_helper'

class FacebookControllerTest < ActionController::TestCase
  tests FacebookController
  
  test 'get channel' do
    get :channel
    assert_response :success, 'expected http success'
    assert_template :channel, 'expected channel template'
    
    assert_not_nil @response.headers['Expires'], 'expected expiration header to be set'
    assert_not_nil @response.headers['Cache-Control'], 'expected cache control header to be set'
  end
end