require 'active_model/taggable_support'

class Penalty
  include MongoMapper::EmbeddedDocument
  include ActiveModel::TaggableSupport   
  
  key :value, String, :required => true
end