class Encounter
  include MongoMapper::Document
  
  key :title, String, :required => true
  key :text, String, :required => true
  
  many :paths
  many :requirements  
  
  def self.cost; 1; end
  
  def play(character, path_id)
    if character.moxie >= Encounter.cost && path = find_path(path_id)
      path.awards.each do |award|
        award.apply_to! character
      end
      character.moxie = character.moxie - Encounter.cost
      character.profile.save && character.save
    else
      false
    end
  end
  
  def available_for?(character)
    requirements.select{ |r| r.met_by? character.profile }.size > 0
  end
  
  def find_path(path_id)
    return nil if path_id.blank?
    paths.select{|p| p._id.to_s == path_id.to_s }.first
  end
end