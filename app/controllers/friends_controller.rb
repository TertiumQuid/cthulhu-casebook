class FriendsController < ApplicationController
  def index
    @friends = current_user.facebook_friends
    @characters = Character.find_for_users @friends.all.map(&:_id) if @friends
  end
end