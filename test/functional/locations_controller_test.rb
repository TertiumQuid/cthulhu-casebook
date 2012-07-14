require 'test_helper'

class LocationsControllerTest < ActionController::TestCase
  tests LocationsController
  
  def setup
    load_locations
    load_encounters
    login!
  end
  
  test 'get show' do
    location = 'arkham_northside'
    get :show
    assert_response :success, 'expected http success'
    assert_template :show, 'expected show template'
    
    assert !assigns(:location).blank?, 'expected location assigned'
    assert !assigns(:encounters).blank?, 'expected encounters assigned'
    assert_operator assigns(:encounters).size, "<", Encounter.count, 'expected locational subset of all encounters'
    assert assigns(:encounters).select {|e| e.location != location}.blank?, "expected encounters only for #{location}"
  end
  
  test 'get index with friends' do
    friend = Character.create!(:name => 'test', :last_seen_at => Time.now.utc)
    character = @controller.current_character
    character.befriend! friend
    character.befriend! Character.create!(:name => 'test', :last_seen_at => Time.now.utc)
    Conference.confer(character._id, friend._id)

    get :index
    assert !assigns(:friends).blank?, 'expected local friends assigned'
    assert !assigns(:conferences).blank?, 'expected conferences assigned'
  end
  
  test 'get index' do
    get :index
    assert_response :success, 'expected http success'
    assert_template :index, 'expected index template'
    
    assert !assigns(:location).blank?, 'expected location assigned'    
  end  
end