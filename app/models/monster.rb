require 'active_model/requirement_support'

class Monster
  include MongoMapper::Document
  include ActiveModel::RequirementSupport
  
  key :name, String, :required => true
  key :description, String  
  key :locations, Array
  
  many :requirements
  many :lures  
  
  ENCOUNTER_CHANCE_RANGE = 10
  
  def self.find_location(location)
    where(:locations => location)
  end  
  
  def self.encounters_monster_at?(character, location, monster_chance=5)
    return unless character && location
    if rand(ENCOUNTER_CHANCE_RANGE) <= monster_chance
      if monsters = find_location(location._id).all
        random_monster = monsters[ rand(monsters.size-1) ]
      end
    end
  end
end