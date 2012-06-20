class Requirement
  include MongoMapper::EmbeddedDocument
  
  key :value, String, :default => 1, :required => true
  key :is, String
  
  def text
    "#{value} #{tag}"
  end
  
  def tag
    _id.to_s.split('.').last if _id
  end
  
  def tagging
    _id.to_s.split('.').first if _id
  end
  
  def met_by?(profile)
    return false if profile.blank?
    
    match = profile.get(tagging, tag)
    if match.nil? || match.value.nil?
      false
    elsif is == 'gt'
      match.value.to_i > value.to_i
    elsif is == 'lt'
      match.value.to_i < value.to_i
    else
      match.value.to_s == value.to_s
    end
  end
end