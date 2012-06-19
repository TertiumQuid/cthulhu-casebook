class User
  include MongoMapper::Document
  
  key :email, String, :required => true, :unique => true
  key :gender, String
  
  has_many :characters
  
  def current_character
    characters.sort(:_id).last
  end
end