require 'test_helper'

class DemisesControllerTest < ActionController::TestCase
  tests DemisesController
  
  def setup
    Demise.create!(:limit => 10, :_id => 'pathology.madness', :title => 'test')
    @character = login!
    @character.profile.set('pathology', 'madness', 10)
    @character.profile.save
  end
  
  test 'get show' do
    get :show, :id => 'pathology.madness'
    assert !assigns(:demise).blank?, 'expected demise assigned'
    assert_response :success, 'expected http success'
    assert_template :show, 'expected show template'    
  end  
end