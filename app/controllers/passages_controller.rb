class PassagesController < ApplicationController
  before_filter :require_no_monster
  
  def update
    location = Location.find current_character.location.value
    if passage = location.passages.select{ |p| p._id == params[:id]}
      current_character.profile.set('location', 'current', params[:id])
      
      if @monster = Monster.encounters_monster_at?(current_character, location)
        current_character.encounter_monster! @monster._id
        redirect_to monster_path and return
      end
      
      current_character.profile.save
    end
    
    redirect_to location_path
  end
end