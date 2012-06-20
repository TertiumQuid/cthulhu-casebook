class Award
  include MongoMapper::EmbeddedDocument
  
  key :value, String, :required => true  
  
  def tag
    _id.to_s.split('.').last if _id
  end
  
  def tagging
    _id.to_s.split('.').first if _id
  end
  
  def apply_to!(character)
    character.profile.set tagging, tag, value
  end
end