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
  
  private
  
  def find_tagging(tagging_id)
    taggings.select{|t| t._id == tagging_id }.first
  end
  
  def populate
    location = Tagging.new(:_id => 'location')
    location.tags << Tag.new(:_id => 'current', :value => 'arkham')

    traits = Tagging.new(:_id => 'traits')
    traits.tags << Tag.new(:_id => 'athletic', :value => 1)
    traits.tags << Tag.new(:_id => 'clandestine', :value => 1)
    traits.tags << Tag.new(:_id => 'dangerous', :value => 1)
    traits.tags << Tag.new(:_id => 'educated', :value => 1)    
    traits.tags << Tag.new(:_id => 'logical', :value => 1)
    traits.tags << Tag.new(:_id => 'persuasive', :value => 1)
    traits.tags << Tag.new(:_id => 'resourceful', :value => 1)
    traits.tags << Tag.new(:_id => 'weird', :value => 1)

    pathology = Tagging.new(:_id => 'pathology')
    pathology.tags << Tag.new(:_id => 'madness', :value => 0)
    pathology.tags << Tag.new(:_id => 'wounds', :value => 0)

    belongings = Tagging.new(:_id => 'belongings')
    belongings.tags << Tag.new(:_id => 'american_dollars', :value => 10)

    plots = Tagging.new(:_id => 'plots')
    plots.tags << Tag.new(:_id => 'arkham', :value => 0)

    taggings << traits
    taggings << location  
    taggings << pathology 
    taggings << belongings     
    taggings << plots
  end  
end