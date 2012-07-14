module DemisesHelper
  def link_to_demise_or_location
    if @demise.blank?
      link_to 'continue your journey', locations_path, :class => 'button continue'
    else
      link_to "you're #{@demise.title.downcase}!", demise_path(@demise._id.gsub(/\./, '_'))
    end
  end
end