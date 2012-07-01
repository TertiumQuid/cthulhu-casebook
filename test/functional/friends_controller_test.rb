require 'test_helper'

class FriendsControllerTest < ActionController::TestCase
  tests FriendsController
  
  test 'get index' do
    login!
    get :index
    assert_response :success, 'expected http success'
    assert_template :index, 'expected index template'
    
    assert_select "form[action=?]", importunity_index_path do
      assert_select "input[name='user_id'][type='text']"
      assert_select "input[type=submit]"
    end    
  end
  
  test 'get index with friends' do  
    character = login!
    friend = Character.create(:name => 'test')
    character.update_attribute :character_friend_ids, [friend._id.to_s]
    
    get :index
    assert_template :index, 'expected index template'
    assert !assigns(:characters).blank?, 'expected friend characters assigned'
  end
  
  test 'get index with importunity' do  
    character = login!
    
    friend = User.create!(:email => 'friend@example.com')
    Character.create(:name => 'test', :user => friend)
    importunity = Importunity.request(friend, character.user_id)
    get :index
    assert_template :index, 'expected index template'
    
    assert_select "a[href=?]", accept_importunity_path(friend._id)
    assert_select "a[href=?]", reject_importunity_path(friend._id)    
  end
end