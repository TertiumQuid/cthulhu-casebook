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
  
  def awards_gained
    awards.select {|a| a.value[0] != '-' }
  end

  def awards_lost
    awards.select {|a| a.value[0] == '-' }    
  end
end