require 'test_helper'

class PathsControllerTest < ActionController::TestCase
  tests PathsController
  
  def setup
    load_encounters
    @character = login!
  end
  
  test 'get show' do
    encounter = Encounter.find('homecoming')
    assert_difference '@character.reload.moxie', -Encounter.cost do    
      get :show, :encounter_id => encounter._id, :id => encounter.paths.first._id
    end
    assert_equal encounter, assigns(:encounter), 'expected encounter assigned'
    assert !assigns(:success).blank?, 'expected success status assigned'
    assert_equal encounter.paths.first._id, assigns(:path)._id, 'expected path assigned'
  end
end