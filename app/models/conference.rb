class Conference
  include MongoMapper::Document
  
  key :character_ids, Array
  key :conferred_at, Time
  
  before_create :set_conferred_at
  
  COOLDOWN_HOURS = 24
  
  def self.find_for(first_chracter_id, second_character_id)
    where(:character_ids => first_chracter_id, :character_ids => second_character_id).first
  end
  
  def self.recent(chracter_id)  
    where(:character_ids => chracter_id, :conferred_at.gt => (now - COOLDOWN_HOURS.hours) )
  end
  
  def self.find_for_or_new(first_chracter_id, second_character_id)
    find_for(first_chracter_id, second_character_id) ||
    Conference.new(:character_ids => [first_chracter_id, second_character_id])    
  end
  
  def self.confer(first_chracter_id, second_character_id)
    conference = find_for_or_new(first_chracter_id, second_character_id)
    
    if conference.is_cooling_down?
      conference.errors.add(:conferred_at, "Already conferred once today today")
    else
      first_character = Character.find(first_chracter_id)
      second_character = Character.find(second_character_id)
      
      if first_character.location.value == second_character.location.value
        conference.set_conferred_at && conference.save
        first_character.increment(:clues => 1)
        second_character.increment(:clues => 1)
      else
        conference.errors.add(:character_ids, "Cannot confer from different locations")
      end
    end
    conference
  end
  
  def self.now
    Time.now.utc
  end

  def now
    Conference.now
  end
  
  def is_cooling_down?
    !conferred_at.blank? && (conferred_at >= now - COOLDOWN_HOURS.hours)
  end
  
  def set_conferred_at
    self.conferred_at = now
  end
end