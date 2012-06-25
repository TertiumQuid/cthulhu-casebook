class Profile
  include MongoMapper::Document
  
  many :taggings
  belongs_to :character
  
  before_create :populate
  
  def get(tagging_id, tag_id)
    tagging = find_tagging(tagging_id)
    tag = tagging && tagging.get(tag_id)
  end
  
  def set(tagging_id, tag_id, value)
    tag = get(tagging_id, tag_id)
    if tag
      tag.set(value) 
    elsif tagging = find_tagging(tagging_id)
      tagging.tags << Tag.new(:_id => tag_id, :value => value)
    end
  end
  
  def find_tagging(tagging_id)
    taggings.select{|t| t._id == tagging_id }.first
  end
  
  private
    
  def populate
    location = Tagging.new(:_id => 'location')
    location.tags << Tag.new(:_id => 'current', :value => 'arkham_northside')

    skills = Tagging.new(:_id => 'skills')
    skills.tags << Tag.new(:_id => 'adventure', :value => 1)
    skills.tags << Tag.new(:_id => 'bureaucracy', :value => 1)
    skills.tags << Tag.new(:_id => 'clandestinity', :value => 1)
    skills.tags << Tag.new(:_id => 'conflict', :value => 1)
    skills.tags << Tag.new(:_id => 'psychology', :value => 1)
    skills.tags << Tag.new(:_id => 'scholarship', :value => 1)
    skills.tags << Tag.new(:_id => 'sorcery', :value => 1)
    skills.tags << Tag.new(:_id => 'underworld', :value => 1)

    pathology = Tagging.new(:_id => 'pathology')
    pathology.tags << Tag.new(:_id => 'madness', :value => 0)
    pathology.tags << Tag.new(:_id => 'wounds', :value => 0)

    belongings = Tagging.new(:_id => 'belongings')
    belongings.tags << Tag.new(:_id => 'american_dollars', :value => 200)

    plots = Tagging.new(:_id => 'plots')
    plots.tags << Tag.new(:_id => 'arkham', :value => 0)
    
    equipment = Tagging.new(:_id => 'equipment')    

    taggings << skills
    taggings << location  
    taggings << pathology 
    taggings << belongings     
    taggings << plots
    taggings << equipment
  end  
end