require 'test_helper'

class ApplicationControllerUserSupportTest < ActionController::TestCase
  tests ApplicationController
  
  def test_current_user_id
    assert_nil @controller.current_user_id, 'expected no default user id in session'
    @controller.session[:user_id] = 1    
    assert_equal 1, @controller.current_user_id, 'expected user id from session'
  end
  
  def test_current_user
    assert_nil @controller.current_user, 'expected no default user'    
    
    user = User.create!(:email => 'test@example.com')
    @controller.session[:user_id] = user._id
    assert_equal user, @controller.current_user, 'expected user from stored session user id'    
  end
end