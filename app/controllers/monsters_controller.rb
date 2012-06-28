class MonstersController < ApplicationController
  before_filter :require_monster
  
  def new
    @monster = current_character.monster
  end
  
  def show
    @monster = current_character.monster
    @success = @monster.fight(current_character, params[:id])
    
    current_character.relocate!(params[:location_id]) if is_taking_passage?
  end
  
  private
  
  def is_taking_passage?
    @success && 
    params[:location_id] && 
    Location.find(current_character.location.value).passage_to(params[:location_id])
  end
end