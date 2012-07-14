class DemisesController < ApplicationController
  def show
    @demise = Demise.find demise_id
    redirect_to location_path if @demise.blank? || !@demise.met_by?(current_character.profile)
  end
  
  private 
  
  def demise_id
    params[:id].gsub(/_/, '.')
  end
end