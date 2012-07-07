require 'test_helper'

class PathTest < ActiveModel::TestCase
  def setup
    @path = Path.new
    @path.awards << Award.new(:value => '1')
    @path.awards << Award.new(:value => '2')
    @path.awards << Award.new(:value => 'test')
    @path.awards << Award.new(:value => '-3')    

    @character = Character.create!(:name => 'available', :clues => Encounter.cost)
    @character.profile.taggings << Tagging.new(:id => 'test')
    @character.profile.save!    
  end
  
  def test_awards_gained
    assert_equal [@path.awards[0], @path.awards[1], @path.awards[2]], @path.awards_gained, 'expected all positive value awards'
  end
  
  def test_awards_lost
    assert_equal [@path.awards[3]], @path.awards_lost, 'expected only negative value awards'
  end
  
  def test_available_for_no_requirements
    assert_equal true, @path.available_for?(@character), 'expected available path without requirements'        
  end
  
  def test_available_for_matching_profile
    @character.profile.set('test', 'count', 1)
    @character.profile.save!
      
    @path.requirements << Requirement.new(:_id => 'test.count', :value => 1)
    assert_equal true, @path.available_for?(@character), 'expected available path for profile with matching count'    
  end
  
  def test_available_for_non_matching_profile
    @character.profile.set('test', 'count', 0)
    @character.profile.save!
  
    @path.requirements << Requirement.new(:_id => 'test.count', :value => 1)
    assert_equal false, @path.available_for?(@character), 'expected no available path for profile without matching count'  
  end  
  
  def test_develops_experience
    assert_equal false , @path.develops_experience?, 'expected no exp development without challenge'
    
    @path.challenge = Challenge.new
    assert_equal false , @path.develops_experience?, 'expected no exp development without skill challenge'
    
    @path.challenge._id = 'skills.conflict'
    assert_equal true, @path.develops_experience?, 'expected exp development with skill challenge'
  end
  
  def test_advances_skill                                         
    tag = 'conflict'
    assert_equal false, @path.advances_skill?(@character.profile, tag), 'expected no advance by default'
    
    @character.profile.set('experience', tag, @character.profile.get('skills', tag).value, true)
    assert_equal false, @path.advances_skill?(@character.profile, tag), 'expected no advance when exp equal to skill'
    
    @character.profile.set('experience', tag, @character.profile.get('skills', tag).value.to_i + 1, true)
    assert_equal true, @path.advances_skill?(@character.profile, tag), 'expected advance when exp greater than skill'
  end
  
  def test_develop
    @path.challenge = Challenge.new
    @path.challenge._id = 'skills.conflict'
    assert_difference "@character.profile.get('experience', 'conflict').value.to_i", +1, 'expected exeperience awarded' do
      @path.develop(@character)
    end
    assert_equal @character.reload.profile.get('experience', 'conflict').value.to_i, 0, 'expected profile updated but not saved'
  end
end