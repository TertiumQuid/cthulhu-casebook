require 'test_helper'

class DemiseTest < ActiveModel::TestCase
  def test_apply_to
    character = Character.create!(:name => 'test')
    demise = Demise.new(:location => 'test')
    
    character.profile.set('experience', 'adventure', 10)
    assert_difference "character.profile.get('experience', 'adventure').count", -10, 'expected experience lost on demise' do
      demise.apply_to(character.profile)
    end
    assert_equal 'test', character.location.value, 'expected demise applied to character location'
  end
  
  def test_met_by
    lesser_profile = Profile.new(:taggings => [{:_id => 'test', :tags => [{:_id => 'count', :value => 9}] }])
    greater_profile = Profile.new(:taggings => [{:_id => 'test', :tags => [{:_id => 'count', :value => 11}] }])
    demise = Demise.new(:_id => 'test.count', :limit => 10)

    assert_equal false, demise.met_by?(Profile.create), 'expected false for unmet profile'
    assert_equal false, demise.met_by?(lesser_profile), 'expected flase for profile with matching count less than'
    assert_equal true, demise.met_by?(greater_profile), 'expected true for profile with matching count greater than'
  end
  
  def test_locations
    Demise.create!(:location => 'test', :title => 'test')
    Demise.create!(:location => 'test', :title => 'test')
    assert_equal ['test'], Demise.locations, 'expected all and only unique demise locations mapped'
  end
end