module DemisesHelper
  def demised?
    @demise.blank? ? false : true
  end
  
  def link_to_demise_or_location
    if demised?
      link_to "you're #{@demise.title.downcase}!", demise_path(@demise._id.gsub(/\./, '_')), :class => 'btn btn-info'
    else  
      link_to 'continue your journey', locations_path, :class => 'btn btn-info'
    end
  end
end