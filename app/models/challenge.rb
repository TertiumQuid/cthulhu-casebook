class Challenge
  include MongoMapper::EmbeddedDocument
  
  key :difficulty, Integer, :required => true  
  
  def tag
    _id.to_s.split('.').last if _id
  end
  
  def tagging
    _id.to_s.split('.').first if _id
  end
end