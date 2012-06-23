require 'active_model/taggable_support'

class Award
  include MongoMapper::EmbeddedDocument
  include ActiveModel::TaggableSupport   
  
  key :value, String, :required => true
  
  def display?
    tagging != 'plots'
  end
  
  def apply_to!(character)
    character.profile.set tagging, tag, value
  end
end