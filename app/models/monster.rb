require 'active_model/requirement_support'
require 'active_model/contestable_support'

class Monster
  include MongoMapper::Document
  include ActiveModel::RequirementSupport
  include ActiveModel::ContestableSupport  
  
  key :name, String, :required => true
  key :description, String
  key :locations, Array
  key :prevalence, Integer
  
  many :requirements
  many :lures  
  many :penalties
  
  ENCOUNTER_CHANCE = 4
  ENCOUNTER_CHANCE_RANGE = 10
  
  def self.find_location(location)
    where(:locations => location)
  end  
  
  def self.encounters_monster_at?(character, location, monster_chance=ENCOUNTER_CHANCE)
    return unless character && location
    score = rand(ENCOUNTER_CHANCE_RANGE)
    if score <= monster_chance
      if monsters = find_location(location._id).all
        random_monster = monsters[ rand(monsters.size-1) ]
      end
    end
  end
  
  def difficulty; 1; end
  
  def fight(character, strategy)
    succeeded = defeats_monster?(character, strategy)
    penalize(character) && character.profile.save unless succeeded
    character.monster_id = nil
    character.save
    succeeded
  end
  
  def penalize(character)
    penalties.each do |penalty|
      penalty.apply_to(character)
    end
  end
  
  private
  
  def defeats_monster?(character, strategy)
    skills = character.profile.find_tagging('skills')
    trappings = character.profile.trappings
    
    case strategy.to_s
    when 'fight'
      check_success combined_chance_of_success skills, trappings, 'conflict', 'fight'
    when 'escape'
      check_success combined_chance_of_success skills, trappings, 'adventure', 'escape'      
    when 'stealth'
      check_success combined_chance_of_success skills, trappings, 'clandestinity', 'stealth'
    when 'magic'      
      check_success combined_chance_of_success skills, trappings, 'sorcery', 'magic'
    when 'confront'
      character.spend_clues && true
    end    
  end
  
  def combined_chance_of_success(skills, trappings, skill, strategy)
    skill_chance = chance_of_success( skills.get(skill) )
    equipment_bonus = trappings.modifier_for("skills.#{skill}", strategy)
    skill_chance + equipment_bonus
  end
end