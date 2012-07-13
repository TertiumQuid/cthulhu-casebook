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
  
  ENCOUNTER_CHANCE_RANGE = 40
  
  def self.find_location(location)
    where(:locations => location)
  end  
  
  def self.encounters_monster_at?(character, location)
    return unless character && location
    if monsters = find_location(location._id).all
      has_encounter = false
      monsters.sort_by{ |m| m.prevalence }.each do |monster|
        score = rand(ENCOUNTER_CHANCE_RANGE)
        has_encounter = (score <= monster.prevalence)
        return monster if has_encounter
      end
    end
    nil
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