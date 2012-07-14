class Lodging
  include MongoMapper::Document
  
  key :name, String, :required => true
  key :description, String
  key :level, Integer
end