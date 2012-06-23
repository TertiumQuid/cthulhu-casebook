require 'test_helper'

class MonstersControllerTest < ActionController::TestCase
  tests MonstersController
  
  def setup
    load_monsters
    @character = login!
  end
  
  def setup_fight
    @monster = Monster.first
    @character.update_attribute(:monster_id, @monster._id)
  end
  
  test 'get new' do
    setup_fight
    get :new
    assert_response :success, 'expected http success'
    assert_template :new, 'expected new template'
    
    assert_equal @monster, assigns(:monster), 'expected monster assigned'
    
    [:fight, :escape, :stealth, :magic, :confront].each do |s| 
      assert_select "a[href=?]", monster_path(s)
    end
  end
  
  test 'get new without monster' do  
    login!    
    get :new
    assert_redirected_to location_path, 'expected redirected to location without monster to fight'
  end
  
  test 'get show with confront' do
    setup_fight
    assert_difference '@character.reload.clues', -1 do
      get :show, :id => 'confront'
      assert_template :show, 'expected show template'
    end
    assert_equal @monster, assigns(:monster), 'expected monster assigned'    
  end
  
  test 'get show' do
    setup_fight
    get :show, :id => 'confront'
    assert_equal @monster, assigns(:monster), 'expected monster assigned'    
    assert_equal true, assigns(:success), 'expected success'
  end 
end