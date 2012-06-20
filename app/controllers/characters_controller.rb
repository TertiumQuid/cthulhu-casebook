class CharactersController < ApplicationController
  def edit
    @character = current_character
  end
  
  def new
    @character = Character.new
  end
  
  def create
    @character = Character.new(params[:character])
    if @character.save
      authenticate_character @character._id
      redirect_to location_path
    else
      render 'new'
    end
  end  
end