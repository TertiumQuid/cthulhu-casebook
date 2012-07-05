require 'test_helper'

class CharactersControllerTest < ActionController::TestCase
  tests CharactersController
  
  test 'get new' do
    get :new
    assert !assigns(:character).blank?, 'expected character assigned'
    assert_response :success, 'expected http success'
    assert_template :new, 'expected new template'
    
    assert_select "form[action=?]", character_path do
      assert_select "input[name='character[name]'][type='text']"
      assert_select "input[type=submit]"
    end    
  end
  
  test 'post create' do
    assert_difference 'Character.count', +1 do
      post :create, :character => {:name => 'test'}
      assert_equal true, @controller.has_character?, 'expected character after creation'
    end
    assert !assigns(:character).blank?, 'expected character assigned'    
    assert_redirected_to @controller.send(:intro_encounter_path), 'expected redirect to location'
  end
  
  test 'post create fail' do
    assert_no_difference 'Character.count' do
      post :create
    end
    assert !assigns(:character).blank?, 'expected character assigned'
    assert_template :new, 'expected new template'    
  end
  
  test 'get edit' do
    login!
    get :edit
    assert_response :success, 'expected http success'
    assert_template :edit, 'expected edit template'
  end
  
  test 'intro_encounter_path' do
    assert_equal encounter_path(:homecoming), @controller.send(:intro_encounter_path), 'expected encounter with the key HOMECOMING'
  end
end