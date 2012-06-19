class Profile
  include MongoMapper::Document
  
  many :taggings
  belongs_to :character
  
  before_create :populate
  
  private
  
  def populate
    location = Tagging.new(:_id => 'location')
    location.tags << Tag.new(:_id => 'current', :text => 'arkham')

    traits = Tagging.new(:_id => 'attributes')
    traits.tags << Tag.new(:_id => 'athletic', :count => 1)
    traits.tags << Tag.new(:_id => 'clandestine', :count => 1)
    traits.tags << Tag.new(:_id => 'dangerous', :count => 1)
    traits.tags << Tag.new(:_id => 'educated', :count => 1)    
    traits.tags << Tag.new(:_id => 'logical', :count => 1)
    traits.tags << Tag.new(:_id => 'persuasive', :count => 1)
    traits.tags << Tag.new(:_id => 'resourceful', :count => 1)
    traits.tags << Tag.new(:_id => 'weird', :count => 1)

    pathology = Tagging.new(:_id => 'pathology')
    pathology.tags << Tag.new(:_id => 'madness', :count => 0)
    pathology.tags << Tag.new(:_id => 'wounds', :count => 0)

    belongings = Tagging.new(:_id => 'belongings')
    belongings.tags << Tag.new(:_id => 'american_dollars', :count => 10)

    plots = Tagging.new(:_id => 'plots')
    belongings.tags << Tag.new(:_id => 'welcome_to_arkham', :count => 1)

    taggings << traits
    taggings << location  
    taggings << pathology 
    taggings << belongings     
    taggings << plots
  end  
end