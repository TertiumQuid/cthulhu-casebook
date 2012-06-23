require 'active_model/taggable_support'

class Requirement
  include MongoMapper::EmbeddedDocument
  include ActiveModel::TaggableSupport   
  
  key :value, String, :default => 1, :required => true
  key :is, String
  
  def text
    "#{(is == 'gt' ? "#{(value.to_i+1)}+" : value)} #{tag}"
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