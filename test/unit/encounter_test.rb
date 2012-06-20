require 'test_helper'

class EncounterTest < ActiveModel::TestCase
  def setup
    @character = Character.create!(:name => 'available', :moxie => Encounter.cost)
    @character.profile.taggings << Tagging.new(:id => 'test')
    @character.profile.save!
  end
  
  def test_cost
    assert_equal 1, Encounter.cost, 'expected default cost of 1 moxie'
  end
  
  def test_play_moxie_cost
    path = Path.new(:title => 'test')
    encounter = Encounter.create!(:title => 'test', :text => 'test', :paths => [path])
    assert_equal true, encounter.play(@character, path._id), 'expected successful (true) play'
    @character.reload
    assert_equal 0, @character.moxie, 'expected moxie reduced from encounter cost'
  end
  
  def test_play_awards
    path = Path.new(:title => 'test')
    path.awards << Award.new(:id => 'test.test', :value => 1)
    path.save!
    
    encounter = Encounter.create!(:title => 'test', :text => 'test', :paths => [path])
    assert_equal true, encounter.play(@character, path._id), 'expected successful (true) play'
    @character.reload
    assert_equal '1', @character.profile.get('test', 'test').value
  end
  
  def test_play_without_moxie
    @character.moxie = 0
    path = Path.new(:title => 'test')    
    encounter = Encounter.create!(:title => 'test', :text => 'test', :paths => [path])
    assert_equal false, encounter.play(@character, path._id), 'expected unsuccessful (false) play with 0 moxie'
  end  
  
  def test_play_with_missing_path
    path = Path.new(:title => 'test')    
    encounter = Encounter.create!(:title => 'test', :text => 'test', :paths => [path])
    assert_equal false, encounter.play(@character, 'miss'), 'expected unsuccessful (false) play from missing path id'
  end  
  
  def test_available_for_matching_profile
    @character.profile.set('test', 'count', 1)
    @character.profile.save!
      
    encounter = Encounter.new
    encounter.requirements << Requirement.new(:_id => 'test.count', :value => 1)
    
    assert_equal true, encounter.available_for?(@character), 'expected available encounter for profile with matching count'    
  end
  
  def test_available_for_non_matching_profile
    @character.profile.set('test', 'count', 0)
    @character.profile.save!
  
    encounter = Encounter.new
    encounter.requirements << Requirement.new(:_id => 'test.count', :value => 1)
    
    assert_equal false, encounter.available_for?(@character), 'expected no available encounter for profile without matching count'  
  end  
  
  def test_find_path
    encounter = Encounter.new
    path1 = Path.new(:_id => 'test')
    path2 = Path.new(:_id => 'pass')
    assert_nil encounter.find_path(nil), 'expected nil for blank path'    
    assert_nil encounter.find_path('test'), 'expected nil when encounter has no paths'
    encounter.paths << path1
    encounter.paths << path2    
    assert_equal path1, encounter.find_path('test'), 'expected to find path with id'
  end  
end