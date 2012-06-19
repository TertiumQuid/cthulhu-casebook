class LocationsController < ApplicationController
  def show
    @location = Location.first
    @encounters = Encounter.all
  end
  
  def index
  end  
end