require 'test_helper'

class GiftsControllerTest < ActionController::TestCase
  tests GiftsController
  
  def setup
    @character = login!
    @friend = Character.create(:name => 'friend')    
  end
  
  test 'get new' do
    get :new, :character_id => @friend._id
    assert_response :success, 'expected http success'
    assert_template :new, 'expected new template'
    assert_equal @friend, assigns(:character), 'expected character assigned'
  end
  
  test 'put update' do
    assert_difference ['Gift.count', 'Message.count'], +1 do
      put :update, :character_id => @friend._id, :id => 'belongings.american_dollars'
    end    
    assert_redirected_to location_path
  end
  
  test 'get accept' do
    gift = Gift.give @friend, @character._id, 'belongings.american_dollars'
    
    assert_difference "@character.reload.profile.get('belongings', 'american_dollars').value.to_i", +1 do    
      get :accept, :id => gift._id
      assert_equal gift, assigns(:gift), 'expected gift assigned'
    end    
    assert_redirected_to edit_character_path
  end
  
  test 'get reject' do
    gift = Gift.give @friend, @character._id, 'belongings.american_dollars'
    
    assert_no_difference "@character.reload.profile.get('belongings', 'american_dollars').value.to_i" do    
      get :reject, :id => gift._id
      assert_equal gift, assigns(:gift), 'expected gift assigned'
    end    
    assert_redirected_to edit_character_path
  end  
end