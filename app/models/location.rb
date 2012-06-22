class Location
  include MongoMapper::Document
  
  key :short_name, String, :required => true
  key :long_name, String, :required => true
  key :text, String
  
  many :passages
end