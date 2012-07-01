class FriendsController < ApplicationController
  def index
    @friends = current_user.facebook_friends
    @characters = current_character.friends
    @importunity = Importunity.first(:user_id => current_character.user_id)
  end
end