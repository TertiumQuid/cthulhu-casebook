class Path
  include MongoMapper::EmbeddedDocument
  
  key :title, String, :required => true
  key :text, String
  key :description, String  
end