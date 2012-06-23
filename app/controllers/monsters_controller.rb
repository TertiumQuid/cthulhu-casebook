class MonstersController < ApplicationController
  def show
    @monster = current_character.monster
    redirect_to location_path if @monster.blank? 
  end
end