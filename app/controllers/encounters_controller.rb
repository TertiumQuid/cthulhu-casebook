class EncountersController < ApplicationController
  def show
    @encounter = Encounter.find(params[:id])
  end
end