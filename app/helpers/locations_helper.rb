module LocationsHelper
  def link_to_current_location
    link_to_location Passage.new(:_id => current_character.location.value), true, location_path
  end
  
  def link_to_location(passage, disabled=false, url=nil)
    name = passage._id.include?('sanitarium') ? passage._id : passage._id.gsub(/arkham_/, '')
    name = name.include?('outskirts') ? "&larr;#{name.titleize}&rarr;" : name.titleize
    href = url || (disabled ? '' : location_passage_path(passage._id))
    
    link_to name, href, :id => passage._id, :rel => 'nofollow', 
            :disabled => disabled, :class => "passage label label-#{(disabled ? 'info' : 'success')}"
  end
end