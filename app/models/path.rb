require 'active_model/requirement_support'

class Path
  include MongoMapper::EmbeddedDocument
  include ActiveModel::RequirementSupport  
    
  key :title, String, :required => true
  key :text, String
  key :success_text, String
  key :failure_text, String  
  key :challenge, Challenge
  
  many :awards
  
  def develop(character)
    character.profile.set 'experience', challenge.tag, 1
    
    if advances_skill? character.profile, challenge.tag
      character.profile.set('experience', challenge.tag, 0, true)
      character.profile.set('skills', challenge.tag, 1)
    end
  end
  
  def develops_experience?
    challenge && challenge.tagging == 'skills' ? true : false
  end
  
  def advances_skill?(profile, tag) 
    profile.get('experience', tag).value.to_i > profile.get('skills', tag).value.to_i
  end
  
  def awards_gained
    awards.select {|a| a.value[0] != '-' }
  end

  def awards_lost
    awards.select {|a| a.value[0] == '-' }    
  end
end