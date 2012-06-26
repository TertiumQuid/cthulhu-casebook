require 'test_helper'

class TrappingsTest < ActiveModel::TestCase
  def setup
    @profile = Profile.create
    @trappings = Trappings.new
  end
  
  def test_get
    @trappings.equip! Equipment.create!(:_id => 't1', :title => 't1', :location => 'hand')
    
    assert_nil @trappings.get('left_hand'), 'expect blank get without equipment'
    assert_not_nil @trappings.get('right_hand'), 'expect result from equipment'    
    assert @trappings.get('right_hand').is_a?(Equipment), 'expected data initialized as equipment instance'
  end
  
  def test_unequip_location
    @trappings.left_hand = Equipment.new
    @trappings.right_hand = Equipment.new    
    @trappings.save
    @profile.reload
  
    @trappings.unequip!('left_hand') && @profile.reload
    assert_nil @trappings.left_hand, 'expected left hand empty'
    
    @trappings.unequip!('right_hand') && @profile.reload
    assert_nil @trappings.left_hand, 'expected right hand empty'
  end
  
  def test_unequip_item
    @trappings.equip! Equipment.create!(:_id => 't1', :title => 't1', :location => 'hand')
    @trappings.equip! Equipment.create!(:_id => 't2', :title => 't2', :location => 'hand')    
    
    @trappings.unequip!('t1') && @profile.reload    
    assert_nil @trappings.right_hand, 'expected right hand empty'
  end  
  
  def test_equip_hands
    e1 = Equipment.create! :_id => 't1', :title => 't1', :location => 'hand'
    @trappings.equip! e1
    @profile.reload
    assert_equal e1, @trappings.get('right_hand'), 'expected equipment assigned to empty right hand'
    
    e2 = Equipment.create! :_id => 't2', :title => 't2', :location => 'hand'
    @trappings.equip! e2
    @profile.reload
    
    assert_equal e2, @trappings.get('left_hand'), 'expected equipment assigned to empty left hand'
    
    e3 = Equipment.create! :_id => 't3', :title => 't3', :location => 'hand'
    @trappings.equip! e3    
    @profile.reload
    assert_equal e3, @trappings.get('right_hand'), 'expected equipment assigned to right hand'
    assert_equal e1, @trappings.get('left_hand'), 'expected right hand equipment moved to left hand'
  end
  
  def test_location_of
    assert_nil @trappings.location_of('fail'), 'expected nil for missing equipment'
    @trappings.equip! Equipment.create! :_id => 'test', :title => 'test', :location => 'hand'
    assert_equal 'right_hand', @trappings.location_of('test'), 'expected equipment in right hand'
  end
end