class Tagging
  include MongoMapper::EmbeddedDocument
  
  many :tags
end