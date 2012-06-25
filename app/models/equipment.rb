class Equipment
  include MongoMapper::Document
  
  set_collection_name 'equipment'

  key :title, String, :required => true
    
  many :modifiers, :class_name => 'Tag'
  
  def self.find_for(equipment_tagging)
    where(:_id => {'$in' => equipment_tagging.tags.map(&:_id) }) unless equipment_tagging.blank?
  end
  
  def modifier_display
    display = modifiers.map{ |m| "+#{m.value} #{m._id.split('.').last}" }
    display = display.join(', ')
  end
end