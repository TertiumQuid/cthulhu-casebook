require 'test_helper'

class ProfileTest < ActiveModel::TestCase
  def test_get
    user = User.create(:email => 'test@example.com')
    
    assert_nil user.current_character, 'expected no associated character'
    
    first = user.characters.create(:name => 'first')
    last = user.characters.create(:name => 'last')    
    assert_equal last, user.current_character, 'expected last character to be current'
  end
  
  def test_set_existing
    profile = Profile.new
    assert_nothing_raised do
      profile.set('fail', 'fail', 'fail')
    end
    initial_value = 3
    profile.taggings << Tagging.new(:_id => 'test', :tags => [{:_id => 'pass', :value => initial_value}])

    assert_difference "profile.get('test', 'pass').value.to_i", +1, 'expected value incremented for existing profile tag' do
      profile.set('test', 'pass', 1)
    end
    
    profile.set('test', 'pass', 2, true)
    assert_equal 2, profile.get('test', 'pass').value.to_i, 'expected value explicitly set when forced on existing profile tag'
  end
  
  def test_set_new
    profile = Profile.new
    profile.taggings << Tagging.new(:_id => 'test')
    profile.set('test', 'pass', 1)
    assert_equal '1', profile.get('test', 'pass').value, 'expected value set for profile new tag'
  end  
  
  def test_populate
    profile = Profile.new
    profile.send(:populate)
    
    ['location','lodgings','pathology','plots','skills'].each do |tagging|
      assert !profile.find_tagging(tagging).blank?, "expected tagging for #{tagging}"
      assert !profile.find_tagging(tagging).tags.blank?, "expected populated tags for #{tagging}"
    end
    
    assert_not_nil profile.trappings, 'expected empty trappings set'
  end
  
  def test_find_tagging
    profile = Profile.new
    tagging1 = Tagging.new(:_id => 'test')
    tagging2 = Tagging.new(:_id => 'pass')
    assert_nil profile.find_tagging('test'), 'expected nil when profile has no taggings'
    profile.taggings << tagging1
    profile.taggings << tagging2    
    assert_equal tagging1, profile.find_tagging('test'), 'expected to find tagging with id'
  end
  
  def test_deduct
    profile = Profile.new
    tagging = Tagging.new(:_id => 'test', :tags => [{:_id => 'number', :value => 2}, {:_id => 'text', :value => 'test'}])
    profile.taggings << tagging 
    profile.save!
   
    assert_nil profile.deduct!('first', 'second'), 'expected nil result for missing tag' 
    
    assert_equal true, profile.deduct!('test', 'number'), 'expected profile to be saved'     
    assert_equal '1', profile.reload.get('test', 'number').value, 'expected 1 deducted from value'
    assert_equal true, profile.deduct!('test', 'number'), 'expected profile to be saved'    
    assert_nil profile.reload.get('test', 'number'), 'expected tag removed after reaching 0 value'
    
    assert_equal true, profile.deduct!('test', 'text'), 'expected profile to be saved'    
    assert_nil profile.reload.get('test', 'text'), 'expected text tag removed immediately'
  end
end