require 'action_pack/user_support'
require 'action_pack/character_support'

class ApplicationController < ActionController::Base
  include ActionPack::UserSupport  
  include ActionPack::CharacterSupport
  
  protect_from_forgery
  
  def show
    if params[:character_id]
      @character = Character.find params[:character_id]
      session[:user_id] = @character.user_id
      authenticate_character @character._id
    end
  end
  
  private
  
  def allow_unauthenticated?
    params[:controller] == 'facebook' || # facebook servers must be allowed to make requests to specific pages withoout an authenticated user
    params[:controller] == 'help'        # anonymous visitors should be allowed to see the help pages
  end
end
