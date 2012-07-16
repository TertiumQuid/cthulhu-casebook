class GiftsController < ApplicationController
  before_filter :load_gift, :only => [:accept, :reject]
  
  def new
    @character = Character.find(params[:character_id])
    redirect_to location_path if @character.blank?    
    
    @equipment = current_character.profile.find_tagging('equipment')
    @belongings = current_character.profile.find_tagging('belongings')
  end
  
  def update
    Gift.give current_character, params[:character_id], params[:id]
    redirect_to location_path
  end
  
  def accept
    @gift.accept! if @gift
    redirect_to edit_character_path
  end
  
  def reject
    @gift.reject! if @gift
    redirect_to edit_character_path    
  end
  
  private
  
  def load_gift
    @gift = Gift.first(:id => params[:id], :recipient_id => current_character._id)
  end
end