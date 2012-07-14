require 'test_helper'

class PathsControllerTest < ActionController::TestCase
  tests PathsController
  
  def setup
    load_encounters
    @character = login!
  end
  
  test 'get show' do
    encounter = Encounter.find('homecoming')
    assert_difference '@character.reload.clues', -Encounter.cost do    
      get :show, :encounter_id => encounter._id, :id => encounter.paths.first._id
    end
    assert_equal encounter, assigns(:encounter), 'expected encounter assigned'
    assert !assigns(:success).blank?, 'expected success status assigned'
    assert_equal encounter.paths.first._id, assigns(:path)._id, 'expected path assigned'
  end
  
  test 'get show and demise' do
    demise = Demise.create!(:limit => 10, :_id => 'pathology.madness', :location => 'arkham_sanitarium', :title => 'test')
    encounter = Encounter.find('homecoming')
    encounter.paths.first.awards << Award.new(:_id => 'pathology.madness', :value => demise.limit)
    encounter.save!
    
    get :show, :encounter_id => encounter._id, :id => encounter.paths.first._id
    assert !assigns(:demise).blank?, 'expected demise assigned'
    assert_redirected_to demise_path('madness'), 'expected redirection after demise'
    assert_equal demise.location, @character.reload.location.value, 'expected new location after demise'
  end  
  
  test 'get show with demise' do
    demise = Demise.create!(:limit => 10, :_id => 'pathology.madness', :location => 'arkham_sanitarium', :title => 'test')
    @character.profile.set('pathology', 'madness', 10)
    @character.profile.save
    encounter = Encounter.find('homecoming')
    
    get :show, :encounter_id => encounter._id, :id => encounter.paths.first._id
    assert !assigns(:demise).blank?, 'expected demise assigned'
    assert_response :success, 'expected http success'
    assert_template :show, 'expected show template'
  end
end