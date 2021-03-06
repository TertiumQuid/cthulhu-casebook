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
  
  test 'get new with location' do  
    setup_fight
    load_locations
    get :new, :location_id => 'arkham_merchant_district'
    [:fight, :escape, :stealth, :magic, :confront].each do |s| 
      assert_select "a[href=?]", location_monster_path('arkham_merchant_district', s)
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
    assert_nil @character.reload.monster_id, 'expected character no longer associated with monster'
  end
  
  test 'get show' do
    setup_fight
    get :show, :id => 'confront'
    assert_equal @monster, assigns(:monster), 'expected monster assigned'    
    assert_equal true, assigns(:success), 'expected success'
    assert_nil @character.reload.monster_id, 'expected character no longer associated with monster'
  end 
  
  test 'get show with demise' do
    setup_fight
    demise = Demise.create!(:limit => 10, :_id => 'pathology.madness', :location => 'arkham_sanitarium', :title => 'test')
    @character.profile.set('pathology', 'madness', 10)
    @character.profile.save
    
    get :show, :id => 'confront'
    assert_equal @monster, assigns(:monster), 'expected monster assigned'    
    assert_equal true, assigns(:success), 'expected success'
    assert !assigns(:demise).blank?, 'expected demise assigned'
    assert_equal demise.location, @character.reload.location.value, 'expected new location after demise'
    assert_select "a[href=?]", demise_path(demise._id.gsub(/\./, '_'))
  end 
  
  test 'get show and relocate' do
    load_locations
    setup_fight
    get :show, :id => 'confront', :location_id => 'arkham_merchant_district'
    
    assert_equal @monster, assigns(:monster), 'expected monster assigned'
    assert_equal true, assigns(:success), 'expected success'
    assert_equal 'arkham_merchant_district', @controller.current_character.location.value, 'expected character location updated'
  end
end