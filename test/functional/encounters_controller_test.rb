require 'test_helper'

class EncountersControllerTest < ActionController::TestCase
  tests EncountersController

  def setup
    load_encounters
    @character = login!
  end
  
  test 'get show' do
    encounter = Encounter.find('homecoming')
    get :show, :id => encounter._id
    assert_response :success, 'expected http success'
    assert_template :show, 'expected show template'
    assert_equal encounter, assigns(:encounter), 'expected encounter assigned'
  end
end