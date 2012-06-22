require 'test_helper'

class MessagesControllerTest < ActionController::TestCase
  tests MessagesController
  
  def setup
    @character = login!
    Message.create!(:type => 'type', :title => 'title', :text => 'text', :sender => 'sender')    
    @message = Message.create!(:type => 'type', :title => 'title', :text => 'text', :sender => 'sender', :character => @character)    
  end
  
  test 'get index' do
    get :index
    assert_response :success, 'expected http success'
    assert_equal [@message], assigns(:messages).all, 'expected all and only messages for character'
    assert_template :index, 'expected index template'
  end
  
  test 'get show' do
    get :show, :id => @message._id
    assert_response :success, 'expected http success'
    assert_equal @message, assigns(:message), 'expected message assigned'
    assert_template :show, 'expected show template'
  end  
end