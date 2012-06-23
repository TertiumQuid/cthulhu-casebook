class MonstersController < ApplicationController
  before_filter :require_monster
  
  def new
    @monster = current_character.monster
  end
  
  def show
    @monster = current_character.monster
    @success = @monster.fight(current_character, params[:id])
  end
end