class MessagesController < ApplicationController
  def index
    @messages = Message.find_readable(current_character)
    current_character.reset_messages_count
  end
  
  def show
    @message = Message.find_readable(current_character, params[:id])
  end
end