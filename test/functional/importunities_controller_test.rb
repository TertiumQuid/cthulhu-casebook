require 'test_helper'

class ImportunitiesControllerTest < ActionController::TestCase
  tests ImportunitiesController
  
  def setup
    @u1 = User.create(:email => 'u1@example.com')
    @u2 = User.create(:email => 'u2@example.com')
    @c1 = Character.create(:name => 'c1', :user => @u1)
    @c2 = Character.create(:name => 'c2', :user => @u2)    
  end

  test 'post create' do
    login! @u1, @c1
    assert_difference 'Importunity.count', +1 do
      post :create, :user_id => @u2._id
    end
    assert !assigns(:importunity).blank?, 'expected importunity assigned'
    assert_equal assigns(:importunity).user_id, @u2._id, 'expected user assigned'
    assert assigns(:importunity).pending_user_ids.include?(@u1._id.to_s), 'expected sender assigned'
    assert_template :show, 'expected show template'
  end
  
  test 'get accept' do
    login! @u2, @c2
    importunity = Importunity.request(@u1, @u2._id)    
    assert_difference 'importunity.reload.pending_user_ids.size', -1 do
      get :accept, :id => @u1._id
    end
    assert_redirected_to friends_path
  end
  
  test 'get reject' do
    login! @u2, @c2    
    importunity = Importunity.request(@u1, @u2._id)    
    assert_difference 'importunity.reload.rejected_user_ids.size', +1 do
      get :reject, :id => @u1._id
    end
    assert_redirected_to friends_path
    
  end  
end