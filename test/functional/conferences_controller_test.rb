require 'test_helper'

class ConferencesControllerTest < ActionController::TestCase
  tests ConferencesController
  
  test 'post create' do
    character = login!
    friend = Character.create!(:name => 'friend')
    
    assert_difference 'Conference.count', +1 do    
      post :create, :character_id => friend._id
    end
    assert !assigns(:conference).blank?, 'expected conference assigned'
    assert_redirected_to location_path, 'expected redirect to show location path'
  end
end