class PassagesController < ApplicationController
  before_filter :require_no_monster
  
  
  def show
    location = Location.find current_character.location.value
    if passage = location.passage_to(params[:id])
      
      if @monster = Monster.encounters_monster_at?(current_character, location)
        current_character.encounter_monster! @monster._id
        redirect_to new_location_monster_path(params[:id]) and return
      end
      
      current_character.relocate!(params[:id])
    end
    render_location
  end
  
  def render_location
    load_location
    load_location_friends
    render 'locations/index'
  end
end