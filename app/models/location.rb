class Location
  include MongoMapper::Document
  
  key :short_name, String, :required => true
  key :long_name, String, :required => true
  key :text, String
  
  many :passages
  
  def passage_to(passage_id)
    passages.select{ |p| p._id == passage_id }.first
  end
end