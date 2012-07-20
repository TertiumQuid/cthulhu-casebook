class MonstersController < ApplicationController
  before_filter :require_monster
  before_filter :load_monster, :only => [:new, :show]
  helper_method :is_taking_passage?
  
  def new
  end
  
  def show
    @success = @monster.fight(current_character, params[:id])
    
    if @demise = current_character.profile.check_for_demise
      current_character.profile.save
    else
      current_character.relocate!(params[:location_id]) if @success && is_taking_passage?
    end
  end
  
  private
  
  def is_taking_passage?
    params[:location_id] && 
    Location.find(current_character.location.value).passage_to(params[:location_id])
  end
end