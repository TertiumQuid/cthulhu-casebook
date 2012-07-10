require 'test_helper'

class RequirementSupportTest < ActiveModel::TestCase
  def setup
    @class = Path
    @instance = @class.new
    @character = Character.create!(:name => 'available', :clues => Encounter.cost)
  end
  
  def test_available_for_no_requirements
    assert_equal true, @instance.available_for?(@character), 'expected available path without requirements'        
  end

  def test_available_for_partially_matching_profile
    @character.profile.set('test', 'count', 1)
    @character.profile.save!
      
    @instance = Encounter.new
    @instance.requirements << Requirement.new(:_id => 'test.count', :value => 1)
    @instance.requirements << Requirement.new(:_id => 'test.miss', :value => 1)
    
    assert_equal false, @instance.available_for?(@character), 'expected to be unavailable for unless all requirments are met'    
  end
end