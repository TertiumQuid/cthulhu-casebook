require 'test_helper'

class LocationsControllerTest < ActionController::TestCase
  tests LocationsController
  
  def setup
    load_locations
    load_encounters
    mock_character
  end
  
  test 'get show' do
    get :show
    assert !assigns(:location).blank?, 'expected location assigned'
    assert !assigns(:encounters).blank?, 'expected encounters assigned'
    assert_response :success, 'expected http success'
    assert_template :show, 'expected show template'
  end
end