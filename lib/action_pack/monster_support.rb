module ActionPack
  module MonsterSupport
    extend ActiveSupport::Concern
    
    included do
      helper_method :load_monster
    end
    
    def load_monster
      @monster = current_character.monster
    end
  end
end