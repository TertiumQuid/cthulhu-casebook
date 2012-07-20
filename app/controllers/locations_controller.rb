class LocationsController < ApplicationController
  before_filter :require_no_monster  
  before_filter :load_location
  before_filter :load_location_friends, :only => [:index]
  
  def show
    @encounters = Encounter.find_location( @location._id ) if @location
  end
  
  def index
  end
end