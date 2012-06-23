module ActionPack
  module CharacterSupport
    extend ActiveSupport::Concern
    
    included do
      helper_method :current_character, :current_character_id, :has_character?
      before_filter :require_character
    end
    
    def current_character
      @current_character ||= Character.find(current_character_id)
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
      redirect_to new_character_path and return false unless has_character? || requested_new_character_path?
    end
    
    def require_no_monster
      redirect_to monster_path and return false if current_character && current_character.fighting_monster?
    end
  end
end
