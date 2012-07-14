require 'test_helper'

class PassagesControllerTest < ActionController::TestCase
  tests PassagesController

  test 'put update' do
    load_locations
    character = login!
    
    put :update, :id => 'arkham_merchant_district'
    character.reload
    assert_equal 'arkham_merchant_district', character.location.value, 'expected character to update current location tag'
    assert_redirected_to locations_path, 'expected redirected to map after travel'
  end
  
  test 'put update and encounter monster' do  
    range = Monster::ENCOUNTER_CHANCE_RANGE
    Monster.send :remove_const, :ENCOUNTER_CHANCE_RANGE
    Monster.send :const_set, :ENCOUNTER_CHANCE_RANGE, 1
    
    load_locations
    load_monsters
    character = login!
  
    put :update, :id => 'arkham_merchant_district'
    assert !assigns(:monster).blank?, 'expected monster assigned'
    assert_redirected_to new_location_monster_path('arkham_merchant_district'), 'expected redirected to monster path for combat'
    assert_not_nil character.reload.monster_id, 'exepected character monster id set'
   
    Monster.send :remove_const, :ENCOUNTER_CHANCE_RANGE
    Monster.send :const_set, :ENCOUNTER_CHANCE_RANGE, range
  end
end