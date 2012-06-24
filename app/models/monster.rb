require 'active_model/requirement_support'
require 'active_model/contestable_support'

class Monster
  include MongoMapper::Document
  include ActiveModel::RequirementSupport
  include ActiveModel::ContestableSupport  
  
  key :name, String, :required => true
  key :description, String  
  key :locations, Array
  
  many :requirements
  many :lures  
  many :penalties
  
  ENCOUNTER_CHANCE = 5
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
    skills = character.profile.find_tagging('skills')
    succeeded = case strategy.to_s
    when 'fight'
      check_success chance_of_success(skills.get('conflict'))
    when 'escape'
      check_success chance_of_success(skills.get('adventure'))
    when 'stealth'
      check_success chance_of_success(skills.get('clandestinity'))
    when 'magic'      
      check_success chance_of_success(skills.get('sorcery'))
    when 'confront'
      character.spend_clues && true
    end
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
end