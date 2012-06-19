class Character
  include MongoMapper::Document
  
  key :name, String, :required => true
  key :moxie, Integer, :required => true, :default => 100
  key :gender, String
  
  belongs_to :user
  has_one :profile
end