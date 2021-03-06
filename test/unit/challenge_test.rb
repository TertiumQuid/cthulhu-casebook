require 'test_helper'

class ChallengeTest < ActiveModel::TestCase
  def setup
    @challenge = Challenge.new(:_id => 'first.last', :difficulty => 3)
  end
  
  def test_to_mongo
    mongo_data = Challenge.to_mongo(@challenge)
    assert_equal @challenge._id, mongo_data[:_id], 'exepected id from challenge model'
    assert_equal @challenge.difficulty, mongo_data[:difficulty], 'exepected difficulty from challenge model'    
  end
  
  def test_from_mongo
    assert_nil Challenge.from_mongo(nil), 'expected nil for nil data'
    
    challenge = Challenge.new
    assert_equal challenge, Challenge.from_mongo(challenge), 'expected challenge parameter itself'
    
    mongo_data = {:_id => 'test.text', :difficulty => 2}
    challenge = Challenge.from_mongo(mongo_data)
    assert_equal challenge._id, mongo_data[:_id], 'exepected id from challenge data'
    assert_equal challenge.difficulty, mongo_data[:difficulty], 'exepected difficulty from challenge data'
  end  
  
  def test_difficulty_text
    assert_nil Challenge.new.difficulty_text, 'expected nil without difficulty'
    assert_not_nil @challenge.difficulty_text, 'expected text for difficulty'
  end
  
  def test_develops_experience
    character = Character.create(:name => 'test')
    challenge = Challenge.new(:_id => 'skills.conflict', :difficulty => 10)
    assert_equal true, challenge.develops_experience?(character), 'expected experience when skill value under limit'
    
    character.profile.set('skills', 'conflict', Challenge::SKILL_LIMIT + challenge.difficulty) 
    character.profile.save
    assert_equal false, challenge.develops_experience?(character), 'expected no experience when skill value equal to limit'
    character.profile.set('skills', 'conflict', 1)     
    assert_equal false, challenge.develops_experience?(character), 'expected no experience when skill value above limit'    
  end
end