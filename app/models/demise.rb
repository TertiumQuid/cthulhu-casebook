require 'active_model/taggable_support'

class Demise
  include MongoMapper::Document
  include ActiveModel::TaggableSupport
  
  key :title, String, :required => true
  key :limit, Integer, :default => 10
  key :description, String
  key :location, String
  
  class << self
    def locations
      all.map(&:location).uniq
    end
  end
  
  def met_by?(profile)
    if match = profile.get(tagging, tag)
      match.count >= limit
    else
      false
    end
  end
  
  def apply_to(profile)
    unless Demise.locations.include? profile.get('location', 'current').value
      profile.set('location', 'current', location)
      if exp = profile.find_tagging('experience')
        exp.tags.each { |t| t.value = 0 }
      end
    end
  end
end