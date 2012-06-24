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
end