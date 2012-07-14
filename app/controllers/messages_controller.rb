class MessagesController < ApplicationController
  before_filter :require_no_demise, :only => [:index]
  
  def index
    @encounters = Encounter.find_location( 'lodgings' )
    @messages = Message.find_readable(current_character)
    current_character.reset_messages_count
  end
  
  def show
    @message = Message.find_readable(current_character, params[:id])
  end
end