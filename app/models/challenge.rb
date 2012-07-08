require 'active_model/taggable_support'
require 'active_model/contestable_support'

class Challenge
  include MongoMapper::EmbeddedDocument
  include ActiveModel::TaggableSupport 
  include ActiveModel::ContestableSupport
    
  key :difficulty, Integer, :required => true 
  
  SKILL_LIMIT = 25
  
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
  
  def develops_experience?(character)
    character.profile.get('skills', tag).count < difficulty + SKILL_LIMIT
  end
end