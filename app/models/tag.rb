class Tag
  include MongoMapper::EmbeddedDocument

  key :text, Integer
  key :count, Integer
end