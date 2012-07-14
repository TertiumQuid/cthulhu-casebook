module ActionPack
  module CharacterSupport
    extend ActiveSupport::Concern
    
    included do
      helper_method :current_character, :current_character_id, :has_character?
      before_filter :require_character
    end
    
    def current_character
      @current_character ||= Character.find(current_character_id)
      @current_character.last_seen if @current_character
      @current_character
    end
    
    def has_character?
      !current_character_id.blank?
    end
    
    def current_character_id
      session[:character_id]
    end
    
    def requested_new_character_path?
      new_character_path == request.path || (character_path == request.path && request.post?)
    end
    
    def authenticate_character(character_id)
      session[:character_id] = character_id
    end
    
    def require_character
      redirect_to new_character_path and return false unless has_character? || requested_new_character_path? || allow_unauthenticated?
    end

    def require_no_demise
      redirect_to location_path and return false if current_character && ['arkham_sanitarium', 'st_marys_hospital'].include?(current_character.location.value)
    end

    def require_monster
      redirect_to location_path and return false unless current_character && current_character.fighting_monster?
    end
    
    def require_no_monster
      redirect_to new_monster_path and return false if current_character && current_character.fighting_monster?
    end
  end
end
