require 'test_helper'

class EncounterTest < ActiveModel::TestCase
  def setup
    @character = Character.create!(:name => 'available', :clues => Encounter.cost)
    @character.profile.taggings << Tagging.new(:id => 'test')
    @character.profile.save!
  end
  
  def test_find_location
    load_encounters
    encounters = Encounter.find_location('arkham_northside')
    assert_operator encounters.size, ">", 0, 'expected to find location encounters'
    assert_operator encounters.size, "<", Encounter.count, 'expected locational subset of all encounters'
    assert_operator encounters.size, "==", encounters.select{ |l| l.location != 'arkahm'}.size, 'expected only location encounters'
  end
  
  def test_cost
    assert_equal 1, Encounter.cost, 'expected default cost of 1 clue'
  end
  
  def test_play_clues_cost
    path = Path.new(:title => 'test')
    encounter = Encounter.create!(:title => 'test', :text => 'test', :paths => [path])
    assert_equal true, encounter.play(@character, path._id), 'expected successful (true) play'
    @character.reload
    assert_equal 0, @character.clues, 'expected clues reduced from encounter cost'
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
  
  def test_play_requirements
    path = Path.new(:title => 'test')
    path.requirements << Requirement.new(:id => 'test.test', :cost => true, :value => -1)
    path.save!
    @character.profile.set('test', 'test', 1)
    @character.profile.save!
    
    encounter = Encounter.create!(:title => 'test', :text => 'test', :paths => [path])
    assert_difference "@character.reload.profile.get('test', 'test').value.to_i", -1, 'expected requirement cost deducted' do
      assert encounter.play(@character, path._id), 'expected successful (true) play'
    end
  end  
  
  def test_play_with_challenge_success
    path = Path.new(:title => 'test')
    path.challenge = Challenge.new(:_id => 'skills.conflict', :difficulty => 1)
    path.save!    
    @character.profile.set('skills', 'conflict', 100)
    @character.profile.save!
    
    encounter = Encounter.create!(:title => 'test', :text => 'test', :paths => [path])    
    assert_difference "@character.reload.profile.get('experience', 'conflict').value.to_i", +1, 'expected exeperience awarded' do
      assert encounter.play(@character, path._id), 'expected successful (true) play'
    end    
  end  
  
  def test_play_with_challenge_failure
    path = Path.new(:title => 'test')
    path.challenge = Challenge.new(:_id => 'skills.conflict', :difficulty => 100)
    path.save!    
    
    encounter = Encounter.create!(:title => 'test', :text => 'test', :paths => [path])
    assert_no_difference "@character.reload.profile.get('experience', 'conflict').value.to_i", 'expected no exp development after failure' do
      assert !encounter.play(@character, path._id), 'expected failed (false) play'
    end    
  end  
  
  def test_play_with_demise
    demise = Demise.create!(:_id => 'pathology.madness', :location => 'arkham_sanitarium', :limit => 1, :title => 'test')
    @character.profile.set('location', 'current', 'arkham_northside')
    @character.profile.set('pathology', 'madness', 1)
    path = Path.new(:title => 'test')
    encounter = Encounter.create!(:title => 'test', :text => 'test', :paths => [path])
    
    encounter.play(@character, path._id)
    assert_equal demise.location, @character.reload.location.value, 'expected character to move to demise location after reaching limit'
  end
  
  def test_play_without_clues
    @character.clues = 0
    path = Path.new(:title => 'test')    
    encounter = Encounter.create!(:title => 'test', :text => 'test', :paths => [path])
    assert_equal false, encounter.play(@character, path._id), 'expected unsuccessful (false) play with 0 clues'
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
  
  def test_requirement_display
    encounter = Encounter.new
    trait = Requirement.new(:_id => 'traits.trait_test', :value => 1)
    pathology = Requirement.new(:_id => 'pathology.path_test', :value => 1)    
    belonging = Requirement.new(:_id => 'belongings.belonging_test', :value => 1)
    junk = Requirement.new(:_id => 'junk.junk_test', :value => 1)        
    [trait,pathology,belonging,junk].each { |r| encounter.requirements << r }
      
    requirements = encounter.requirement_display.split(', ')
    [trait,pathology,belonging].each do |requirement|
      assert requirements.include?(requirement.text), 'expected requirement in display'
    end
    assert !requirements.include?(junk.text), 'expected requirement hidden from display'    
  end
end