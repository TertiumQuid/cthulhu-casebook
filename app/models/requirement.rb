require 'active_model/taggable_support'

class Requirement
  include MongoMapper::EmbeddedDocument
  include ActiveModel::TaggableSupport   
  
  key :value, String, :default => 1, :required => true
  key :is, String
  key :cost, Boolean
  
  def text
    "#{(is == 'gt' ? "#{(value.to_i+1)}+" : value)} #{tag}"
  end
  
  def met_by?(profile)
    return false if profile.blank?
    
    match = profile.get(tagging, tag)
    if match.nil? || match.value.nil?
      false
    elsif is == 'gt'
      match.count > value.to_i
    elsif is == 'lt'
      match.count < value.to_i
    elsif is == 'not'
      Rails.logger.info " NOT     #{match.value} != #{value.to_s}"
      match.value != value.to_s
    elsif cost
      match.count >= value.to_i.abs
    else
      match.value == value.to_s
    end
  end
end