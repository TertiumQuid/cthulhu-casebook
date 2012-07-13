class PathsController < ApplicationController
  before_filter :require_no_monster
  before_filter :check_demise  
    
  def show
    @encounter = Encounter.find(params[:encounter_id])
    @success = @encounter.play(current_character, params[:id])
    @path = @encounter.find_path(params[:id])
    
    redirect_if_demise
  end
  
  private
  
  def check_demise
    @demise = current_character.profile.check_for_demise
  end
  
  def redirect_if_demise
    if @demise.blank? && @demise = current_character.profile.check_for_demise
      redirect_to demise_path(@demise.tag)
    end      
  end
end