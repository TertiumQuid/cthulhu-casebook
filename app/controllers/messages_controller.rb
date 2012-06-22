class MessagesController < ApplicationController
  def index
    @messages = Message.find_readable(current_character)
    current_character.reset_messages_count
  end
  
  def show
    @message = current_character.messages.find(params[:id])
  end
end