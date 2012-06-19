require 'action_pack/user_support'
require 'action_pack/character_support'

class ApplicationController < ActionController::Base
  include ActionPack::UserSupport  
  include ActionPack::CharacterSupport
  
  protect_from_forgery
  
  def show
  end
end
