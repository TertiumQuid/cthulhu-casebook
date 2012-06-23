require 'active_model/taggable_support'

class Lure
  include MongoMapper::EmbeddedDocument
  include ActiveModel::TaggableSupport
  
  key :factor, Float
end