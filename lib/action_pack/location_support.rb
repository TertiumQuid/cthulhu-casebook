module ActionPack
  module LocationSupport
    extend ActiveSupport::Concern
    
    included do
      helper_method :load_location, :load_location_friends 
    end
    
    def load_location
      @location = Location.find current_character.location.value
    end    
    
    def load_location_friends 
      @friends = current_character.local_friends
      @conferences = Conference.recent(current_character._id) unless @friends.blank?
    end
  end
end