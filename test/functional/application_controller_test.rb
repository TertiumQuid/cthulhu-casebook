require 'test_helper'

class ApplicationControllerTest < ActionController::TestCase
  tests ApplicationController
  
  test 'get show' do
    mock_character
    get :show
    assert_response :success, 'expected http success'
    assert_template :show, 'expected show template'
  end
end