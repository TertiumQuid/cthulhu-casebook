require 'test_helper'

class EquipmentTest < ActiveModel::TestCase
  def test_find_for
    load_equipment
    
    assert_nil Equipment.find_for(nil), 'expected nil without profile tagging'
    
    tags = [{:_id => 'winchester_shotgun'}, {:_id => 'sword_cane'}]
    profile = Profile.new(:taggings => [{:_id => 'equipment', :tags => tags}])
    tagging = profile.find_tagging('equipment')
    
    equipment = Equipment.find_for(tagging)
    assert_equal tags.size, equipment.size, 'expected all profile equipment found'
    expected_tags = ['winchester_shotgun','sword_cane']
    assert equipment.select{ |e| !expected_tags.include?(e._id) }.blank?, 'expected only matching tags found for equipment'
  end
  
  def test_modifier_display
    equipment = Equipment.new
    equipment.modifiers << Tag.new(:_id => 'test.t1', :value => 1)
    equipment.modifiers << Tag.new(:_id => 'test.t2', :value => 2)    
    assert_equal '+1 t1, +2 t2', equipment.modifier_display, 'expected formatted tag values for modifier display'
  end
end