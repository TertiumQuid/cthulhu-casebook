class LocationsController < ApplicationController
  before_filter :load_location
  
  def show
    @encounters = Encounter.find_location( @location._id ) if @location
  end
  
  def index
  end  
  
  private
   
  def load_location
    @location = Location.find current_character.location.value
  end
end