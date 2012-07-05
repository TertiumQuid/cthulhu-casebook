require 'active_model/requirement_support'

class Encounter
  include MongoMapper::Document
  include ActiveModel::RequirementSupport
  
  key :title, String, :required => true
  key :description, String
  key :location, String
  key :type, String  
  
  many :paths
  
  def self.find_location(location)
    where(:location => location)
  end  
  
  def self.cost; 1; end
  
  def play(character, path_id)
    if character.clues >= Encounter.cost && path = find_path(path_id)
      succeeded = path.challenge ? path.play(character) : true
      
      path.awards.each { |a| a.apply_to(character) }
      path.requirements.each { |r| r.apply_to(character) if r.cost }
      
      character.spend_clues Encounter.cost
      character.profile.save && character.save
    else
      false
    end
  end
  
  def find_path(path_id)
    return nil if path_id.blank?
    paths.select{|p| p._id.to_s == path_id.to_s }.first
  end
end