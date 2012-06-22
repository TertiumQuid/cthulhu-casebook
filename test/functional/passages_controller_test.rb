require 'test_helper'

class PassagesControllerTest < ActionController::TestCase
  tests PassagesController

  test 'put update' do
    load_locations
    character = login!
    
    put :update, :id => 'miskatonic_university'
    character.reload
    assert_equal 'miskatonic_university', character.location.value, 'expected character to update current location tag'
  end
end