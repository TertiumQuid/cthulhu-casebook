class PassagesController < ApplicationController
  def update
    location = Location.find current_character.location.value
    if passage = location.passages.select{ |p| p._id == params[:id]}
      current_character.profile.set('location', 'current', params[:id])
      current_character.profile.save
    end
    
    redirect_to location_path
  end
end