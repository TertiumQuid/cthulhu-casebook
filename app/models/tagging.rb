class Tagging
  include MongoMapper::EmbeddedDocument
  
  many :tags
  
  def get(tag_id)
    tags.select{|t| t._id == tag_id}.first
  end  
end