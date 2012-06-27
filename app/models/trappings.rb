class Trappings
  include MongoMapper::EmbeddedDocument  

  key :left_hand, Object
  key :right_hand, Object
  
  def locations; ['left_hand','right_hand']; end
  
  def get(location)
    Equipment.new(send(location)) if respond_to?(location) && !send(location).blank?
  end
  
  def equip!(equipment, location=nil)
    left = self.left_hand
    right = self.right_hand
        
    case equipment.location.to_s
    when 'hand'
      if right.blank?
        self.right_hand = equipment.to_mongo
      elsif left.blank?  
        self.left_hand = equipment.to_mongo
      else
        self.left_hand = right
        self.right_hand = equipment.to_mongo
      end
    end
    save
  end
  
  def unequip!(equipment_or_location)
    if equipment_or_location
      case equipment_or_location.to_s
      when 'left_hand'
        self.left_hand = nil
      when 'right_hand'
        self.right_hand = nil
      else
        locations.each do |location|
          is_matching_equipment = self.respond_to?(location) && 
                                  get(location) && 
                                  get(location)._id == equipment_or_location
          self.send("#{location}=", nil) if is_matching_equipment
        end
      end
    end
    save
  end

  def modifier_for(*tags)
    modifiers = []
    tags.each do |tag|
      locations.each do |location|
        if get(location)
          modifiers = modifiers + get(location).modifiers.select{ |m| m._id == tag }
        end
      end        
    end
    modifiers.map{ |m| m.value.to_i }.sum || 0
  end
  
  def location_of(equipment)
    locations.each do |location|
      return location if get(location) && get(location)._id == equipment
    end
    nil
  end
end