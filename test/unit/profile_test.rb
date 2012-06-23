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
    profile.taggings << Tagging.new(:_id => 'test', :tags => [{:_id => 'pass'}])
    profile.set('test', 'pass', 1)
    assert_equal '1', profile.get('test', 'pass').value, 'expected value set for existing profile tag'
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
    
    ['location','traits','pathology','plots','skills'].each do |tagging|
      assert !profile.find_tagging(tagging).blank?, "expected tagging for #{tagging}"
      assert !profile.find_tagging(tagging).tags.blank?, "expected populated tags for #{tagging}"
    end
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
end