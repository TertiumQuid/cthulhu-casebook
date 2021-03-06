class CharactersController < ApplicationController
  def edit
    @character = current_character
    @equipment = Equipment.find_for @character.profile.find_tagging('equipment')
  end
  
  def show
    if @character = Character.find(params[:id])
      @equipment = Equipment.find_for @character.profile.find_tagging('equipment')
    end
  end
  
  def new
    @character = Character.new
  end
  
  def create
    @character = Character.new_for_user params[:character]
    if @character.save
      session[:user_id] = @character.user_id
      authenticate_character @character._id
      redirect_to intro_encounter_path
    else
      render 'new'
    end
  end  
  
  private
  
  def intro_encounter_path
    encounter_path(:homecoming)
  end
end