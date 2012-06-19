require 'test_helper'

class PathsControllerTest < ActionController::TestCase
  tests PathsController
  
  def setup
    load_encounters
    mock_character
  end
  
  test 'put update' do
    encounter = Encounter.first
    put :update, :encounter_id => encounter._id, :id => encounter.paths.first._id
    assert_equal encounter, assigns(:encounter), 'expected encounter assigned'
    assert_redirected_to location_path, 'expected redirect to location'
  end
end