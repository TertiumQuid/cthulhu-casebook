class LocationsController < ApplicationController
  def show
    @location = Location.first
    @encounters = Encounter.find_location( @location._id ) if @location
  end
  
  def index
  end  
end