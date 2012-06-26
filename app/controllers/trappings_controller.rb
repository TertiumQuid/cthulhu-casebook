class TrappingsController < ApplicationController
  before_filter :load_items
  
  def update
    current_character.profile.trappings.equip! @equipment
    redirect_to edit_character_path
  end
  
  def destroy
    current_character.profile.trappings.unequip! params[:equipment_id]
    redirect_to edit_character_path   
  end
  
  private
  
  def load_items
    item = current_character.profile.get('equipment', params[:equipment_id])
    @equipment = Equipment.find(params[:equipment_id]) if item
    @location = params[:id]
    
    redirect_to edit_character_path and return if @equipment.blank?
  end
end