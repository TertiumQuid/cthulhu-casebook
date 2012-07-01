class ConferencesController < ApplicationController
  def show
     @conference = Conference.confer(current_character._id, params[:character_id])    
     redirect_to location_path
  end
end