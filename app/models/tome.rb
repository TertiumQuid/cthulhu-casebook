class Tome
  include MongoMapper::Document
  
  key :title, String
  key :author, String
  key :language, String
  key :publication_date, String  
  key :description, String
end