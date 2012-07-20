require 'action_pack/user_support'
require 'action_pack/character_support'
require 'action_pack/location_support'
require 'action_pack/monster_support'

class ApplicationController < ActionController::Base
  include ActionPack::UserSupport  
  include ActionPack::CharacterSupport
  include ActionPack::LocationSupport
  include ActionPack::MonsterSupport
  
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
  
  def strip_pjax_param
    # REF: https://github.com/rails/pjax_rails/issues/39
    if request.env['QUERY_STRING'].frozen?
      request.env['QUERY_STRING'] = request.env['QUERY_STRING'].dup
    end
    super
  end  
end
