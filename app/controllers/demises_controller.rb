class DemisesController < ApplicationController
  def show
    @demise = Demise.find(params[:id])
    redirect_to location_path if @demise.blank? || !@demise.met_by?(current_character.profile)
  end
end