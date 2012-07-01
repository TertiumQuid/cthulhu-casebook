require 'test_helper'

class ApplicationControllerTest < ActionController::TestCase
  tests ApplicationController
  
  test 'get show' do
    login!
    get :show
    assert_response :success, 'expected http success'
    assert_template :show, 'expected show template'
  end
  
  test 'allow_unauthenticated?' do
    assert_equal false, @controller.send(:allow_unauthenticated?), 'expected authentication required by default'
    @controller.params[:controller] = 'facebook'
    assert_equal true, @controller.send(:allow_unauthenticated?), 'expected authentication not required for facebook controller'    
  end
end