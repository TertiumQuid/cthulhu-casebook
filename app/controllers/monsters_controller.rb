class MonstersController < ApplicationController
  before_filter :require_monster
  helper_method :is_taking_passage?
  
  def new
    @monster = current_character.monster
  end
  
  def show
    @monster = current_character.monster
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