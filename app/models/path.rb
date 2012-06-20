class Path
  include MongoMapper::EmbeddedDocument
  
  key :title, String, :required => true
  key :text, String
  key :success_text, String
  key :failure_text, String  
  
  many :awards
end