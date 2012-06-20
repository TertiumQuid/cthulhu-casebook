class PathsController < ApplicationController
  def show
    @encounter = Encounter.find(params[:encounter_id])
    @success = @encounter.play(current_character, params[:id])
    @path = @encounter.find_path(params[:id])
  end
end