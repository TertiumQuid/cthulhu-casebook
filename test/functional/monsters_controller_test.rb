require 'test_helper'

class MonstersControllerTest < ActionController::TestCase
  tests MonstersController
  
  test 'get show' do
    load_monsters
    character = login!
    monster = Monster.first
    character.update_attribute(:monster_id, monster._id)
    
    get :show
    assert_response :success, 'expected http success'
    assert_template :show, 'expected show template'
    
    assert_equal monster, assigns(:monster), 'expected monster assigned'
  end
  
  test 'get show without monster' do  
    login!    
    get :show
    assert_redirected_to location_path, 'expected redirected to location without monster to fight'
  end
end