module LocationsHelper
  def link_to_current_location
    link_to_location Passage.new(:_id => current_character.location.value), true
  end
  
  def link_to_location(passage, disabled=false)
    name = passage._id.include?('sanitarium') ? passage._id : passage._id.gsub(/arkham_/, '')
    name = name.include?('outskirts') ? "&larr;#{name.titleize}&rarr;" : name.titleize
    href = disabled ? '' : location_passage_path(passage._id)
    method = disabled ? :get : :put
    
    link_to name, href, :id => passage._id, :method => method, :rel => 'nofollow', :disabled => disabled, :class => 'passage'
  end
end