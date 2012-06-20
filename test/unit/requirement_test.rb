require 'test_helper'

class RequirementTest < ActiveModel::TestCase
  def test_tag
    requirement = Requirement.new(:_id => 'first.middle.last')
    assert_equal 'last', requirement.tag, 'expected last id part for tag'
  end
  
  def test_tagging
    requirement = Requirement.new(:_id => 'first.middle.last')
    assert_equal 'first', requirement.tagging, 'expected first id part for tagging'
  end
  
  def test_met_by_empty
    assert_equal false, Requirement.new.met_by?(nil), 'expected false for nil profile'
    profile = Profile.new(:taggings => [{:_id => 'test', :tags => [] }])    
    assert_equal false, Requirement.new.met_by?(profile), 'expected false for tagless profile'    
  end
  
  def test_met_by_text
    tags = [{:_id => 'text', :value => 'test'}, {:_id => 'count', :value => 1}]
    profile = Profile.new(:taggings => [{:_id => 'test', :tags => tags }])
    
    requirement = Requirement.new(:_id => 'test.text', :value => 'test')
    assert_equal true, requirement.met_by?(profile), 'expected true for profile with matching text'
  end
  
  def test_met_by_count
    tags = [{:_id => 'text', :value => 'test'}, {:_id => 'count', :value => 1}]
    profile = Profile.new(:taggings => [{:_id => 'test', :tags => tags }])
    
    requirement = Requirement.new(:_id => 'test.count', :value => 1)
    assert_equal true, requirement.met_by?(profile), 'expected true for profile with matching count'
  end 
  
  def test_met_by_gt
    lesser_profile = Profile.new(:taggings => [{:_id => 'test', :tags => [{:_id => 'count', :value => 9}] }])
    greater_profile = Profile.new(:taggings => [{:_id => 'test', :tags => [{:_id => 'count', :value => 11}] }])
    requirement = Requirement.new(:_id => 'test.count', :is => 'gt', :value => 10)
    
    assert_equal false, requirement.met_by?(lesser_profile), 'expected flase for profile with matching count less than'
    assert_equal true, requirement.met_by?(greater_profile), 'expected true for profile with matching count greater than'
  end   
  
  def test_met_by_lt
    lesser_profile = Profile.new(:taggings => [{:_id => 'test', :tags => [{:_id => 'count', :value => 9}] }])
    greater_profile = Profile.new(:taggings => [{:_id => 'test', :tags => [{:_id => 'count', :value => 11}] }])
    requirement = Requirement.new(:_id => 'test.count', :is => 'lt', :value => 10)
    
    assert_equal true, requirement.met_by?(lesser_profile), 'expected true for profile with matching count less than'
    assert_equal false, requirement.met_by?(greater_profile), 'expected false for profile with matching count greater than'
  end  
end