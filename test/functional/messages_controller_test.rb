require 'test_helper'

class MessagesControllerTest < ActionController::TestCase
  tests MessagesController
  
  def setup
    @character = login!
    Message.create!(:title => 'title', :text => 'text', :sender => 'sender', :character => Character.new)    
    @message = Message.create!(:title => 'title', :text => 'text', :sender => 'sender', :character => @character)    
  end
  
  test 'get index' do
    load_lodgings
    get :index
    assert_response :success, 'expected http success'
    assert_equal [@message], assigns(:messages).all, 'expected all and only messages for character'
    assert_template :index, 'expected index template'
  end
  
  test 'get index redirection if demise' do
    @character.relocate!('arkham_sanitarium')
    get :index
    assert_redirected_to location_path, 'should redirect to location when demise'
  end
  
  test 'get show' do
    get :show, :id => @message._id
    assert_response :success, 'expected http success'
    assert_equal @message, assigns(:message), 'expected message assigned'
    assert_template :show, 'expected show template'
  end  
  
  test 'get index with encounters' do
    load_lodgings
    Encounter.create!(:type => 'plot', :location => 'arkham_uptown', :title => 'test')
    encounter = Encounter.create(:type => 'plot', :location => 'lodgings', :title => 'test')
    
    get :index
    assert_template :index, 'expected index template'
    assert_equal [encounter], assigns(:encounters).all, 'expected lodgings encounters assigned'
  end
end