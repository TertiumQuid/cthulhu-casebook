class Lodging
  include MongoMapper::Document
  
  key :name, String
  key :description, String
  key :level, Integer
end