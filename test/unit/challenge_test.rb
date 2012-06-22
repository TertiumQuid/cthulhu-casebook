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
  
  def test_tag
    assert_equal 'last', @challenge.tag, 'expected last id part for tag'
  end
  
  def test_tagging
    assert_equal 'first', @challenge.tagging, 'expected first id part for tagging'
  end
  
  def test_chance_of_success
    chance = @challenge.send(:chance_of_success)
    assert_equal (50 - (@challenge.difficulty * 10)), chance, 'expected modified chance of success'
  end
  
  def test_chance_of_success_with_character_tag
    tag = Tag.new(:value => 'test')
    chance = @challenge.send(:chance_of_success)
    assert_equal (50 - (@challenge.difficulty * 10)), chance, 'expected unmodified chance of success with non-numeric tag'
    
    tag = Tag.new(:value => 10)
    chance = @challenge.send(:chance_of_success, tag)
    assert_equal (50 - (@challenge.difficulty * 10) + tag.value.to_i), chance, 'expected modified chance of success with tag'
  end  
  
  def test_difficulty_text
    assert_nil Challenge.new.difficulty_text, 'expected nil without difficulty'
    assert_not_nil @challenge.difficulty_text, 'expected text for difficulty'
  end
  
  def test_check_success
    assert_equal false, @challenge.send(:check_success, 0, 100000), 'expected failed check'
    assert_equal true, @challenge.send(:check_success, 100000, 0), 'expected successful check'    
  end
end