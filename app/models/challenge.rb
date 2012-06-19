class Challenge
  include MongoMapper::EmbeddedDocument
  
  key :tag, String, :required => true  
end