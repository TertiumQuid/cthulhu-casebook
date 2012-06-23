require 'active_model/tagged_support'

class Lure
  include MongoMapper::EmbeddedDocument
  include ActiveModel::TaggedSupport
  
  key :factor, Float
end