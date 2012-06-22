require 'active_model/tagged_support'

class Challenge
  include MongoMapper::EmbeddedDocument
  include ActiveModel::TaggedSupport 
    
  key :difficulty, Integer, :required => true 
  
  def self.to_mongo(value)
    return nil if value.blank?
    return value if value.is_a?(Hash)
    
    {:_id => value._id, :difficulty => value.difficulty }
  end

  def self.from_mongo(value)
    return nil if value.blank?
    return value if value.is_a?(self)
    
    value = HashWithIndifferentAccess.new(value)    
    Challenge.new(:_id => value[:_id], :difficulty => value[:difficulty])
  end
  
  def play(character)
    if character_tag = character.profile.get(tagging, tag)
      check_success chance_of_success(character_tag)
    else
      false
    end
  end
  
  def difficulty_text
    case difficulty
    when nil
      nil
    when 1
      'Simple'
    when 2
      'Very easy'      
    when 3
      'Easy'
    when 4, 5
      'Moderate'
    when 6
      'Difficult'
    when 7,8
      'Very difficult'
    else
      'Impossible'
    end
  end
    
  private
  
  def check_success(chance, max_range=100)
    chance = [chance, 3].max
    chance = [chance, 97].min
    rand(max_range) <= chance
  end
  
  def chance_of_success(character_tag=nil)
    base = 50 - (difficulty * 10)
    base = base + character_tag.value.to_i unless character_tag.blank? || !character_tag.send(:numeric?)
    base
  end
end