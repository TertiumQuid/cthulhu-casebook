class Profile
  include MongoMapper::Document
  
  one  :trappings, :class_name => 'Trappings'
  many :taggings
  belongs_to :character
  
  before_create :populate
  
  def get(tagging_id, tag_id)
    tagging = find_tagging(tagging_id)
    tag = tagging && tagging.get(tag_id)
  end
  
  def set(tagging_id, tag_id, value, force_equal=false)
    tag = get(tagging_id, tag_id)
    if tag && force_equal # force explicit value
      tag.value = value
    elsif tag # increment existing value
      tag.set(value)
    elsif tagging = find_tagging(tagging_id) # create new tag for value
      tagging.tags << Tag.new(:_id => tag_id, :value => value)
    end
  end
  
  def deduct!(tagging_id, tag_id, value=1)
    if tag = get(tagging_id, tag_id)
      if tag.numeric? && tag.count > value
        tag.set(-value)
      else
        find_tagging(tagging_id).tags.delete_if{ |t| t._id == tag_id }
      end  
      save
    end
  end
  
  def find_tagging(tagging_id)
    taggings.select{|t| t._id == tagging_id }.first
  end
  
  def check_for_demise
    if demise = current_demise
      demise.apply_to(self)
      demise
    end
  end
    
  private
    
  def populate
    location = Tagging.new(:_id => 'location')
    location.tags << Tag.new(:_id => 'current', :value => 'arkham_northside')
    
    lodgings = Tagging.new(:_id => 'lodgings')
    lodgings.tags << Tag.new(:_id => 'current', :value => 'displaced')

    skills = Tagging.new(:_id => 'skills')
    skills.tags << Tag.new(:_id => 'adventure', :value => 1)
    skills.tags << Tag.new(:_id => 'bureaucracy', :value => 1)
    skills.tags << Tag.new(:_id => 'clandestinity', :value => 1)
    skills.tags << Tag.new(:_id => 'conflict', :value => 1)
    skills.tags << Tag.new(:_id => 'psychology', :value => 1)
    skills.tags << Tag.new(:_id => 'scholarship', :value => 1)
    skills.tags << Tag.new(:_id => 'sorcery', :value => 1)
    skills.tags << Tag.new(:_id => 'underworld', :value => 1)

    traits = Tagging.new(:_id => 'traits')
    affiliations = Tagging.new(:_id => 'affiliations')

    exp = Tagging.new(:_id => 'experience')
    skills.tags.each { |t| exp.tags << Tag.new(:_id => t._id, :value => 0) }

    pathology = Tagging.new(:_id => 'pathology')
    pathology.tags << Tag.new(:_id => 'madness', :value => 0)
    pathology.tags << Tag.new(:_id => 'wounds', :value => 0)

    knowledge = Tagging.new(:_id => 'knowledge')
    research = Tagging.new(:_id => 'research')    

    belongings = Tagging.new(:_id => 'belongings')
    belongings.tags << Tag.new(:_id => 'american_dollars', :value => 200)

    plots = Tagging.new(:_id => 'plots')
    plots.tags << Tag.new(:_id => 'a_hapless_stranger_comes_to_arkham', :value => 5)
    
    equipment = Tagging.new(:_id => 'equipment')    
    
    taggings << skills
    taggings << traits
    taggings << affiliations
    taggings << exp
    taggings << location 
    taggings << lodgings
    taggings << pathology 
    taggings << knowledge
    taggings << research
    taggings << belongings     
    taggings << plots
    taggings << equipment
    
    self.trappings = Trappings.new
  end  
  
  def current_demise
    Demise.all.select { |d| d.met_by?(self) }.first
  end  
end