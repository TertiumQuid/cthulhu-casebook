require 'test_helper'

class TrappingsControllerTest < ActionController::TestCase
  tests TrappingsController
  
  def setup
    load_equipment
    @character = login!
  end
  
  test 'put update' do
    @character.profile.set('equipment', '38_revolver', 1) && @character.profile.save!
    
    put :update, :equipment_id => '38_revolver', :id => 'hand'
    assert !assigns(:equipment).blank?, 'expected equipment found'

    assert_equal '38_revolver', @character.reload.profile.trappings.get('right_hand')._id, 'expected equipment assigned to hand'
    assert_redirected_to edit_character_path, 'expected returned to edit character profile'
  end
end