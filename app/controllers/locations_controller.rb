class LocationsController < ApplicationController
  before_filter :require_no_monster  
  before_filter :load_location
  
  def show
    @encounters = Encounter.find_location( @location._id ) if @location
    @friends = current_character.local_friends
  end
  
  def index
  end  
  
  private
   
  def load_location
    @location = Location.find current_character.location.value
  end
end