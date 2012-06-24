class CharactersController < ApplicationController
  def edit
    @character = current_character
  end
  
  def new
    @character = Character.new
  end
  
  def create
    @character = Character.new_for_user params[:character]
    if @character.save
      session[:user_id] = @character.user_id
      authenticate_character @character._id
      redirect_to location_path
    else
      render 'new'
    end
  end  
end