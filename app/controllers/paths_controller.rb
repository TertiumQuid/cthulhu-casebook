class PathsController < ApplicationController
  def update
    @encounter = Encounter.find(params[:encounter_id])
    @encounter.play(params[:id])
    
    redirect_to location_path
  end  
end